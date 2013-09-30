//
//  CostContentRect.m
//  DailyCost
//
//  Created by Scliang on 13-9-30.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import "CostContentRect.h"

@implementation CostContentRect

- (id)initWidthCGRect:(CGRect)rect {
    self = [super init];
    if (self) {
        _x = rect.origin.x;
        _y = rect.origin.y;
        _width = rect.size.width;
        _height = rect.size.height;
    }
    return self;
}

@end
