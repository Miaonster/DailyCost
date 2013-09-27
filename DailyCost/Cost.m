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
    }
    return self;
}

@end
