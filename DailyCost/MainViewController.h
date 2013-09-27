//
//  MainViewController.h
//  DailyCost
//
//  Created by Scliang on 13-9-25.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqliteHelper.h"

@interface MainViewController : UIViewController


// SqliteHelper
@property(nonatomic, strong, readonly) SqliteHelper *sqliteHelper;



// 标题
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;


// 收入支出
@property(nonatomic, strong) IBOutlet UILabel *incomeLabel;
@property(nonatomic, strong) IBOutlet UILabel *expenseLabel;
@property(nonatomic, strong) IBOutlet UILabel *incomeSum;
@property(nonatomic, strong) IBOutlet UILabel *expenseSum;




// 创建新Cost的按钮点击
- (IBAction)newCostClick:(id)sender;


@end
