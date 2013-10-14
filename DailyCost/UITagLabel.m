//
//  UITagLabel.m
//  DailyCost
//
//  Created by Scliang on 13-9-29.
//  Copyright (c) 2013年 ChuanliangShang. All rights reserved.
//

#import "UITagLabel.h"
#import "GlobalDefine.h"

@implementation UITagLabel

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//    }
//    return self;
//}

- (void)initWithCost:(Cost *)aCost {
    self.userInteractionEnabled = YES;
    _isPressingTag = NO;
    _cost = aCost;
    _tagClickable = YES;
    
    NSString *content = _cost.content;
    _contentText = [NSString stringWithFormat:@"%@", content];
    
    // analysis Tag
    _contentTag = @"";
    if (content.length > 1) {
        unichar fc = [content characterAtIndex:0];
        if (fc == '#') {
            NSRange end = [content rangeOfString:@" "];
            _contentTagRange = NSMakeRange(0, end.length == 0 ? content.length : (end.location + end.length - 1));
            _contentTag = [content substringWithRange:_contentTagRange];
            _contentTextRange = NSMakeRange(_contentTagRange.length == content.length ? content.length : (_contentTagRange.length + 1), (_contentTagRange.length == content.length ? 0 : (content.length - (_contentTagRange.length + 1))));
            _contentText = [content substringWithRange:_contentTextRange];
        }
    }
}

//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//}

- (void)drawTextInRect:(CGRect)rect {
    
//    //获取绘制上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    //保存上下文状态
//    CGContextSaveGState(ctx);
    
    // 清空Rect
    _tagMainRect = CGRectMake(0, 0, 0, 0);
    _tagMinorRect = CGRectMake(0, 0, 0, 0);
    
    // Draw Tag
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                self.font, NSFontAttributeName,
                                _tagClickable ? CostTagTextColor : self.textColor, NSForegroundColorAttributeName,
                                nil];
    CGPoint drawPoint = CGPointMake(0, 0);
    
    // 如果Tag被按下时使用PressColor
    if (_tagClickable && _isPressingTag) [attributes setObject:CostTagTextPressColor forKey:NSForegroundColorAttributeName];
    
    // 逐字绘画
    for (int i = 0; i < _contentTag.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *sc = [_contentTag substringWithRange:range];
        [sc drawAtPoint:drawPoint withAttributes:attributes];
        CGSize csize = [sc sizeWithAttributes:attributes];
        
        // 标记上Tag覆盖的区域，用于相应点击
        if (_tagMinorRect.size.height <= 0) _tagMinorRect.size.height = csize.height;
        _tagMinorRect.size.width += csize.width;
        
        drawPoint.x += csize.width;
        if (drawPoint.x >= rect.size.width - csize.width) {
            drawPoint.x = 0;
            drawPoint.y += csize.height;
            
            // 标记上Tag覆盖的区域，用于相应点击
            _tagMainRect.size.width = MAX(_tagMainRect.size.width, _tagMinorRect.size.width);
            _tagMainRect.size.height += _tagMinorRect.size.height;
            
            // 换行后，初始化次要区域宽度
            _tagMinorRect.size.width = 0;
            _tagMinorRect.size.height += csize.height;
        }
    }
    
    // 如果Tab未慢一行，两个区域置一致
    if (drawPoint.y <= 0) {
        
        // 标记上Tag覆盖的区域，用于相应点击
        _tagMainRect.size.width = _tagMinorRect.size.width;
        _tagMainRect.size.height = _tagMinorRect.size.height;
    }
    
    
    // 如果存在Tag，绘画Text之前要补一个空格
    NSString *tmpContentText = _contentText;
    if (drawPoint.x != 0 || drawPoint.y != 0) {
        tmpContentText = [NSString stringWithFormat:@" %@", _contentText];
    }
    
    // Draw Content
    [attributes setObject:self.textColor forKey:NSForegroundColorAttributeName];
    
    // 逐字绘画
    for (int i = 0; i < tmpContentText.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *sc = [tmpContentText substringWithRange:range];
        [sc drawAtPoint:drawPoint withAttributes:attributes];
        CGSize csize = [sc sizeWithAttributes:attributes];
        drawPoint.x += csize.width;
        if (drawPoint.x >= rect.size.width - csize.width) {
            drawPoint.x = 0;
            drawPoint.y += csize.height;
        }
    }
}

- (BOOL)touchInTagRect:(CGPoint)touchPoint {
    BOOL touchInMainRect = touchPoint.x >= _tagMainRect.origin.x && touchPoint.x <= _tagMainRect.origin.x + _tagMainRect.size.width &&
    touchPoint.y >= _tagMainRect.origin.y && touchPoint.y <= _tagMainRect.origin.y + _tagMainRect.size.height;
    BOOL touchInMinorRect = touchPoint.x >= _tagMinorRect.origin.x && touchPoint.x <= _tagMinorRect.origin.x + _tagMinorRect.size.width &&
    touchPoint.y >= _tagMinorRect.origin.y && touchPoint.y <= _tagMinorRect.origin.y + _tagMinorRect.size.height;
    return touchInMainRect || touchInMinorRect;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Touch Point
    UITouch *touch = event.allTouches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    
    BOOL isTouchInTagRect = [self touchInTagRect:touchPoint];
    
    // 点击到Tag区域内时标记上，需要改变Tag的显示属性
    if (isTouchInTagRect) {
        _isPressingTag = YES;
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 只要是移动了，就取消本次点击
    _isPressingTag = NO;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 只有在Tag区域被按下的状态时，才能触发点击事件
    if (_tagClickable && _isPressingTag) {
        if (_delegate) [_delegate tagLabel:self clickedTag:_contentTag andCost:_cost];
    }
    
    // 恢复点击状态
    _isPressingTag = NO;
    [self setNeedsDisplay];
}

@end
