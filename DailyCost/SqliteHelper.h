//
//  SqliteHelper.h
//  DailyCost
//
//  Created by Scliang on 13-9-26.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

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

@end
