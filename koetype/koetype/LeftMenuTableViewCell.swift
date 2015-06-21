//
//  LeftMenuTableViewCell.swift
//  koetype
//
//  Created by 曽和修平 on 2015/06/10.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if(selected){
            self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        }else{
            self.backgroundColor = UIColor.clearColor()
        }
    }
    
}
