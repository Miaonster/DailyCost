//
//  Tag.h
//  DailyCost
//
//  Created by Scliang on 13-9-28.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Tag : NSObject

- (id)initWithSqlite3Stmt:(sqlite3_stmt *) stmt;

@property(nonatomic, strong, readonly) NSString  *uuid;
@property(nonatomic, strong)           NSString  *name;
@property(nonatomic)                   long      count;

@end
