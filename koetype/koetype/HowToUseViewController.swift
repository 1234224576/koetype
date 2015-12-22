//
//  HowToUseViewController.swift
//  koetype
//
//  Created by 曽和 on 2015/12/20.
//  Copyright © 2015年 曽和修平. All rights reserved.
//

import UIKit
import MessageUI
class HowToUseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {

    
    
    @IBOutlet weak var tableView: UITableView!
    let howtouseTitles = ["マイ声優とは？","マイ声優に登録するには？","記事をお気に入りに登録するには？","見たい声優が登録されていない！","快適に記事を読むために"]
    let howtouseContents = ["マイ声優とは、自分のお気に入りの声優のことです！\nマイ声優に登録すると、その声優の記事だけのタイムラインが出来たり、記事が更新されたらプッシュ通知で教えてくれたりします！",
                            "マイ声優は、その声優の記事ページから右上にあるメニューを開いてマイ声優を登録を選択するか、登録したい声優の記事のセルを長押しすることで登録できます！\nマイ声優から削除したいときは、マイ声優一覧から削除したい声優のセルを左スワイプする事で削除できます。",
                            "お気に入り登録は、その声優の記事ページから右上にあるメニューを開いてマお気に入り登録を選択することで出来ます！\nお気に入り登録を削除するには、お気に入り記事から削除したい記事のセルを左にスワイプすることで削除できます。",
                            "もし見たい声優のブログがないときは、下のお問い合わせからメールを送って下さい！迅速に対応致します！",
                            "ブログページから戻りたいときは左上のXボタンを押すだけではなく、記事のどこでもいいので「ダブルタップ」すると戻ることができます！"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        self.title = "よくある質問"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.font = UIFont(name: "HiraKakuProN-W4", size: 14)
        if(indexPath.section==0){
            cell.textLabel?.text = howtouseTitles[indexPath.row]
        }else{
            if(indexPath.row==0){
                cell.textLabel?.text = "お問い合わせ"
            }else if(indexPath.row==1){
                cell.textLabel?.text = "レビューお願いします"
            }else{
                cell.textLabel?.text = "DEEP TONE WORKS"
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return howtouseTitles.count
        }
        return 3
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel(frame: CGRectMake(0, 0, 200, 22))
        
        if(section==0){
            header.text = "よくある質問"
        }else{
            header.text = "その他"
        }
        header.font = UIFont(name: "HiraKakuProN-W6", size: 12)
        return header
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section==0){
            let pop = Popup(title: howtouseTitles[indexPath.row], subTitle: howtouseContents[indexPath.row], cancelTitle: "close", successTitle:nil)
            pop.backgroundBlurType = .Dark
            pop.incomingTransition = .EaseFromCenter
            pop.showPopup()
        }else{
            
            if(indexPath.row==0){
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setSubject("お問い合わせ")
                mail.setToRecipients(["deeptoneworks@gmail.com"])
                mail.setMessageBody("", isHTML: false)
                self.presentViewController(mail, animated: true, completion: nil)
            }else if(indexPath.row==1){
                let url = NSURL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1016997602")
                let app:UIApplication = UIApplication.sharedApplication()
                app.openURL(url!)
            }else{
                let url = NSURL(string:"http://deeptoneworks.com/")
                let app:UIApplication = UIApplication.sharedApplication()
                app.openURL(url!)
            }
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultSent.rawValue:
            let alert = UIAlertController(title: "送信しました。", message: "", preferredStyle:.Alert)
            let okbutton = UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: {
                action in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okbutton)
            self.presentViewController(alert, animated: true, completion: nil)
            break
        case MFMailComposeResultFailed.rawValue:
            let alert = UIAlertController(title: "送信に失敗しました。", message: "", preferredStyle:.Alert)
            let okbutton = UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: {
                action in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alert.addAction(okbutton)
            self.presentViewController(alert, animated: true, completion: nil)
            break
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
