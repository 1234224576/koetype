//
//  LeftMenuViewController.swift
//  
//
//  Created by 曽和修平 on 2015/06/08.
//
//

import UIKit

class LeftMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    enum Menu:Int{
        case New
        case Popular
        case MyActressList
        case MyActressArticle
        case Favorite
        case Search
        case Setting
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "LeftMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "LeftMenuTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(animated: Bool) {
       self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
    }
    
    //MARK: -UITableViewDelegate,Datasorce
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeftMenuTableViewCell", forIndexPath: indexPath) as! LeftMenuTableViewCell

        switch indexPath.row{
            case Menu.New.rawValue:
                cell.nameLabel.text = "新着記事"
                cell.iconImageView.image = UIImage(named: "Menu_New")
            case Menu.Popular.rawValue:
                cell.nameLabel.text = "人気記事"
                cell.iconImageView.image = UIImage(named: "Menu_Popular")
            case Menu.MyActressList.rawValue:
                cell.nameLabel.text = "My声優一覧"
                cell.iconImageView.image = UIImage(named: "Menu_MyActressList")
            case Menu.MyActressArticle.rawValue:
                cell.nameLabel.text = "My声優記事一覧"
                cell.iconImageView.image = UIImage(named: "Menu_MyActressArticle")
            case Menu.Favorite.rawValue:
                cell.nameLabel.text = "お気に入り"
                cell.iconImageView.image = UIImage(named: "Menu_Favorite")
            case Menu.Search.rawValue:
                cell.nameLabel.text = "検索"
                cell.iconImageView.image = UIImage(named: "Menu_Search")
            case Menu.Setting.rawValue:
                cell.nameLabel.text = "設定"
                cell.iconImageView.image = UIImage(named: "Menu_Setting")
            default:
                cell.nameLabel.text = ""
                cell.iconImageView.image = UIImage(named: "")
        }
        cell.backgroundColor = UIColor.clearColor()
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nc = NSNotificationCenter.defaultCenter()

        if let storyboard = self.storyboard{
            switch indexPath.row{
                case Menu.New.rawValue:
                    let rootvc = storyboard.instantiateViewControllerWithIdentifier("topViewController")as! TopViewController
                    rootvc.isNewMode = true;
                    let vc = UINavigationController(rootViewController: rootvc)
                    self.sideMenuViewController.setContentViewController(vc, animated: true)
                case Menu.Popular.rawValue:
                    let rootvc = storyboard.instantiateViewControllerWithIdentifier("topViewController")as! TopViewController
                    rootvc.isNewMode = false;
                    let vc = UINavigationController(rootViewController: rootvc)
                    self.sideMenuViewController.setContentViewController(vc, animated: true)
                
                case Menu.MyActressList.rawValue:
                    let vc = UINavigationController(rootViewController: storyboard.instantiateViewControllerWithIdentifier("MyVoiceActressList")as! UIViewController)
                    self.sideMenuViewController.setContentViewController(vc, animated: true)
                case Menu.MyActressArticle.rawValue:
                    let vc = UINavigationController(rootViewController: storyboard.instantiateViewControllerWithIdentifier("MyVoiceActressArticle")as! UIViewController)
                    self.sideMenuViewController.setContentViewController(vc, animated: true)
                case Menu.Favorite.rawValue:
                    let vc = UINavigationController(rootViewController: storyboard.instantiateViewControllerWithIdentifier("FavoriteViewController")as! UIViewController)
                    self.sideMenuViewController.setContentViewController(vc, animated: true)
                case Menu.Search.rawValue:
                    let vc = UINavigationController(rootViewController: storyboard.instantiateViewControllerWithIdentifier("SearchViewController")as! UIViewController)
                    self.sideMenuViewController.setContentViewController(vc, animated: true)
                    break
                case Menu.Setting.rawValue:
                    //画面遷移
                    break
                default:
                    print("notification error")
            }
        }
        self.sideMenuViewController.hideMenuViewController()
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
