//
//  ZPHTextView.m
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/12.
//  Copyright © 2017年 zph. All rights reserved.
//

#import "ZPHTextView.h"

@interface ZPHTextView ()

@end
@implementation ZPHTextView

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.numberOfLines = 1;
        [self addSubview:_placeholderLabel];
        
        self.placeholderColor = [UIColor lightGrayColor];//设置占位文字默认颜色
        self.font = [UIFont systemFontOfSize:15];//默认字体
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
    }
    
    return self;
}

#pragma mark -监听文字改变
- (void)textDidChange {
    
    self.placeholderLabel.hidden = self.hasText;
    
}

#pragma mark - 设置label的frame
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect frame = self.placeholderLabel.frame;
    frame.origin.y = 8;
    frame.origin.x = 5;
    frame.size.width = self.frame.size.width-self.placeholderLabel.frame.origin.x*2.0;
    frame.size.height = 18;
    
    self.placeholderLabel.frame = frame;
    
}
- (void)setPlaceholderString:(NSString *)placeholderString {
    
    _placeholderString= [placeholderString copy];
    
    //设置文字
    
    self.placeholderLabel.text= placeholderString;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor= placeholderColor;
    
    //设置颜色
    
    self.placeholderLabel.textColor= placeholderColor;
    
}
//重写这个set方法保持font一致

- (void)setFont:(UIFont*)font {
    
    [super setFont:font];
    
    self.placeholderLabel.font= font;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}
- (void)setText:(NSString*)text{
    
    [super setText:text];
    
    [self textDidChange]; //这里调用的就是 UITextViewTextDidChangeNotification 通知的回调
    
}
- (void)setAttributedText:(NSAttributedString*)attributedText {
    
    [super setAttributedText:attributedText];
    
    [self textDidChange]; //这里调用的就是UITextViewTextDidChangeNotification 通知的回调
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:UITextViewTextDidChangeNotification];
    
}


@end
