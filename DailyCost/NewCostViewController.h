//
//  NewCostViewController.h
//  DailyCost
//
//  Created by Scliang on 13-9-25.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cost.h"

@interface NewCostViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

- (id)initWithEditCost:(Cost *)ec;


// Cost Object
@property(nonatomic, strong, readonly) Cost *cost;
@property(nonatomic, readonly) BOOL isEdit;


// 标题
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;

// Cost输入文本
@property(nonatomic, strong) IBOutlet UITextField *inputField;

// Type Button Text Color
@property(nonatomic, strong, readonly) UIColor *typeNoneTextColor;
@property(nonatomic, strong, readonly) UIColor *typeSelectedTextColor;
@property(nonatomic, strong) IBOutlet UIButton *typeChangeButton;

// Tag Table
@property(nonatomic, strong) IBOutlet UITableView *tagTableView;
@property(nonatomic, readonly) CGRect tagTableInitRect;
@property(nonatomic, strong) NSMutableArray *tags;

// Delete
@property(nonatomic, strong) IBOutlet UIButton *deleteCostButton;





// 软键盘打开关闭监听
- (void)inputMethodShow:(NSNotification *)notification;
- (void)inputMethodHide:(NSNotification *)notification;




// 根据Input分析出Cost
- (BOOL)analysis;

// 根据Cost的Type修改对应显示控件的属性
- (void)updateTypeViewWithCostType;



// Cost输入文本-输入改变
- (IBAction)inputFieldChanged:(id)sender;

// Cost输入文本-点击软键盘完成按钮
- (IBAction)inputFieldDoneClick:(id)sender;




// Back按钮点击
- (IBAction)backClick:(id)sender;

// T按钮点击
- (IBAction)tClick:(id)sender;

// Type按钮点击
- (IBAction)typeClick:(id)sender;

// Delete Cost 按钮点击
- (IBAction)deleteCostClick:(id)sender;

// Complete 按钮点击
- (IBAction)completeClick:(id)sender;


@end
