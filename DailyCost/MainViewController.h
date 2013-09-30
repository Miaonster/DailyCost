//
//  MainViewController.h
//  DailyCost
//
//  Created by Scliang on 13-9-25.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqliteHelper.h"
#import "UITagLabel.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITagLabelDelegaet>


// SqliteHelper
@property(nonatomic, strong, readonly) SqliteHelper *sqliteHelper;



// Cost List Data
@property(nonatomic, strong, readonly) NSMutableArray *costs;



// 标题
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;


// 收入支出
@property(nonatomic, strong) IBOutlet UILabel *incomeLabel;
@property(nonatomic, strong) IBOutlet UILabel *expenseLabel;
@property(nonatomic, strong) IBOutlet UILabel *incomeSum;
@property(nonatomic, strong) IBOutlet UILabel *expenseSum;


// Cost List
@property(nonatomic, strong) IBOutlet UITableView *costTableView;
@property(nonatomic, strong) IBOutlet UIView *costTableHeaderView;
@property(nonatomic, strong, readonly) UIImage *costItemBackgroundImage;
@property(nonatomic, strong, readonly) UIImage *costTypeIncomePointImage;
@property(nonatomic, strong, readonly) UIImage *costTypeExpensePointImage;
@property(nonatomic, strong, readonly) NSDictionary *costContentHeightDic;






// 从数据库中获得所有本月的Cost
- (void)updateCurrentMonthAllCosts;




// 创建新Cost的按钮点击
- (IBAction)newCostClick:(id)sender;




// CostItemEdit按钮点击
- (void)costEditClick:(id)sender;


@end
