//
//  LongPressService.swift
//  koetype
//
//  Created by 曽和 on 2015/12/19.
//  Copyright © 2015年 曽和修平. All rights reserved.
//

import Foundation
import UIKit
class LongPressService:NSObject,UIGestureRecognizerDelegate{
    private var rootViewController:UIViewController?
    private var tableView:UITableView?
  
    func setUpLongPressRecognizer(rootViewController:UIViewController,tableView:UITableView){
        self.rootViewController = rootViewController
        self.tableView = tableView
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
        
    }

    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        guard let tableView = self.tableView else{
            return
        }
        
        let point = recognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        if recognizer.state == .Began  {
            if let ip = indexPath{
                addMyActress(tableView, indexPath: ip)
            }
        }
        
    }
    
    private func addMyActress(tableView: UITableView,indexPath:NSIndexPath){
        guard let rootViewController = self.rootViewController else{
            return
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TopTableViewCell
        if let name = cell.nameLabel.text{
            let searchActress : MyVoiceActress? = MyVoiceActress.MR_findFirstByAttribute("name", withValue:name)
            let confirmAlert = UIAlertController(title: "", message: "\(name)を登録しますか?", preferredStyle: .Alert)
            let acceptAction = UIAlertAction(title: "OK", style: .Default){ (action:UIAlertAction) -> Void in
                if (searchActress == nil){
                    let magicalContext = NSManagedObjectContext.MR_defaultContext()
                    let myactress = MyVoiceActress.MR_createEntity() as MyVoiceActress
                    myactress.name = name
                    myactress.date = NSDate()
                    magicalContext.MR_saveToPersistentStoreAndWait()
                    NCMBService().synchronizedFavoriteActoress()
                    self.showCompletedAlert("登録完了しました")
                }else{
                    self.showCompletedAlert("既に登録しています")
                }
            }
            let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel,handler:nil)
            confirmAlert.addAction(acceptAction)
            confirmAlert.addAction(cancelAction)
            rootViewController.presentViewController(confirmAlert, animated: true, completion: nil)
        }
    }
    private func showCompletedAlert(mes:String){
        let alert = UIAlertController(title: "", message:mes, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        if let rootViewController = self.rootViewController{
            rootViewController.presentViewController(alert, animated: true, completion: nil)
        }
    }
}