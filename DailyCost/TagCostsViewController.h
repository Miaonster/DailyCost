//
//  TagCostsViewController.h
//  DailyCost
//
//  Created by Scliang on 13-10-3.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCostsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


- (id)initWithTag:(NSString *)aTag andType:(NSInteger) aType;



// 内容
@property(nonatomic, strong, readonly) NSString *tag;
@property(nonatomic,         readonly) NSInteger type;
@property(nonatomic, strong, readonly) NSMutableArray *costs;
@property(nonatomic, strong) IBOutlet UIView *costTableHeaderView;
@property(nonatomic, strong) IBOutlet UITableView *costTableView;
//@property(nonatomic, strong, readonly) UIImage *costItemBackgroundImage;
//@property(nonatomic, strong, readonly) UIImage *costTypeIncomePointImage;
//@property(nonatomic, strong, readonly) UIImage *costTypeExpensePointImage;



// 标题
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;

// Sum
@property(nonatomic, strong) IBOutlet UILabel *sumLabel;
@property(nonatomic, strong) IBOutlet UILabel *sum;



// Back按钮点击
- (IBAction)backClick:(id)sender;




// CostItemEdit按钮点击
- (void)costEditClick:(id)sender;

@end
