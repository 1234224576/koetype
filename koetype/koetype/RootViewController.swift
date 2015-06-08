//
//  ViewController.swift
//  koetype
//
//  Created by 曽和修平 on 2015/05/30.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import RESideMenu

class RootViewController: RESideMenu,RESideMenuDelegate {
    
    override func awakeFromNib() {
        self.delegate = self
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        self.contentViewShadowColor = UIColor.blackColor()
        self.contentViewShadowOffset = CGSizeMake(0, 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        
        if let storyboard = self.storyboard{
            self.contentViewController = storyboard.instantiateViewControllerWithIdentifier("contentViewController") as! UIViewController
            self.leftMenuViewController = storyboard.instantiateViewControllerWithIdentifier("leftMenuViewController") as! UIViewController
            self.backgroundImage = UIImage(named: "Stars")
        }
    }

    //RESideMenuDelegate
    func sideMenu(sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
//        print("didHideMenu")
    }
    func sideMenu(sideMenu: RESideMenu!, didRecognizePanGesture recognizer: UIPanGestureRecognizer!) {
//        print("didRecgnizePanGesture")
    }
    func sideMenu(sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
//        print("didShowMenu")
    }
    func sideMenu(sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
//        print("willHideMenu")
    }
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
//        print("willShowMenu")
    }

}

