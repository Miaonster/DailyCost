//
//  Cost.m
//  DailyCost
//
//  Created by Scliang on 13-9-26.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import "Cost.h"
#import "UUID.h"
#import "GlobalDefine.h"

@implementation Cost

- (id)init {
    self = [super init];
    if (self) {
        _uuid = [UUID randomUUID];
        _type = CostType_Expense;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *sDate = [dateFormatter stringFromDate:[NSDate date]];
        _date = (long long) sDate.doubleValue;
    }
    return self;
}


// 0:uuid TEXT
// 1:type INTEGER
// 2:t TEXT
// 3:content TEXT
// 4:money long
// 5:date long long
- (id)initWithSqlite3Stmt:(sqlite3_stmt *)stmt {
    self = [self init];
    if (self && stmt) {
        _uuid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
        _type = sqlite3_column_int(stmt, 1);
        _t = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
        _content = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
        _money = (long) sqlite3_column_int64(stmt, 4);
        _date = sqlite3_column_int64(stmt, 5);
    }
    return self;
}

@end
