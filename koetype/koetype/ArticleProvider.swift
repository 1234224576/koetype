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

enum ArticleProviderError : ErrorType{
    case FailedAPIRerquest
}

class ArticleProvider {
    let apiUrl = "http://deeptoneworks.com/voice_actress/voice/public/voiceActress.json"
  
    func fetchArticle(params:Dictionary<String,AnyObject>,callback:(JSON?,ArticleProviderError?) -> ()){
        
            Alamofire.request(.GET, apiUrl,parameters: params)
                .responseJSON {(request, response, result) -> Void  in
                    switch result {
                    case .Success(let data):
                        let json = self.deleteFutureArticle(JSON(data))
                        callback(json,nil)
                    case .Failure(_,_):
                        callback(nil,.FailedAPIRerquest)
                    }
            }
    }
    
    static func isMyActress(name:String)->Bool{
        let searchActress : MyVoiceActress? = MyVoiceActress.MR_findFirstByAttribute("name", withValue:name)
        if (searchActress == nil){
            return false
        }
        return true
    }
    
    static func isFavorite(articleId:NSNumber)->Bool{
        let searchFav : Favorite? = Favorite.MR_findFirstByAttribute("article_id", withValue:articleId)
        if (searchFav == nil){
            return false
        }
        return true
    }

    private func deleteFutureArticle(json:JSON?)->JSON{
        var jsonDataArray :[JSON] = []
        if let j = json{
            for (_,data) in j["feed"]{
                let publishdateString = self.publishedStringToDate(data["published"].string!)
                let dateStrings = publishdateString.componentsSeparatedByString("-")
                let year = dateStrings[0]
                let month = dateStrings[1]
                let day = dateStrings[2]
                let publishDate = NSDateComponents()
                publishDate.month = Int(month)!
                publishDate.year = Int(year)!
                publishDate.day = Int(day)!
                let result:NSComparisonResult = NSDate().compare(NSCalendar.currentCalendar().dateFromComponents(publishDate)!)
                if(result != NSComparisonResult.OrderedAscending){
                    jsonDataArray.append(data)
                }
            }
        }
        return JSON(jsonDataArray);
    }
    private func publishedStringToDate(publishStr:String)->String{
        let dateStr = (publishStr as NSString).substringToIndex(10)
        return dateStr
    }

}