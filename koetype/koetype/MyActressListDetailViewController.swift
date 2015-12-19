//
//  MyActressListDetailViewController.swift
//  koetype
//
//  Created by 曽和修平 on 2015/06/21.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class MyActressListDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var actressName = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        super.setupNavigation()
        self.navigationItem.leftBarButtonItem = nil
  
        self.title = "\(self.actressName)の記事"
        self.tableView.registerNib(UINib(nibName: "TopTableViewCell", bundle: nil), forCellReuseIdentifier: "TopTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        SVProgressHUD.show()
        self.loadArticle()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        if let indexPath = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    //MARK: -UITableViewDelegate,Datasorce
    
    func loadArticle(){
        self.isLoading = true;
        self.params["isPopular"] = "2"
        self.params["keyword"] = self.actressName
        self.params["limit"] = "999"
        ArticleProvider().fetchArticle(self.params){(json:JSON?,error:ArticleProviderError?) -> Void in
            self.isLoading = false;
            self.responseJsonData = json
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TopTableViewCell", forIndexPath: indexPath) as! TopTableViewCell
        if let json = self.responseJsonData{
            if json[indexPath.row] != nil{
                cell.setUpCell()
                cell.titleLabel.text = json[indexPath.row]["title"].string
                cell.nameLabel.text = json[indexPath.row]["media"].string
                cell.dateLabel.text = publishedStringToDate(json[indexPath.row]["published"].string!)
                cell.url = json[indexPath.row]["link"].string
                cell.articleId = Int((json[indexPath.row]["id"].string)!)
                cell.setNameLabelColor(ArticleProvider.isMyActress(cell.nameLabel.text!))
                cell.favIcon.hidden = !ArticleProvider.isFavorite(cell.articleId!)
            }
        }
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let json = self.responseJsonData{

            return json.count
        }
        return 0
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
