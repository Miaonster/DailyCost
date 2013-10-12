//
//  SqliteHelper.m
//  DailyCost
//
//  Created by Scliang on 13-9-26.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import "SqliteHelper.h"
#import "GlobalDefine.h"

@implementation SqliteHelper

- (id)init {
    self = [super init];
    if (self) {
        databaseIsOK = NO;
    }
    return self;
}

- (void)open {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
    
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        
        // DEBUG
//        if (_DEBUG) NSLog(@"Database Open Successful and Path = %@", path);
        
        [self initTables];
        
        databaseIsOK = YES;
        
    } else {
        
        // DEBUG
        if (_DEBUG) NSLog(@"Database Open Failed");
        
        sqlite3_close(database);
    }
    
    // 检查数据库版本
    sqlite3_stmt *statement;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@;", DATABASE_VERSION_TABLE_NAME];
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        char *errorMsg;
        if (sqlite3_step(statement) == SQLITE_ROW) {
            int oldVersion = sqlite3_column_int(statement, 0);
            if (oldVersion < DATABASE_VERSION) {
                NSString *sql = [NSString stringWithFormat:
                                 @"UPDATE %@ SET %@=%d;",
                                 DATABASE_VERSION_TABLE_NAME,
                                 @"version",
                                 DATABASE_VERSION];
                sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
                
                [self onVersionUpdatedWithNewVerson:DATABASE_VERSION oldVersion:oldVersion];
            }
        } else {
            NSString *sql = [NSString stringWithFormat:
                             @"INSERT INTO %@ VALUES (%d);",
                             DATABASE_VERSION_TABLE_NAME,
                             DATABASE_VERSION];
            sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
        }
        
        sqlite3_finalize(statement);
    }
}

- (void)onVersionUpdatedWithNewVerson:(NSInteger)newVersion oldVersion:(NSInteger)oldVersion {
    
}

- (void)close {
    sqlite3_close(database);
}

- (void)initTables {
    char *errorMsg;
    
    
    // Database Version Table
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS %@ (version INTEGER DEFAULT 1);",
                     DATABASE_VERSION_TABLE_NAME];
    sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
    
    
    // Cost Tag Table
    sql = [NSString stringWithFormat:
           @"CREATE TABLE IF NOT EXISTS %@ (uuid TEXT, name TEXT PRIMARY KEY, count long);",
           COST_TAG_TABLE_NAME];
    sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
    
    
    // Cost Table
    sql = [NSString stringWithFormat:
           @"CREATE TABLE IF NOT EXISTS %@ (uuid TEXT, type INTEGER, tag TEXT, content TEXT, money long, date long long);",
           COST_TABLE_NAME];
    sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
}








// 添加一个新Tag
- (BOOL)insertTag:(Tag *)t {
    if (databaseIsOK && t) {
        NSString *sql = [NSString stringWithFormat:
                         @"INSERT INTO %@ VALUES ('%@','%@', %ld);",
                         COST_TAG_TABLE_NAME,
                         t.uuid, t.name, t.count];
        char *errorMsg;
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
            
            // DEBUG
            if (_DEBUG) NSLog(@"Table(%@) Insert New Tag Successful", COST_TAG_TABLE_NAME);
            
            return YES;
        } else {
            
            // DEBUG
            if (_DEBUG) NSLog(@"Table(%@) Insert New Tag Failed and Error = %@", COST_TAG_TABLE_NAME, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]);
        }
    }
    return NO;
}


// 获得所有Tags
- (NSArray *)allTagsWithStartString:(NSString *)start {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (databaseIsOK && start.length > 0 && [start characterAtIndex:0] == '#') {
        sqlite3_stmt *statement;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ORDER BY count DESC;",
                         COST_TAG_TABLE_NAME,
                         [NSString stringWithFormat:@"name LIKE '%@%%'", start]];
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Tag *t = [[Tag alloc] initWithSqlite3Stmt:statement];
                [array addObject:t];
            }
            sqlite3_finalize(statement);
        }
    }
    return array;
}









// 添加一个新Cost
- (BOOL)insertCost:(Cost *)cost {
    if (databaseIsOK && cost) {
        NSString *sql = [NSString stringWithFormat:
                         @"INSERT INTO %@ VALUES ('%@', %d, '%@', '%@', %ld, %lld);",
                         COST_TABLE_NAME,
                         cost.uuid, cost.type, cost.tag, cost.content, cost.money, cost.date];
        char *errorMsg;
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
            
            // DEBUG
            if (_DEBUG) NSLog(@"Table(%@) Insert New Cost Successful", COST_TABLE_NAME);
            
            return YES;
        } else {
            
            // DEBUG
            if (_DEBUG) NSLog(@"Table(%@) Insert New Cost Failed and Error = %@", COST_TABLE_NAME, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]);
        }
    }
    return NO;
}

// 根据Cost UUID更新
- (BOOL)updateCost:(Cost *)cost withUUID:(NSString *)uuid {
    if (databaseIsOK && cost) {
        NSString *sql = [NSString stringWithFormat:
                         @"UPDATE %@ SET uuid='%@', type=%d, tag='%@', content='%@', money=%ld, date=%lld WHERE uuid='%@';",
                         COST_TABLE_NAME,
                         cost.uuid, cost.type, cost.tag, cost.content, cost.money, cost.date,
                         uuid];
        char *errorMsg;
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
            
            // DEBUG
            if (_DEBUG) NSLog(@"Table(%@) Update Cost Successful", COST_TABLE_NAME);
            
            return YES;
        } else {
            
            // DEBUG
            if (_DEBUG) NSLog(@"Table(%@) Update Cost Failed and Error = %@", COST_TABLE_NAME, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]);
        }
    }
    return NO;
}


// 获得所有Cost，按时间倒序排列
- (NSArray *)allCosts {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (databaseIsOK) {
        sqlite3_stmt *statement;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY date DESC;", COST_TABLE_NAME];
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Cost *cost = [[Cost alloc] initWithSqlite3Stmt:statement];
                [array addObject:cost];
            }
            sqlite3_finalize(statement);
        }
    }
    return array;
}


// 分页获得Cost，按时间倒序排列
- (NSArray *)pageCostsWithOffset:(NSInteger)offset {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (databaseIsOK) {
        sqlite3_stmt *statement;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY date DESC LIMT %d,%d;", COST_TABLE_NAME, offset, CostPageCount];
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Cost *cost = [[Cost alloc] initWithSqlite3Stmt:statement];
                [array addObject:cost];
            }
            sqlite3_finalize(statement);
        }
    }
    return array;
}


// 获得本月所有Cost，按时间倒序排列
- (NSArray *)currentMonthAllCosts {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (databaseIsOK) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMM00000000"];
        NSString *sDate = [dateFormatter stringFromDate:[NSDate date]];
        long long date = (long long) sDate.doubleValue;
        sqlite3_stmt *statement;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE date >= %lld ORDER BY date DESC;", COST_TABLE_NAME, date];
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Cost *cost = [[Cost alloc] initWithSqlite3Stmt:statement];
                [array addObject:cost];
            }
            sqlite3_finalize(statement);
        }
    }
    return array;
}

// 根据Cost UUID删除
- (BOOL)deleteCost:(NSString *)uuid {
    if (databaseIsOK) {
        NSString *sql = [NSString stringWithFormat:
                         @"DELETE FROM %@ WHERE uuid='%@';",
                         COST_TABLE_NAME,
                         uuid];
        char *errorMsg;
        if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
            
            // DEBUG
            if (_DEBUG) NSLog(@"Table(%@) Delete Cost Successful", COST_TABLE_NAME);
            
            return YES;
        } else {
            
            // DEBUG
            if (_DEBUG) NSLog(@"Table(%@) Delete Failed and Error = %@", COST_TABLE_NAME, [NSString stringWithCString:errorMsg encoding:NSUTF8StringEncoding]);
        }
    }
    return NO;
}

// 获得所有给定Tag和Type的Costs
- (NSArray *)allCostsWithTag:(NSString *)tag andType:(NSInteger)type {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (databaseIsOK) {
        sqlite3_stmt *statement;
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE tag = '%@' AND type = %d ORDER BY date DESC;", COST_TABLE_NAME, tag, type];
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                Cost *cost = [[Cost alloc] initWithSqlite3Stmt:statement];
                [array addObject:cost];
            }
            sqlite3_finalize(statement);
        }
    }
    return array;
}



@end
