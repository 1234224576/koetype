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
class TopViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    enum Mode{
        case New
        case Popular
        case MyVoiceActressList
        case MyVoiceActressArticle
        case Favorite
    }

    @IBOutlet weak var tableView: UITableView!
   
    let baseUrl = "http://deeptoneworks.com/voice_actress/voice/public/voiceActress.json"
    var isLoading = false;
    let kOnceLoadArticle = 20
    var page : Int = 1
    var responseJsonData:JSON?
    var params = ["limit" : "20"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MagicalRecord.setupCoreDataStack()
        self.setupNavigation()
        
        let notification = NSNotificationCenter.defaultCenter()
        notification.addObserver(self, selector: "changeMode:", name: "changeMode", object: nil)
        
        self.title = "新着"
        self.tableView.registerNib(UINib(nibName: "TopTableViewCell", bundle: nil), forCellReuseIdentifier: "TopTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        SVProgressHUD.show()
        self.loadArticle()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.addPullToRefreshWithActionHandler({[weak self]()in
            if let weakself = self{
                weakself.loadArticle()
            }
        })
    }
    func setupNavigation(){
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.33, green:0.62, blue: 0.82, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        let menuButton = UIBarButtonItem(image:UIImage(named: "Icon_Menu")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: "presentLeftMenuViewController:")
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    //Notification Observer
    func changeMode(center:NSNotification){
        //通知を受け取る
        self.params.removeAll(keepCapacity: false)
        self.page = 1
        //WARNING スクロールバーを一番上へ
        if let dic = center.userInfo{
            switch dic["Mode"] as! String{
                case "New":
                    self.title = "新着"
                self.setApiParameterWithNew()
                case "Popular":
                    print("人気")
                    self.title = "今週の人気記事"
                    self.setApiParameterWithPopular()
                case "MyActressList":
                    self.title = "マイ声優一覧"
                self.setApiParameterWithMyActressList()
                case "MyActressArticle":
                    self.title = "マイ声優の記事一覧"
                    print("声優記事")
                    self.setApiParameterWithMyActressArticle()
                case "Favorite":
                    self.title = "お気に入り"
                    print("お気に入り")
                    self.setApiParameterWithFavorite()
                default:
                    break;
                
            }
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
    func setApiParameterWithMyActressList(){
        
    }
    func setApiParameterWithMyActressArticle(){
        
    }
    func setApiParameterWithFavorite(){
        let favorits = Favorite.MR_findAll()
        var ids = ""
        for favorite in favorits{
            print(favorite.article_id)
            ids += "\(favorite.article_id)"
            ids += ","
        }
        self.params["isPopular"] = "3"
        self.params["id"] = ids
        self.loadArticle()
    }
    
    
    //MARK: -UITableViewDelegate,Datasorce

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let json = self.responseJsonData{
            return min(self.page * kOnceLoadArticle,json["feed"].count)
        }
        return self.page * kOnceLoadArticle
    }
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainWebViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainWebViewController") as! MainWebViewController
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TopTableViewCell
        if let url = cell.url,name = cell.nameLabel.text,articleId = cell.articleId,date = cell.dateLabel.text{
            mainWebViewController.url = url
            mainWebViewController.actressName = name
            mainWebViewController.articleId = articleId
            mainWebViewController.articleDate = date
        }
        let navigationController = UINavigationController(rootViewController: mainWebViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
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
    private func publishedStringToDate(publishStr:String)->String{
        let dateStr = (publishStr as NSString).substringToIndex(10)
        return dateStr
    }
    
    
    deinit{
        self.removeObserver(self, forKeyPath: "changeMode")
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
