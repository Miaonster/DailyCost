//
//  SqliteHelper.h
//  DailyCost
//
//  Created by Scliang on 13-9-26.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Tag.h"
#import "Cost.h"

#define DATABASE_VERSION_TABLE_NAME @"database_version_table"
#define DATABASE_VERSION 1

#define DB_NAME             @"DailyCostData.sqlite"
#define COST_TAG_TABLE_NAME @"cost_tag_table"
#define COST_TABLE_NAME     @"cost_table"



#define CostPageCount       24



@interface SqliteHelper : NSObject {
    sqlite3 *database;
    BOOL databaseIsOK;
}

- (void)open;
- (void)onVersionUpdatedWithNewVerson:(NSInteger)newVersion oldVersion:(NSInteger)oldVersion;
- (void)close;

- (void)initTables;




// 添加一个新Tag
- (BOOL)insertTag:(Tag *)t;

// 获得所有T
- (NSArray *)allTagsWithStartString:(NSString *)start;




// 添加一个新Cost
- (BOOL)insertCost:(Cost *)cost;

// 根据Cost UUID更新
- (BOOL)updateCost:(Cost *)cost withUUID:(NSString *)uuid;

// 获得所有Cost，按时间倒序排列
- (NSArray *)allCosts;

// 分页获得Cost，按时间倒序排列
- (NSArray *)pageCostsWithOffset:(NSInteger)offset;

// 获得本月所有Cost，按时间倒序排列
- (NSArray *)currentMonthAllCosts;

// 根据Cost UUID删除
- (BOOL)deleteCost:(NSString *)uuid;

// 获得所有给定Tag和Type的Costs
- (NSArray *)allCostsWithTag:(NSString *)tag andType:(NSInteger)type;


@end
