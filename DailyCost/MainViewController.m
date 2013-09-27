//
//  MainViewController.m
//  DailyCost
//
//  Created by Scliang on 13-9-25.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import "MainViewController.h"
#import "GlobalDefine.h"
#import "NewCostViewController.h"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化SqliteHelper
    _sqliteHelper = [[SqliteHelper alloc] init];
    [_sqliteHelper open];
    
    // 设置标题
    _titleLabel.text = NSLocalizedString(@"MainTitle", nil);
    
    // 设置收入支出标签文本
    _incomeLabel.text = NSLocalizedString(@"IncomeLabel", nil);
    _expenseLabel.text = NSLocalizedString(@"ExpenseLabel", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Button Click


// 创建新Cost的按钮点击
- (void)newCostClick:(id)sender {
    NewCostViewController *ncvc = [[NewCostViewController alloc] initWithNibName:@"NewCostViewController" bundle:nil];
    [self.navigationController pushViewController:ncvc animated:YES];
}


@end
