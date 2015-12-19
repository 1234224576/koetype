//
//  BaseViewController.swift
//  koetype
//
//  Created by 曽和修平 on 2015/06/21.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import MagicalRecord

class BaseViewController: UIViewController{
    
    let baseUrl = "http://deeptoneworks.com/voice_actress/voice/public/voiceActress.json"
    var isLoading = false;
    let kOnceLoadArticle = 20
    var page : Int = 1
    var responseJsonData:JSON?
    var params = ["limit" : "20"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setupNavigation(){
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.33, green:0.62, blue: 0.82, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        let menuButton = UIBarButtonItem(image:UIImage(named: "Icon_Menu")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: "presentLeftMenuViewController:")
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let json = self.responseJsonData{
            return min(self.page * kOnceLoadArticle,json.count)
        }
        return self.page * kOnceLoadArticle
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
    
    
    func publishedStringToDate(publishStr:String)->String{
        let dateStr = (publishStr as NSString).substringToIndex(10)
        return dateStr
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
