//
//  FavoriteViewController.swift
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

class FavoriteViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MagicalRecord.setupCoreDataStack()
        super.setupNavigation()
        self.title = "お気に入り"
        self.tableView.registerNib(UINib(nibName: "TopTableViewCell", bundle: nil), forCellReuseIdentifier: "TopTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        SVProgressHUD.show()
        self.setApiParameterWithFavorite()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        if let indexPath = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func loadArticle(){
        self.isLoading = true;
        
        print(self.params, terminator: "")
        self.params["limit"] = "\(self.page * kOnceLoadArticle)"
        ArticleProvider().fetchArticle(self.params){(json:JSON?,error:ArticleProviderError?) -> Void in
            self.isLoading = false;
            self.responseJsonData = json
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    func setApiParameterWithFavorite(){
        let favorits = Favorite.MR_findAll()
        var ids = ""
        for favorite in favorits{
            print(favorite.article_id, terminator: "")
            ids += "\(favorite.article_id)"
            ids += ","
        }
        self.params["isPopular"] = "4"
        self.params["id"] = ids
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
                cell.articleId = Int((json[indexPath.row]["id"].string)!)
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete{
            let magicalContext = NSManagedObjectContext.MR_defaultContext()
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TopTableViewCell
            if let articleId = cell.articleId{
                let fav : Favorite? = Favorite.MR_findFirstByAttribute("article_id", withValue: articleId) as Favorite
                fav!.MR_deleteEntity()
                magicalContext.MR_saveToPersistentStoreAndWait()
                setApiParameterWithFavorite()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
