//
//  SqliteHelper.h
//  DailyCost
//
//  Created by Scliang on 13-9-26.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Cost.h"

#define DATABASE_VERSION_TABLE_NAME @"database_version_table"
#define DATABASE_VERSION 1

#define DB_NAME           @"DailyCostData.sqlite"
#define COST_TABLE_NAME   @"cost_table"

@interface SqliteHelper : NSObject {
    sqlite3 *database;
    BOOL databaseIsOK;
}

- (void)open;
- (void)onVersionUpdatedWithNewVerson:(NSInteger)newVersion oldVersion:(NSInteger)oldVersion;
- (void)close;

- (void)initTables;




// 添加一个新Cost
- (BOOL)insertCost:(Cost *)cost;



// 获得本月所有Cost，按时间倒序排列
- (NSArray *)currentMonthAllCosts;


@end
