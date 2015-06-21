//
//  MyVoiceActressListViewController.swift
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
class MyVoiceActressListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var actressList = []
    override func viewDidLoad() {
        super.viewDidLoad()
        MagicalRecord.setupCoreDataStack()
        self.setupNavigation()
        self.title = "マイ声優一覧"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadActressData()
    }
    
    func loadActressData(){
        self.actressList = MyVoiceActress.MR_findAll()
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
      
        let actress:MyVoiceActress = self.actressList[indexPath.row] as! MyVoiceActress
        cell.textLabel?.text = actress.name
        return cell
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return Int(MyVoiceActress.MR_findAll().count)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let mainWebViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainWebViewController") as! MainWebViewController
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TopTableViewCell
//        if let url = cell.url,name = cell.nameLabel.text,articleId = cell.articleId,date = cell.dateLabel.text{
//            mainWebViewController.url = url
//            mainWebViewController.actressName = name
//            mainWebViewController.articleId = articleId
//            mainWebViewController.articleDate = date
//        }
//        let navigationController = UINavigationController(rootViewController: mainWebViewController)
//        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if let name = cell?.textLabel?.text{
                let actress : MyVoiceActress? = MyVoiceActress.MR_findFirstByAttribute("name", withValue: name) as? MyVoiceActress
                if let a = actress{
                    a.MR_deleteEntity()
                    self.loadActressData()
                }
            }
        }
    }

    func setupNavigation(){
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.33, green:0.62, blue: 0.82, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        let menuButton = UIBarButtonItem(image:UIImage(named: "Icon_Menu")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: "presentLeftMenuViewController:")
        self.navigationItem.leftBarButtonItem = menuButton
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
