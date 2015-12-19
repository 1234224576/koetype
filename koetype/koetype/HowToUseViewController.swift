//
//  HowToUseViewController.swift
//  koetype
//
//  Created by 曽和 on 2015/12/20.
//  Copyright © 2015年 曽和修平. All rights reserved.
//

import UIKit

class HowToUseViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        self.title = "使い方"
//        self.tableView.registerNib(UINib(nibName: "TopTableViewCell", bundle: nil), forCellReuseIdentifier: "TopTableViewCell")
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
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
