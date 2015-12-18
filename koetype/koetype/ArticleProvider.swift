//
//  ArticleProvider.swift
//  koetype
//
//  Created by 曽和 on 2015/12/18.
//  Copyright © 2015年 曽和修平. All rights reserved.
//

import Foundation
import Alamofire
import MagicalRecord
import SwiftyJSON

class ArticleProvider {
//    let apiUrl = "http://deeptoneworks.com/voice_actress/voice/public/voiceActress.json"
//    init(){
//        
//    }
//    
//    func fetchArticleAPI(params:Dictionary<String,String>,callback:(Double) -> ()){
//        
//            Alamofire.request(.GET, apiUrl,parameters: params)
//                .responseJSON {(request, response, result) -> Void in
//                    switch result {
//                    case .Success(let data):
//                        self.isLoading = false
//                        self.responseJsonData = self.deleteFutureArticle(JSON(data))
//                        self.tableView.reloadData()
//                        SVProgressHUD.dismiss()
//                        if let p = self.tableView.pullToRefreshView{
//                            p.stopAnimating()
//                        }
//                    case .Failure(_,_):
//                        SVProgressHUD.dismiss()
//                        if let p = self.tableView.pullToRefreshView{
//                            p.stopAnimating()
//                        }
//                    }
//            }
//
//        
//    }
}

//func loadArticle(){
//    self.isLoading = true;
//    print(self.params, terminator: "")
//    self.params["limit"] = "\(self.page * kOnceLoadArticle)"
//    Alamofire.request(.GET, baseUrl,parameters: self.params)
//        .responseJSON {(request, response, result) -> Void in
//            switch result {
//            case .Success(let data):
//                self.isLoading = false
//                self.responseJsonData = self.deleteFutureArticle(JSON(data))
//                self.tableView.reloadData()
//                SVProgressHUD.dismiss()
//                if let p = self.tableView.pullToRefreshView{
//                    p.stopAnimating()
//                }
//            case .Failure(_,_):
//                SVProgressHUD.dismiss()
//                if let p = self.tableView.pullToRefreshView{
//                    p.stopAnimating()
//                }
//            }
//    }
//}