//
//  NewCostViewController.m
//  DailyCost
//
//  Created by Scliang on 13-9-25.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import "NewCostViewController.h"
#import "GlobalDefine.h"

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

// 根据Input分析出Cost
- (void)analysis {
    
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
