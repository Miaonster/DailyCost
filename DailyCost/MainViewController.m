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
#import "TagCostsViewController.h"

@implementation MainViewController

- (id)init {
    self = [self initWithNibName:@"MainViewController" bundle:nil];
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
    _costContentHeightDic = [[NSDictionary alloc] init];
    
    // 设置标题
    _titleLabel.text = NSLocalizedString(@"MainTitle", nil);
    
    // 设置收入支出标签文本
    _incomeLabel.text = NSLocalizedString(@"IncomeLabel", nil);
    _expenseLabel.text = NSLocalizedString(@"ExpenseLabel", nil);
    
    // Cost Item Background
//    _costItemBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cost_item_background" ofType:@"png"]];
//    _costItemBackgroundImage = [_costItemBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 40, 40) resizingMode:UIImageResizingModeTile];
//    _costTypeIncomePointImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"point_income" ofType:@"png"]];
//    _costTypeExpensePointImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"point_expense" ofType:@"png"]];
    
//    // 设置CostTableHeader
//    _costTableView.tableHeaderView = _costTableHeaderView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
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
    
    // 显示CostList
    [_costTableView reloadData];
    
    // 显示收入支出总金额
    long income = 0;
    long expense = 0;
    for (int i = 0; i < _costs.count; i++) {
        Cost *cost = [_costs objectAtIndex:i];
        switch (cost.type) {
            case CostType_Income:
                income += cost.money;
                break;
            case CostType_Expense:
                expense += cost.money;
                break;
        }
    }
    _incomeSum.text = [NSString stringWithFormat:@"%0.2f", income / 100.0];
    _expenseSum.text = [NSString stringWithFormat:@"%0.2f", expense / 100.0];
}



#pragma mark - Button Click


// 创建新Cost的按钮点击
- (void)newCostClick:(id)sender {
    NewCostViewController *ncvc = [[NewCostViewController alloc] init];
    [self.navigationController pushViewController:ncvc animated:YES];
}

// 更多。。。按钮点击
- (void)moreClick:(id)sender {
    
}

// CostItemEdit按钮点击
- (void)costEditClick:(id)sender {
    if ([sender isKindOfClass:UIButton.class]) {
        UIButton *edit = (UIButton *) sender;
        int index = [edit.titleLabel.text intValue];
        Cost *cost = [[Cost alloc] initWithCost:[_costs objectAtIndex:index]];
        NewCostViewController *ncvc = [[NewCostViewController alloc] initWithEditCost:cost];
        [self.navigationController pushViewController:ncvc animated:YES];
    }
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _costs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CostItemView"];
    if(!cell) cell = [[[NSBundle mainBundle] loadNibNamed:@"CostItemView" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Cost
    Cost *cost = [_costs objectAtIndex:indexPath.row];
    
    // Background Image
    UIImageView *bg = (UIImageView *) [cell viewWithTag:100];
//    bg.image = _costItemBackgroundImage;
    bg.backgroundColor = cost.type == CostType_Income ? CostBackgroundColor_Income : cost.type == CostType_Expense ? CostBackgroundColor_Expense : CostMoneyColor_None;
    
    // Money Lable
    UILabel *money = (UILabel *) [cell viewWithTag:101];
    money.text = [NSString stringWithFormat:@"%0.2f", cost.money / 100.0];
//    money.textColor = cost.type == CostType_Income ? CostMoneyColor_Income : cost.type == CostType_Expense ? CostMoneyColor_Expense : CostMoneyColor_None;
    
    // Content Label
    UITagLabel *content = (UITagLabel *) [cell viewWithTag:102];
    [content initWithCost:cost];
    content.delegate = self;
    
//    // Cost Type Point
//    UIImageView *point = (UIImageView *) [cell viewWithTag:103];
//    point.image = cost.type == CostType_Income ? _costTypeIncomePointImage : cost.type == CostType_Expense ? _costTypeExpensePointImage : nil;
    
    // Edit Button
    UIButton *edit = (UIButton *) [cell viewWithTag:104];
    [edit setTitle:[NSString stringWithFormat:@"%d", indexPath.row] forState:UIControlStateNormal];
    [edit addTarget:self action:@selector(costEditClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Date Label
    UILabel *date = (UILabel *) [cell viewWithTag:105];
    NSString *sDate = [NSString stringWithFormat:@"%lld", cost.date];
    date.text = [NSString stringWithFormat:@"%@/%@ %@:%@",
                 [sDate substringWithRange:NSMakeRange(4, 2)],
                 [sDate substringWithRange:NSMakeRange(6, 2)],
                 [sDate substringWithRange:NSMakeRange(8, 2)],
                 [sDate substringWithRange:NSMakeRange(10, 2)]];
    
//    // ￥Label
//    UILabel *mLabel = (UILabel *) [cell viewWithTag:106];
//    mLabel.textColor = money.textColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cost *cost = [_costs objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont systemFontOfSize:17];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                cellFont, NSFontAttributeName,
                                nil];
    CGSize constraintSize = CGSizeMake(265.0f, MAXFLOAT);
    CGSize labelSize = [cost.content boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return labelSize.height + 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITagLabel Delegate

- (void)tagLabel:(UITagLabel *)label clickedTag:(NSString *)tag andCost:(Cost *)cost {
    TagCostsViewController *tcvc = [[TagCostsViewController alloc] initWithTag:tag andType:cost.type];
    [self.navigationController pushViewController:tcvc animated:YES];
}


@end
