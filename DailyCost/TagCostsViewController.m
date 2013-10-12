//
//  TagCostsViewController.m
//  DailyCost
//
//  Created by Scliang on 13-10-3.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import "TagCostsViewController.h"
#import "GlobalDefine.h"
#import "SqliteHelper.h"

@implementation TagCostsViewController

- (id)initWithTag:(NSString *)aTag andType:(NSInteger)aType {
    self = [self initWithNibName:@"TagCostsViewController" bundle:nil];
    if (self) {
        _tag = aTag;
        _type = aType;
        _costs = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置title
    _titleLabel.text = _tag;
}

- (void)viewWillAppear:(BOOL)animated {
    SqliteHelper *sqliteHelper = [[SqliteHelper alloc] init];
    [sqliteHelper open];
    [_costs removeAllObjects];
    [_costs addObjectsFromArray:[sqliteHelper allCostsWithTag:_tag andType:_type]];
    [sqliteHelper close];
    
    // 显示收入支出总金额
    long sum = 0;
    for (int i = 0; i < _costs.count; i++) {
        Cost *cost = [_costs objectAtIndex:i];
        sum += cost.money;
    }
    _sumLabel.text = @"";
    if (_type == CostType_Income) {
        _sumLabel.text = NSLocalizedString(@"TagCostsSumLabel", nil);
        _sumLabel.textColor = CostMoneyColor_Income;
        _sum.textColor = CostMoneyColor_Income;
    } else if (_type == CostType_Expense) {
        _sumLabel.text = NSLocalizedString(@"TagCostsSumLabel", nil);
        _sumLabel.textColor = CostMoneyColor_Expense;
        _sum.textColor = CostMoneyColor_Expense;
    }
    _sum.text = [NSString stringWithFormat:@"%0.2f", sum / 100.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}




#pragma mark - Button Click

// Back按钮点击
- (void)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
