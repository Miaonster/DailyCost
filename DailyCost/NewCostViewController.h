//
//  NewCostViewController.h
//  DailyCost
//
//  Created by Scliang on 13-9-25.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cost.h"

@interface NewCostViewController : UIViewController


// Cost Object
@property(nonatomic, strong, readonly) Cost *cost;


// 标题
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;

// Cost输入文本
@property(nonatomic, strong) IBOutlet UITextField *inputField;

// Type Button Text Color
@property(nonatomic, strong, readonly) UIColor *typeNoneTextColor;
@property(nonatomic, strong, readonly) UIColor *typeSelectedTextColor;

// Income Type
@property(nonatomic, strong, readonly) UIImage *typeIncomeNoneImage;
@property(nonatomic, strong, readonly) UIImage *typeIncomeSelectedImage;
@property(nonatomic, strong) IBOutlet UIButton *typeIncomeButton;

// Expense Type
@property(nonatomic, strong, readonly) UIImage *typeExpenseNoneImage;
@property(nonatomic, strong, readonly) UIImage *typeExpenseSelectedImage;
@property(nonatomic, strong) IBOutlet UIButton *typeExpenseButton;




// 根据Input分析出Cost
- (void)analysis;




// Back按钮点击
- (IBAction)backClick:(id)sender;

// T按钮点击
- (IBAction)tClick:(id)sender;

// Income Type按钮点击
- (IBAction)typeIncomeClick:(id)sender;

// Expense Type按钮点击
- (IBAction)typeExpenseClick:(id)sender;


@end
