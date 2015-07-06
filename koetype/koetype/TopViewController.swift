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
                    weakSelf.responseJsonData = weakSelf.deleteFutureArticle(json)
                    weakSelf.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    if let p = weakSelf.tableView.pullToRefreshView{
                        p.stopAnimating()
                    }
                }
            })
    }
    
    private func deleteFutureArticle(json:JSON?)->JSON{
        var jsonDataArray :[JSON] = []
        if let j = json{
            
            for (i,data) in j["feed"]{
                let publishdateString = self.publishedStringToDate(data["published"].string!)
                let dateStrings = publishdateString.componentsSeparatedByString("-")
                let year = dateStrings[0]
                let month = dateStrings[1]
                let day = dateStrings[2]
                let publishDate = NSDateComponents()
                publishDate.month = month.toInt()!
                publishDate.year = year.toInt()!
                publishDate.day = day.toInt()!
                let result:NSComparisonResult = NSDate().compare(NSCalendar.currentCalendar().dateFromComponents(publishDate)!)
                if(result != NSComparisonResult.OrderedAscending){
                    jsonDataArray.append(data)
                }
            }
        }
        return JSON(jsonDataArray);
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
            if json[indexPath.row] != nil{
                cell.titleLabel.text = json[indexPath.row]["title"].string
                cell.nameLabel.text = json[indexPath.row]["media"].string
                cell.dateLabel.text = publishedStringToDate(json[indexPath.row]["published"].string!)
                cell.url = json[indexPath.row]["link"].string
                cell.articleId = json[indexPath.row]["id"].string?.toInt()
            }
        }
        return cell
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height{
            if self.isLoading{
                return
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
