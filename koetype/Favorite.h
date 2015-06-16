//
//  Favorite.h
//  koetype
//
//  Created by 曽和修平 on 2015/06/16.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSNumber * article_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;

@end
