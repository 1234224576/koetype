//
//  TopViewController.swift
//  koetype
//
//  Created by 曽和修平 on 2015/06/08.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON
import SVProgressHUD
import SVPullToRefresh
import MagicalRecord

class TopViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var isNewMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MagicalRecord.setupCoreDataStack()
        super.setupNavigation()

        self.tableView.registerNib(UINib(nibName: "TopTableViewCell", bundle: nil), forCellReuseIdentifier: "TopTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        SVProgressHUD.show()
        self.setupMode()
        self.loadArticle()
    }
    override func viewWillAppear(animated: Bool) {
        if let indexPath = self.tableView.indexPathForSelectedRow(){
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    override func viewDidAppear(animated: Bool) {
        self.tableView.addPullToRefreshWithActionHandler({[weak self]()in
            if let weakself = self{
                weakself.loadArticle()
            }
        })
    }
    
    //新着or人気記事
    func setupMode(){
        self.params.removeAll(keepCapacity: false)
        self.page = 1
        //WARNING スクロールバーを一番上へ
        if isNewMode{
            self.title = "新着"
            self.setApiParameterWithNew()
        }else{
            self.title = "今週の人気記事"
            self.setApiParameterWithPopular()
        }
    }
    
    
    func loadArticle(){
        self.isLoading = true;
        print(self.params)
        self.params["limit"] = "\(self.page * kOnceLoadArticle)"
        Alamofire.request(.GET, baseUrl,parameters: self.params)
            .responseSwiftyJSON({[weak self] (request, response, json, error) in
                if let weakSelf = self{
                    weakSelf.isLoading = false;
                    weakSelf.responseJsonData = json
                    weakSelf.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    weakSelf.tableView.pullToRefreshView.stopAnimating()
                }
            })
    }
    
    //MARK: -SetApiParameters
    func setApiParameterWithNew(){
        self.loadArticle()
    }
    func setApiParameterWithPopular(){
        self.params["isPopular"] = "1"
        self.params["kindPopular"] = "1"
        self.loadArticle()
    }
    
    //MARK: -UITableViewDelegate,Datasorce
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TopTableViewCell", forIndexPath: indexPath) as! TopTableViewCell
        if let json = self.responseJsonData{
            if json["feed"][indexPath.row] != nil{
                cell.titleLabel.text = json["feed"][indexPath.row]["title"].string
                cell.nameLabel.text = json["feed"][indexPath.row]["media"].string
                cell.dateLabel.text = publishedStringToDate(json["feed"][indexPath.row]["published"].string!)
                cell.url = json["feed"][indexPath.row]["link"].string
                cell.articleId = json["feed"][indexPath.row]["id"].string?.toInt()
            }
        }
        return cell
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height{
            if self.isLoading{
                return
            }
            if let json = self.responseJsonData{
                if self.page * kOnceLoadArticle > json["feed"].count{
                    return
                }
            }
            self.page+=1
            self.loadArticle()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
