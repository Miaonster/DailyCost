//
//  Cost.h
//  DailyCost
//
//  Created by Scliang on 13-9-26.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Cost : NSObject

- (id)initWithCost:(Cost *)c;

- (id)initWithSqlite3Stmt:(sqlite3_stmt *) stmt;

@property(nonatomic, strong, readonly) NSString  *uuid;
@property(nonatomic)                   NSInteger type;
@property(nonatomic, strong)           NSString  *tag;
@property(nonatomic, strong)           NSString  *content;
@property(nonatomic)                   long      money;
@property(nonatomic)                   long long date;

@end
