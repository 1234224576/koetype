//
//  TopTableViewCell.swift
//  koetype
//
//  Created by 曽和修平 on 2015/06/08.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit

class TopTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favIcon: UIImageView!
    
    var url:String?
    var articleId:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setUpCell(){
        favIcon.hidden = true
        nameLabel.textColor = UIColorFromRGB(0x107AFF)
    }
    func setCellItem(title:String){
        
        self.titleLabel.text = ""
    }
    
    func setNameLabelColor(isMyActress:Bool){
        if(isMyActress){
           nameLabel.textColor = UIColorFromRGB(0xFF69B4)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
