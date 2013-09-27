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
    
    // 初始化一个新的Cost
    _cost = [[Cost alloc] init];
    // 默认为支出Cost
    _cost.type = CostType_Expense;
    // 设置标题
    _titleLabel.text = NSLocalizedString(@"NewExpenseTitle", nil);
    
    // 设置输入提示
    _inputField.placeholder = NSLocalizedString(@"NewCostPlaceholder", nil);
    [_inputField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // 设置CostType
    [_typeIncomeButton setTitleColor:_typeNoneTextColor forState:UIControlStateNormal];
    [_typeExpenseButton setTitleColor:_typeSelectedTextColor forState:UIControlStateNormal];
    [_typeIncomeButton setTitle:NSLocalizedString(@"NewCostIncomeType", nil) forState:UIControlStateNormal];
    [_typeExpenseButton setTitle:NSLocalizedString(@"NewCostExpenseType", nil) forState:UIControlStateNormal];
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

// Cost输入文本-点击软键盘完成按钮
- (void)inputFieldDoneClick:(id)sender {
    
    // 分析出Cost
    BOOL success = [self analysis];
    if (success) {
        
        // DEBUG
        if (_DEBUG) NSLog(@"Cost Date=%lld, Money=%ld", _cost.date, _cost.money);
        
        // 将Cost保存到数据库中
        SqliteHelper *helper = [[SqliteHelper alloc] init];
        [helper open];
        success = [helper insertCost:_cost];
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
        
        // analysis T
        NSString *t = @"";
        if (content.length > 1) {
            unichar fc = [content characterAtIndex:0];
            if (fc == '#') {
                NSRange end = [content rangeOfString:@" "];
                NSRange range = NSMakeRange(0, end.length == 0 ? content.length : (end.location + end.length));
                t = [[content substringWithRange:range] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        }
        
        // DEBUG
        if (_DEBUG) NSLog(@"Analysis Cost t = %@", t);
        
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
            _cost.t = t;
            _cost.money = lMoney;
            _cost.content = content;
            return YES;
        }
    }
    return NO;
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
}

// Income Type按钮点击
- (void)typeIncomeClick:(id)sender {
    
    // 修改cost type
    _cost.type = CostType_Income;
    
    // 设置标题
    _titleLabel.text = NSLocalizedString(@"NewIncomeTitle", nil);
    
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
    _titleLabel.text = NSLocalizedString(@"NewExpenseTitle", nil);
    
    // 更新按钮文本颜色
    [_typeIncomeButton setTitleColor:_typeNoneTextColor forState:UIControlStateNormal];
    [_typeExpenseButton setTitleColor:_typeSelectedTextColor forState:UIControlStateNormal];
    
    // 更新按钮背景
    [_typeIncomeButton setBackgroundImage:_typeIncomeNoneImage forState:UIControlStateNormal];
    [_typeIncomeButton setBackgroundImage:_typeIncomeNoneImage forState:UIControlStateHighlighted];
    [_typeExpenseButton setBackgroundImage:_typeExpenseSelectedImage forState:UIControlStateNormal];
    [_typeExpenseButton setBackgroundImage:_typeExpenseSelectedImage forState:UIControlStateHighlighted];
}

@end
