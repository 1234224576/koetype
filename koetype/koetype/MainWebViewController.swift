//
//  MainWebViewController.swift
//  koetype
//
//  Created by 曽和修平 on 2015/06/08.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import WebKit
import MagicalRecord
import Social
import MessageUI

class MainWebViewController: UIViewController,WKNavigationDelegate,FCVerticalMenuDelegate {
    var url = ""
    var webview = WKWebView()
    var verticalMenu = FCVerticalMenu()
    var actressName = ""
    var articleId = -1
    var articleDate = ""
    
    var progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        MagicalRecord.setupCoreDataStack()
        
        self.setupNavigationBar()
        self.setupVerticalMenu()
        
        //デバッグ用に声優の名前を表示してみるてすと
//        print(actressName)
//        print(articleId)
//        print(url)
//        print("\n")
        
        self.webview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.webview.navigationDelegate = self
        self.webview.allowsBackForwardNavigationGestures = true
        
        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        self.webview.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        self.webview.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        self.webview.addObserver(self, forKeyPath: "canGoBack", options: .New, context: nil)
        self.webview.addObserver(self, forKeyPath: "canGoForward", options: .New, context: nil)
        
        self.view.addSubview(self.webview)
        
        self.progressView.frame = CGRectMake(0,64,self.view.frame.size.width,10)
        self.progressView.progress = 0
        self.progressView.hidden = true
        self.view.addSubview(self.progressView)
    
        
        if let u =  NSURL(string: self.url){
            self.webview.loadRequest(NSURLRequest(URL: u))
        }
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.33, green:0.62, blue: 0.82, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Default
        let closeButton = UIBarButtonItem(image:UIImage(named: "Icon_Close")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: "closeModalView")
        self.navigationItem.leftBarButtonItem = closeButton
        
        let menuButton = UIBarButtonItem(image:UIImage(named: "Icon_WebMenu")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: .Plain, target: self, action: "openVerticalMenu")
        self.navigationItem.rightBarButtonItem = menuButton
    }
    
    func setupVerticalMenu(){
        self.verticalMenu.delegate = self
        self.verticalMenu.borderColor = UIColor.clearColor()
        self.verticalMenu.liveBlurBackgroundStyle = .Default

        let item1 = FCVerticalMenuItem(title: "Twitter", andIconImage: UIImage(named: "Icon_Twitter"))
        let item2 = FCVerticalMenuItem(title: "Facebook", andIconImage: UIImage(named: "Icon_Facebook"))
        let item3 = FCVerticalMenuItem(title: "Safariで見る", andIconImage: UIImage(named: "Icon_Safari"))
        let item4 = FCVerticalMenuItem(title: "お気に入り登録", andIconImage: UIImage(named: "Icon_Star"))
        let item5 = FCVerticalMenuItem(title: "マイ声優に登録", andIconImage: UIImage(named: "Icon_Heart"))
        let item6 = FCVerticalMenuItem(title: "記事を通報", andIconImage: UIImage(named: "Icon_Mail"))
        item1.actionBlock = {
            //Twitterシェア
            let twitter = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            if let url = self.webview.URL,title = self.webview.title{
                twitter.setInitialText("\(title)\n\(url)")
            }
            self.presentViewController(twitter, animated: true, completion: nil)
        }
        item2.actionBlock = {
            //Facebookシェア
            let facebook = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            if let url = self.webview.URL,title = self.webview.title{
                facebook.setInitialText("\(title)\n\(url)")
            }
            self.presentViewController(facebook, animated: true, completion: nil)
        }
        item3.actionBlock = {
            //Show Safari
            if let url = self.webview.URL{
                UIApplication.sharedApplication().openURL(url)
            }
        }
        item4.actionBlock = {
            //Add Favorite
            let magicalContext = NSManagedObjectContext.MR_defaultContext()
            let fav = Favorite.MR_createEntity() as! Favorite
            fav.article_id = self.articleId
            fav.name = self.actressName
            let dateFormatter : NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.dateFromString(self.articleDate)
            if let d = date{
                fav.date = d
            }
            magicalContext.MR_saveOnlySelfAndWait()
        }
        item5.actionBlock = {
            //Add My Voice Actress
            let magicalContext = NSManagedObjectContext.MR_defaultContext()
            let myactress = MyVoiceActress.MR_createEntity() as! MyVoiceActress
            myactress.name = self.actressName
            myactress.date = NSDate()
            magicalContext.MR_saveOnlySelfAndWait()
        }
        item6.actionBlock = {
            //Send Mail
            if(MFMailComposeViewController.canSendMail()){
                let alert = UIAlertController(title: "Error", message: "メーラーの起動に失敗しました。", preferredStyle:.Alert)
                let okbutton = UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: {
                    action in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(okbutton)
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                let mail = MFMailComposeViewController()
                mail.setSubject("記事を通報")
                mail.setToRecipients(["deeptoneworks@gmail.com"])
                mail.setMessageBody("内容:\n\n対象URL:\(self.url)", isHTML: false)
                self.presentViewController(mail, animated: true, completion: nil)
            }
            
        }
        self.verticalMenu.items = [item1,item2,item3,item4,item5,item6]
        self.verticalMenu.appearsBehindNavigationBar = true
        self.verticalMenu.highlightedBackgroundColor = UIColor.whiteColor()
        
    }

    
    func openVerticalMenu(){
        if self.verticalMenu.isOpen{
            return self.verticalMenu.dismissWithCompletionBlock(nil)
        }
        self.verticalMenu.showFromNavigationBar(self.navigationController?.navigationBar, inView: self.view)
    }
    
    func closeModalView(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "title"{
            self.title = self.webview.title
        }
        
        if keyPath == "loading"{
            self.progressView.hidden = !self.progressView.hidden
        }
        
        if keyPath == "estimatedProgress"{
            self.progressView.setProgress(Float(self.webview.estimatedProgress), animated: true)
        }
    }
    
    deinit{
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.removeObserver(self, forKeyPath: "title")
        self.webview.removeObserver(self, forKeyPath: "loading")
        self.webview.removeObserver(self, forKeyPath: "canGoBack")
        self.webview.removeObserver(self, forKeyPath: "canGoForward")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
