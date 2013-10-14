//
//  UITagLabel.h
//  DailyCost
//
//  Created by Scliang on 13-9-29.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cost.h"

@class UITagLabel;
@protocol UITagLabelDelegaet <NSObject>

@required
- (void)tagLabel:(UITagLabel *)label clickedTag:(NSString *)tag andCost:(Cost *)cost;

@end

@interface UITagLabel : UILabel

@property(nonatomic, strong, readonly) NSString *contentTag;
@property(nonatomic, strong, readonly) NSString *contentText;
@property(nonatomic, readonly) NSRange contentTagRange;
@property(nonatomic, readonly) NSRange contentTextRange;

@property(nonatomic, readonly) CGRect tagMainRect;
@property(nonatomic, readonly) CGRect tagMinorRect;

@property(nonatomic, strong, readonly) Cost *cost;
- (void)initWithCost:(Cost *)aCost;

@property(nonatomic, readonly) BOOL isPressingTag;
- (BOOL)touchInTagRect:(CGPoint)touchPoint;

@property(nonatomic) BOOL tagClickable;
@property(nonatomic, strong) id<UITagLabelDelegaet> delegate;

@end
