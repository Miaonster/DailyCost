//
//  Cost.h
//  DailyCost
//
//  Created by Scliang on 13-9-26.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cost : NSObject

@property(nonatomic, strong, readonly) NSString  *uuid;
@property(nonatomic)                   NSInteger type;
@property(nonatomic, strong)           NSString  *t;
@property(nonatomic, strong)           NSString  *content;
@property(nonatomic)                   long      money;
@property(nonatomic)                   long      date;

@end
