//
//  MyVoiceActressArticleViewController.swift
//  koetype
//
//  Created by 曽和修平 on 2015/06/21.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON
import SVProgressHUD
import MagicalRecord
class MyVoiceActressArticleViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        MagicalRecord.setupCoreDataStack()
        super.setupNavigation()
        self.title = "マイ声優記事"
        self.tableView.registerNib(UINib(nibName: "TopTableViewCell", bundle: nil), forCellReuseIdentifier: "TopTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        SVProgressHUD.show()
        self.setApiParameterWithFavorite()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let indexPath = self.tableView.indexPathForSelectedRow(){
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func loadArticle(){
        self.isLoading = true;
        self.params["limit"] = "\(self.page * kOnceLoadArticle)"
        Alamofire.request(.GET, baseUrl,parameters: self.params)
            .responseSwiftyJSON({[weak self] (request, response, json, error) in
                if let weakSelf = self{
                    weakSelf.isLoading = false;
                    weakSelf.responseJsonData = json
                    weakSelf.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            })
    }
    
    func setApiParameterWithFavorite(){
        let actresses = MyVoiceActress.MR_findAll()
        var names = ""
        for actress in actresses{
            names += "\(actress.name)"
            names += ","
        }
        self.params["isPopular"] = "3"
        self.params["keyword"] = names
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
