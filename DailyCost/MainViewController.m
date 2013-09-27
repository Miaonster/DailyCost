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
    _costs = [[NSMutableArray alloc] init];
    
    // 设置标题
    _titleLabel.text = NSLocalizedString(@"MainTitle", nil);
    
    // 设置收入支出标签文本
    _incomeLabel.text = NSLocalizedString(@"IncomeLabel", nil);
    _expenseLabel.text = NSLocalizedString(@"ExpenseLabel", nil);
    
    // Cost Item Background
    _costItemBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cost_item_bg" ofType:@"png"]];
    _costItemBackgroundImage = [_costItemBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(_costItemBackgroundImage.size.height / 2), floorf(_costItemBackgroundImage.size.width / 2), floorf(_costItemBackgroundImage.size.height / 2), floorf(_costItemBackgroundImage.size.width / 2))];
    
    // 设置CostTableHeader
    _costTableView.tableHeaderView = _costTableHeaderView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    
    // 从数据库中获得所有本月的Cost
    [self updateCurrentMonthAllCosts];
}



#pragma mark - Model


// 从数据库中获得所有本月的Cost
- (void)updateCurrentMonthAllCosts {
    [_sqliteHelper open];
    [_costs removeAllObjects];
    [_costs addObjectsFromArray:[_sqliteHelper currentMonthAllCosts]];
    [_sqliteHelper close];
    
    // 显示
    [_costTableView reloadData];
}



#pragma mark - Button Click


// 创建新Cost的按钮点击
- (void)newCostClick:(id)sender {
    NewCostViewController *ncvc = [[NewCostViewController alloc] initWithNibName:@"NewCostViewController" bundle:nil];
    [self.navigationController pushViewController:ncvc animated:YES];
}

#pragma mark - UITableView Delegate

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _costs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostItemView"];
    if(!cell) cell = [[[NSBundle mainBundle] loadNibNamed:@"CostItemView" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Background Image
    ((UIImageView *) [cell viewWithTag:100]).image = _costItemBackgroundImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
