//
//  UITagLabel.h
//  DailyCost
//
//  Created by Scliang on 13-9-29.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITagLabel;
@protocol UITagLabelDelegaet <NSObject>

@required
- (void)tagLabel:(UITagLabel *)label clickedTag:(NSString *)tag;

@end

@interface UITagLabel : UILabel

@property(nonatomic, strong, readonly) NSString *contentTag;
@property(nonatomic, strong, readonly) NSString *contentText;
@property(nonatomic, readonly) NSRange contentTagRange;
@property(nonatomic, readonly) NSRange contentTextRange;

@property(nonatomic, readonly) CGRect tagMainRect;
@property(nonatomic, readonly) CGRect tagMinorRect;

- (void)inits;

@property(nonatomic, readonly) BOOL isPressingTag;
- (BOOL)touchInTagRect:(CGPoint)touchPoint;

@property(nonatomic, strong) id<UITagLabelDelegaet> delegate;

@end
