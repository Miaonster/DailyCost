//
//  NewCostViewController.m
//  DailyCost
//
//  Created by Scliang on 13-9-25.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#include <math.h>
#import "NewCostViewController.h"
#import "GlobalDefine.h"
#import "SqliteHelper.h"

@implementation NewCostViewController

- (id)init {
    self = [self initWithNibName:@"NewCostViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (id)initWithEditCost:(Cost *)ec {
    self = [self init];
    if (self) {
        if (ec) {
            _cost = ec;
            _isEdit = YES;
            _tagTableView.alpha = 0;
            _deleteRootView.alpha = 1;
        }
    }
    return self;
}

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
    
    // Type Button Text Color
    _typeNoneTextColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    _typeSelectedTextColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    // Type Button Image
    _typeIncomeNoneImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"type_left" ofType:@"png"]];
    _typeIncomeSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"type_left_press" ofType:@"png"]];
    _typeExpenseNoneImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"type_right" ofType:@"png"]];
    _typeExpenseSelectedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"type_right_press" ofType:@"png"]];
    
    // 设置输入提示
    _inputField.placeholder = NSLocalizedString(@"NewCostPlaceholder", nil);
    [_inputField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // 设置CostType
    [_typeIncomeButton setTitleColor:_typeNoneTextColor forState:UIControlStateNormal];
    [_typeExpenseButton setTitleColor:_typeSelectedTextColor forState:UIControlStateNormal];
    [_typeIncomeButton setTitle:NSLocalizedString(@"NewCostIncomeType", nil) forState:UIControlStateNormal];
    [_typeExpenseButton setTitle:NSLocalizedString(@"NewCostExpenseType", nil) forState:UIControlStateNormal];
    
    // 监听软键盘的显示和隐藏
    __weak id weakSelf = self;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserverForName:UIKeyboardDidShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf inputMethodShow:note];
    }];
    [notificationCenter addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf inputMethodHide:note];
    }];
    
    
    // 初始，隐藏TagTable
    _tagTableInitRect = CGRectMake(_tagTableView.frame.origin.x, _tagTableView.frame.origin.y, _tagTableView.frame.size.width, _tagTableView.frame.size.height);
    _tagTableView.alpha = 0;
    _tags = [[NSMutableArray alloc] init];
    
    // 设置DeleteButtonTitle
    [_deleteCostButton setTitle:NSLocalizedString(@"NewCostDeleteCost", nil) forState:UIControlStateNormal];
    _deleteCostButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"delete" ofType:@"png"]];
    _deleteCostButtonImage = [_deleteCostButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20) resizingMode:UIImageResizingModeTile];
    [_deleteCostButton setBackgroundImage:_deleteCostButtonImage forState:UIControlStateNormal];
    
    // 判断是否为编辑
    if (_cost) {
        // 设置标题
        _titleLabel.text = NSLocalizedString(@"NewCostEditCostTitle", nil);
        // 初始显示Cost Content
        _inputField.text = _cost.content;
        // 初始显示Cost Type
        if (_cost.type == CostType_Income) {
            [self typeIncomeClick:nil];
        } else if (_cost.type == CostType_Expense) {
            [self typeExpenseClick:nil];
        }
    } else {
        // 初始化一个新的Cost
        _cost = [[Cost alloc] init];
        // 默认为支出Cost
        _cost.type = CostType_Expense;
        // 默认非编辑，只有调用了setEditCost后才视为编辑状态
        _isEdit = NO;
        // 设置标题
        _titleLabel.text = NSLocalizedString(@"NewExpenseTitle", nil);
        // 隐藏Delete
        _deleteRootView.alpha = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    // 默认在页面显示完成后打开软键盘
    [_inputField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}





#pragma mark - Model

// Cost输入文本-输入改变
- (void)inputFieldChanged:(id)sender {
    
    // 联想出已存在的T
    // 打开数据库
    SqliteHelper *helper = [[SqliteHelper alloc] init];
    [helper open];
    
    [_tags removeAllObjects];
    [_tags addObjectsFromArray:[helper allTagsWithStartString:_inputField.text]];
    
    // 关闭数据库
    [helper close];
    
    // 刷新TTable
    [_tagTableView reloadData];
    
    // 检查是否需要显示TTable
    _tagTableView.alpha = _tags.count > 0 ? 0.9 : 0;
}

// Cost输入文本-点击软键盘完成按钮
- (void)inputFieldDoneClick:(id)sender {
    
    // 在编辑状态下记录下之前Cost的UUID和日期
    NSString *oldUUID = _cost.uuid;
    long long oldDate = _cost.date;
    
    // 分析出Cost
    BOOL success = [self analysis];
    if (success) {
        
        // DEBUG
        if (_DEBUG) NSLog(@"Cost Date=%lld, Money=%ld", _cost.date, _cost.money);
        
        // 打开数据库
        SqliteHelper *helper = [[SqliteHelper alloc] init];
        [helper open];
        
        // 将T保存到数据库中
        if (_cost.tag.length > 0) {
            Tag *t = [[Tag alloc] init];
            t.name = _cost.tag;
            [helper insertTag:t];
        }
        
        // 将Cost保存到数据库中
        if (_isEdit) {
            _cost.date = oldDate;
            success = [helper updateCost:_cost withUUID:oldUUID];
        } else {
            success = [helper insertCost:_cost];
        }
        
        // 关闭数据库
        [helper close];
        
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
        }
    } else {
        
    }
}


// 根据Input分析出Cost
- (BOOL)analysis {
    NSString *content = [_inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (content.length > 0) {
        
        // analysis Tag
        NSString *tag = @"";
        if (content.length > 1) {
            unichar fc = [content characterAtIndex:0];
            if (fc == '#') {
                NSRange end = [content rangeOfString:@" "];
                NSRange range = NSMakeRange(0, end.length == 0 ? content.length : (end.location + end.length));
                tag = [[content substringWithRange:range] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        }
        
        // DEBUG
        if (_DEBUG) NSLog(@"Analysis Cost tag = %@", tag);
        
        // analysis Money
        NSString *money = @"";
        unichar cs[content.length];
        [content getCharacters:cs];
        int decStart = -1;
        int decEnd = -1;
        BOOL can = YES;
        for (int i = 0; can && i < content.length; ++i) {
            unichar c = cs[i];
            if(c >= '0' && c <= '9') {
                if(decStart == -1) decStart = i;
                if(decStart != -1) decEnd = i + 1;
                can = true;
            } else if(c == '.') {
                can = true;
            } else {
                can = decStart == -1;
            }
        }
        if (decStart != -1 && decEnd != -1) {
            NSRange range = NSMakeRange(decStart, decEnd - decStart);
            money = [content substringWithRange:range];
        }
        if (money.length > 0) {
            double dMoney = money.doubleValue;
            long lMoney = (long) round(dMoney * 100);
            _cost.tag = tag;
            _cost.money = lMoney;
            _cost.content = content;
            return YES;
        }
    }
    return NO;
}





#pragma mark - Input Method

// 软键盘打开关闭监听
- (void)inputMethodShow:(NSNotification *)notification {
    CGRect keyboardFrames = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _tagTableView.frame = CGRectMake(_tagTableInitRect.origin.x, _tagTableInitRect.origin.y, _tagTableInitRect.size.width, _tagTableInitRect.size.height - keyboardFrames.size.height);
}

- (void)inputMethodHide:(NSNotification *)notification {
    _tagTableView.frame = _tagTableInitRect;
}




#pragma mark - Button Click

// Back按钮点击
- (void)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// T按钮点击
- (void)tClick:(id)sender {
    NSString *content = _inputField.text;
    if (content.length > 0) {
        unichar fc = [content characterAtIndex:0];
        if (fc == '#') {
            if (content.length == 1) {
                content = @"";
            } else {
                content = [[content substringFromIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        } else {
            content = [NSString stringWithFormat:@"#%@ ", content];
        }
    } else {
        content = @"#";
    }
    _inputField.text = content;
    if (!_isEdit) [self inputFieldChanged:nil];
}

// Income Type按钮点击
- (void)typeIncomeClick:(id)sender {
    
    // 修改cost type
    _cost.type = CostType_Income;
    
    // 设置标题
    if (!_isEdit) _titleLabel.text = NSLocalizedString(@"NewIncomeTitle", nil);
    
    // 更新按钮文本颜色
    [_typeIncomeButton setTitleColor:_typeSelectedTextColor forState:UIControlStateNormal];
    [_typeExpenseButton setTitleColor:_typeNoneTextColor forState:UIControlStateNormal];
    
    // 更新按钮背景
    [_typeIncomeButton setBackgroundImage:_typeIncomeSelectedImage forState:UIControlStateNormal];
    [_typeIncomeButton setBackgroundImage:_typeIncomeSelectedImage forState:UIControlStateHighlighted];
    [_typeExpenseButton setBackgroundImage:_typeExpenseNoneImage forState:UIControlStateNormal];
    [_typeExpenseButton setBackgroundImage:_typeExpenseNoneImage forState:UIControlStateHighlighted];
}

// Expense Type按钮点击
- (void)typeExpenseClick:(id)sender {
    
    // 修改cost type
    _cost.type = CostType_Expense;
    
    // 设置标题
    if (!_isEdit) _titleLabel.text = NSLocalizedString(@"NewExpenseTitle", nil);
    
    // 更新按钮文本颜色
    [_typeIncomeButton setTitleColor:_typeNoneTextColor forState:UIControlStateNormal];
    [_typeExpenseButton setTitleColor:_typeSelectedTextColor forState:UIControlStateNormal];
    
    // 更新按钮背景
    [_typeIncomeButton setBackgroundImage:_typeIncomeNoneImage forState:UIControlStateNormal];
    [_typeIncomeButton setBackgroundImage:_typeIncomeNoneImage forState:UIControlStateHighlighted];
    [_typeExpenseButton setBackgroundImage:_typeExpenseSelectedImage forState:UIControlStateNormal];
    [_typeExpenseButton setBackgroundImage:_typeExpenseSelectedImage forState:UIControlStateHighlighted];
}

// Delete Cost 按钮点击
- (void)deleteCostClick:(id)sender {
    
    // 确认框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DeleteAlertTitle", nil) message:NSLocalizedString(@"DeleteAlertMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"DeleteAlertCancelButton", nil) otherButtonTitles:NSLocalizedString(@"DeleteAlertDeleteButton", nil), nil];
    alert.delegate = self;
    [alert show];
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
    return _tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TItemView"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TItemView"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    Tag *t = [_tags objectAtIndex:indexPath.row];
    cell.textLabel.text = t.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 选择Tag
    NSString *st = ((Tag *) [_tags objectAtIndex:indexPath.row]).name;
    _inputField.text = [NSString stringWithFormat:@"%@ ", st];
    if (!_isEdit) [self inputFieldChanged:nil];
}




#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        BOOL success = NO;
        
        // 打开数据库
        SqliteHelper *helper = [[SqliteHelper alloc] init];
        [helper open];
        
        // 将Cost从数据库中删除
        success = [helper deleteCost:_cost.uuid];
        
        // 关闭数据库
        [helper close];
        
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
        }
    }
}

@end
