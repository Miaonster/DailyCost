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
#import "UITagLabel.h"
#import "NewCostViewController.h"

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
    
    // Cost Item Background
//    _costItemBackgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cost_item_background" ofType:@"png"]];
//    _costItemBackgroundImage = [_costItemBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 40, 40) resizingMode:UIImageResizingModeTile];
//    _costTypeIncomePointImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"point_income" ofType:@"png"]];
//    _costTypeExpensePointImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"point_expense" ofType:@"png"]];
    
    // 设置CostTableHeader
    _costTableView.tableHeaderView = _costTableHeaderView;
}

- (void)viewWillAppear:(BOOL)animated {
    SqliteHelper *sqliteHelper = [[SqliteHelper alloc] init];
    [sqliteHelper open];
    [_costs removeAllObjects];
    [_costs addObjectsFromArray:[sqliteHelper allCostsWithTag:_tag andType:_type]];
    [sqliteHelper close];
    
    // 显示CostList
    [_costTableView reloadData];
    
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

- (void)viewDidAppear:(BOOL)animated {
    
    // 如果没有Cost，则关闭页面
    if (_costs.count <= 0) {
        [self backClick:nil];
    }
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
    content.tagClickable = NO;
    
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

@end
