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

class MainWebViewController: UIViewController,WKNavigationDelegate,FCVerticalMenuDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate {
    var url = ""
    var webview = WKWebView()
    var verticalMenu = FCVerticalMenu()
    var actressName = ""
    var articleId = -1
    var articleDate = ""
    var scrollOffset:CGFloat = -1
    var progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.setupNavigationBar()
        self.setupVerticalMenu()
        
        if let nav = self.navigationController?.navigationBar{
            let margin = nav.frame.size.height + UIApplication.sharedApplication().statusBarFrame.height
            self.webview.frame = CGRectMake(0, margin, self.view.frame.size.width, self.view.frame.size.height - margin)
        }
        
        self.webview.scrollView.delegate = self;
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
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapGesture.delegate = self
        doubleTapGesture.numberOfTapsRequired = 2
        self.webview.addGestureRecognizer(doubleTapGesture)
        self.webview.scrollView.addGestureRecognizer(doubleTapGesture)
        
        if let u =  NSURL(string: self.url){
            self.webview.loadRequest(NSURLRequest(URL: u))
        }
    }
    
    func doubleTap(sender:UITapGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
            
            let searchFav : Favorite? = Favorite.MR_findFirstByAttribute("article_id", withValue: self.articleId) as? Favorite
            
            var alertString = "既に登録しています"
            if (searchFav == nil){
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
                alertString = "登録完了しました"
            }
            //show alert
            let alert = UIAlertController(title: "", message: alertString, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        item5.actionBlock = {
            let searchActress : MyVoiceActress? = MyVoiceActress.MR_findFirstByAttribute("name", withValue: self.actressName) as? MyVoiceActress
            var alertString = "既に登録しています"
            if (searchActress == nil){
                //Add My Voice Actress
                let magicalContext = NSManagedObjectContext.MR_defaultContext()
                let myactress = MyVoiceActress.MR_createEntity() as! MyVoiceActress
                myactress.name = self.actressName
                myactress.date = NSDate()
                magicalContext.MR_saveOnlySelfAndWait()
                alertString = "登録完了しました"
            }
            //show alert
            let alert = UIAlertController(title: "", message: alertString, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
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
            print(self.progressView.progress)
            print("\n")
            self.progressView.setProgress(Float(self.webview.estimatedProgress), animated: true)
        }
    }
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.setProgress(0, animated: false)
    }
    
    func hideNavigationBar(){
        self.scrollOffset = -1
        if let nav = self.navigationController?.navigationBar{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                nav.frame = CGRectMake(nav.frame.origin.x, -nav.frame.size.height, nav.frame.size.width, nav.frame.size.height)
                self.webview.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)
            }, completion: {(_:Bool) -> Void in
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.progressView.frame = CGRectMake(0,0,self.view.frame.size.width,10)

            })
        }
    }
    func showNavigationBar(){
        self.scrollOffset = -1
        if let nav = self.navigationController?.navigationBar{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                nav.frame = CGRectMake(nav.frame.origin.x,UIApplication.sharedApplication().statusBarFrame.height, nav.frame.size.width, nav.frame.size.height)
            },completion:{(_:Bool) -> Void in
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.progressView.frame = CGRectMake(0,64,self.view.frame.size.width,10)
            })
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                let margin = nav.frame.size.height + UIApplication.sharedApplication().statusBarFrame.height
                self.webview.frame = CGRectMake(0, margin, self.view.frame.size.width, self.view.frame.size.height - margin)
            })
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        if scrollOffset == -1{
            return
        }
        
        if let isNavHidden = self.navigationController?.navigationBarHidden{
            if !isNavHidden && self.scrollOffset < (scrollView.contentOffset.y){
                self.hideNavigationBar()
            }else if isNavHidden && self.scrollOffset > (scrollView.contentOffset.y){
                self.showNavigationBar()
            }
        }
    }
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        self.scrollOffset = scrollView.contentOffset.y
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
