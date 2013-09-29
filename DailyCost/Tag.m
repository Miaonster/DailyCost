//
//  Tag.m
//  DailyCost
//
//  Created by Scliang on 13-9-28.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import "Tag.h"
#import "UUID.h"

@implementation Tag

- (id)init {
    self = [super init];
    if (self) {
        _uuid = [UUID randomUUID];
        _name = @"";
        _count = 0;
    }
    return self;
}


// 0:uuid  TEXT
// 1:name  TEXT
// 2:count long
- (id)initWithSqlite3Stmt:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self && stmt) {
        _uuid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
        _name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
        _count = (long) sqlite3_column_int64(stmt, 2);
    }
    return self;
}

@end
