//
//  CostContentRect.h
//  DailyCost
//
//  Created by Scliang on 13-9-30.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CostContentRect : NSObject

- (id)initWidthCGRect:(CGRect)rect;

@property(nonatomic) CGFloat x;
@property(nonatomic) CGFloat y;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@end
