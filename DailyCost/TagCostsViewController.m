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
    [_titleButton setTitle:_tag forState:UIControlStateNormal];
    
    // 设置CostTableHeader
    _costTableView.tableHeaderView = _costTableHeaderView;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // 设置ContentLabelWidth
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
        toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        _costItemContentLabelWidth = [UIScreen mainScreen].bounds.size.width - 40;
    } else {
        _costItemContentLabelWidth = [UIScreen mainScreen].bounds.size.height - 40;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    // 设置ContentLabelWidth
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    
    // 重新加载数据
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
    
    // 如果总收入和总支出都为0，则不显示SumView
    _sumRootView.alpha = sum == 0 ? 0 : 1;
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

// 将CostList移动到最顶端
- (void)topCostTableView:(id)sender {
    [_costTableView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    bg.backgroundColor = cost.type == CostType_Income ? CostBackgroundColor_Income : cost.type == CostType_Expense ? CostBackgroundColor_Expense : CostMoneyColor_None;
    
    // Money Lable
    UILabel *money = (UILabel *) [cell viewWithTag:101];
    money.text = [NSString stringWithFormat:@"%0.2f", cost.money / 100.0];
    
    // Content Label
    UITagLabel *content = (UITagLabel *) [cell viewWithTag:102];
    [content initWithCost:cost];
    content.tagClickable = NO;
    
    // Edit Button
    UIButton *edit = (UIButton *) [cell viewWithTag:104];
    [edit setTitle:[NSString stringWithFormat:@"%ld", (long)indexPath.row] forState:UIControlStateNormal];
    [edit addTarget:self action:@selector(costEditClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Date Label
    UILabel *date = (UILabel *) [cell viewWithTag:105];
    NSString *sDate = [NSString stringWithFormat:@"%lld", cost.date];
    date.text = [NSString stringWithFormat:@"%@/%@ %@:%@",
                 [sDate substringWithRange:NSMakeRange(4, 2)],
                 [sDate substringWithRange:NSMakeRange(6, 2)],
                 [sDate substringWithRange:NSMakeRange(8, 2)],
                 [sDate substringWithRange:NSMakeRange(10, 2)]];
    
    // Type icon
    UIImageView *typeicon = (UIImageView *) [cell viewWithTag:108];
    typeicon.alpha = 0;
//    typeicon.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(cost.type == CostType_Income ? @"income_icon" : @"expense_icon") ofType:@"png"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cost *cost = [_costs objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont systemFontOfSize:17];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                cellFont, NSFontAttributeName,
                                nil];
    CGSize constraintSize = CGSizeMake(_costItemContentLabelWidth, MAXFLOAT);
    CGSize labelSize = [cost.content boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return labelSize.height + 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
