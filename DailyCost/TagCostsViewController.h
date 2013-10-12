//
//  TagCostsViewController.h
//  DailyCost
//
//  Created by Scliang on 13-10-3.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCostsViewController : UIViewController


- (id)initWithTag:(NSString *)aTag andType:(NSInteger) aType;



//
@property(nonatomic, strong, readonly) NSString *tag;
@property(nonatomic,         readonly) NSInteger type;
@property(nonatomic, strong, readonly) NSMutableArray *costs;



// 标题
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;

// Sum
@property(nonatomic, strong) IBOutlet UILabel *sumLabel;
@property(nonatomic, strong) IBOutlet UILabel *sum;



// Back按钮点击
- (IBAction)backClick:(id)sender;

@end
