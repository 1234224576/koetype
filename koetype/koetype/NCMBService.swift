//
//  MbaaS.swift
//  koetype
//
//  Created by 曽和 on 2015/12/18.
//  Copyright © 2015年 曽和修平. All rights reserved.
//

import Foundation
import MagicalRecord

class NCMBService{
    
    func synchronizedFavoriteActoress(){
        let currentInstallation = NCMBInstallation.currentInstallation()
        let favorits = MyVoiceActress.MR_findAll()
        let names = favorits.map{String($0.name)}
        currentInstallation.setObject(names, forKey: "actress")
        currentInstallation.saveInBackgroundWithBlock { (_) -> Void in
            print("\nsynchronized favorite actress datas")
        }
    }
    
}