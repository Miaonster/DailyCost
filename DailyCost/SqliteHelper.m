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
        
        if (_DEBUG) NSLog(@"Database Open Successful and Path = %@", path);
        
        [self initTables];
        
    } else {
        
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
    
    NSString *sql = [NSString stringWithFormat:
                     @"CREATE TABLE IF NOT EXISTS %@ (version INTEGER DEFAULT 1);", 
                     DATABASE_VERSION_TABLE_NAME];
    sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg);
    
    sql = [NSString stringWithFormat:
           @"CREATE TABLE IF NOT EXISTS %@ (uuid TEXT, type INTEGER, t TEXT, content TEXT, money long, date long);",
           COST_TABLE_NAME];
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        databaseIsOK = NO;
    } else {
        databaseIsOK = YES;
    }
}

@end
