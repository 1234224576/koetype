//
//  MainWebViewController.swift
//  koetype
//
//  Created by 曽和修平 on 2015/06/08.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import WebKit

class MainWebViewController: UIViewController,WKNavigationDelegate,FCVerticalMenuDelegate {
    var url = ""
    var webview = WKWebView()
    var verticalMenu = FCVerticalMenu()
    
    var progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupVerticalMenu()
        
        
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
        
        }
        item2.actionBlock = {
            //Facebookシェア
        
        }
        item3.actionBlock = {
            //Show Safari
        
        }
        item4.actionBlock = {
            //Add Favorite
        
        }
        item5.actionBlock = {
            //Add My Voice Actress
            
        }
        item6.actionBlock = {
            //Send Mail
            
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
