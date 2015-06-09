//
//  MainWebViewController.swift
//  koetype
//
//  Created by 曽和修平 on 2015/06/08.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import WebKit

class MainWebViewController: UIViewController,WKNavigationDelegate {
    var url = ""
    var webview = WKWebView()
    
    var progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        
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
    
    func setupNavigationBar(){
        let closeButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItemStyle.Plain, target: self, action: "closeModalView")
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    func closeModalView(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.removeObserver(self, forKeyPath: "title")
        self.webview.removeObserver(self, forKeyPath: "loading")
        self.webview.removeObserver(self, forKeyPath: "canGoBack")
        self.webview.removeObserver(self, forKeyPath: "canGoForward")
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
