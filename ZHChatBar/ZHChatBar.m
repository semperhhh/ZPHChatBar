//
//  ZHChatBar.m
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/12.
//  Copyright © 2017年 zph. All rights reserved.
//

#import "ZHChatBar.h"
#import "ZPHTextView.h"
#import "ZPHChatLabelling.h"
#import "ZPHChatMoreView.h"

@interface ZHChatBar ()<UITextViewDelegate,ZPHChatLabellingDataSource,ZPHChatLabellingDelegate>
/**
 文本框
 */
@property (nonatomic,strong)ZPHTextView *textView;
/**
 放按钮的背景
 */
@property (nonatomic,strong)ZPHChatLabelling *backView;
/**
 keyboard位置
 */
@property (nonatomic,assign)CGRect keyboardFrame;
/**
 更多界面
 */
@property (nonatomic,strong)ZPHChatMoreView *chatmoreView;
@property (nonatomic,assign)CGFloat bottomHeight;
@end
@implementation ZHChatBar

-(instancetype)init {
    
    self = [self initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -64, [UIScreen mainScreen].bounds.size.width, 64)];
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [self setupUI];
    }
    
    return self;
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
    self.keyboardFrame = CGRectZero;
    [self textViewDidChange:self.textView];
}

-(void)keyboardFrameWillChange:(NSNotification *)notification {
    
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(self.keyboardFrame));
    [self textViewDidChange:self.textView];
}

-(void)setupUI {

    [self addSubview:self.textView];
    [self addSubview:self.backView];
}

//输入框将要改变
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    //占位符判断
    self.textView.placeholderLabel.hidden = textView.text.length != 0 ? YES : NO;
}

//输入框改变
-(void)textViewDidChange:(UITextView *)textView {
    
    CGRect textViewFrame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, self.textView.frame.size.height + kChatLabellingHeight);
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    CGFloat offset = 10;
    textView.scrollEnabled = (textSize.height +0.1 > kMaxHeight -offset);
//    textViewFrame.size.height = MAX(34, MIN(kMaxHeight, textSize.height));    //应该是自适应高度
    
    CGRect addBarFrame = self.frame;
    addBarFrame.size.height = textViewFrame.size.height;
    addBarFrame.origin.y = self.superViewHeight - self.bottomHeight - addBarFrame.size.height;
    [self setFrame:addBarFrame animated:NO];
    if (textView.scrollEnabled) {
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 2, 1)];
    }
}

#pragma mark --ZPHChatLabellingDataSource
-(NSArray *)titlesOfbtnLabelling {
    
    return @[@"zphChatCamera",@"zphChatFace",@"zphChatPicture",@"zphChatVoice",@"zphChatAdd"];
}

#pragma mark --ZPHChatLabellingDelegate
-(void)chatLabelling:(id)chatLabelling selectIndex:(ZPHChatLabellingType)itemType {
    
    [self endInputing];
    
    switch (itemType) {
        case ZPHChatLabellingTypeCamera: {
            
            NSLog(@"camera");
        }
            break;
        case ZPHChatLabellingTypeFace: {
            
            NSLog(@"face");
        }
            break;
        case ZPHChatLabellingTypePicture: {
            
            NSLog(@"picture");
        }
            break;
        case ZPHChatLabellingTypeVoice: {
            
            NSLog(@"voice");
        }
            break;
        case ZPHChatLabellingTypeMore: {
            
            NSLog(@"more");
            [self setFrame:CGRectMake(0, self.superViewHeight -270, self.frame.size.width, 270) animated:YES];
        }
            break;
        default:
            break;
    }
}

//添加占位符
-(void)chatAddTextViewPlaceholderWithTitle:(NSString *)title placeholderColor:(UIColor *)color {
    
    self.textView.placeholderColor = color;
    self.textView.placeholderString = title;
}

//关闭输入框
-(void)endInputing {
    
    [self.textView resignFirstResponder];
}


-(CGFloat)bottomHeight {
    
//    if (self.chatmoreView) {
//        return MAX(self.keyboardFrame.size.height, self.chatmoreView.frame.size.height);
//    }else{
        return MAX(self.keyboardFrame.size.height, CGFLOAT_MIN);
//    }
}

#pragma mark --lazy loading
-(ZPHTextView *)textView {//输入框
    
    if (!_textView) {
    
        _textView = [[ZPHTextView alloc]initWithFrame:CGRectMake(5, 0, self.bounds.size.width -10, self.bounds.size.height -32)];
        _textView.inputAccessoryView = [[UIView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderWidth = .5f;
        _textView.layer.masksToBounds = YES;
    }
    
    return _textView;
}

//按钮条
-(ZPHChatLabelling *)backView {
    
    if (!_backView) {
        
        _backView = [[ZPHChatLabelling alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), self.bounds.size.width, 32)];
        _backView.dataSource = self;
        _backView.delegate = self;
    }
    return _backView;
}

//更多界面
-(ZPHChatMoreView *)chatmoreView {
    
    if (!_chatmoreView) {
        _chatmoreView = [[ZPHChatMoreView alloc]init];
    }
    return _chatmoreView;
}

#pragma mark - Getters
- (void)setFrame:(CGRect)frame animated:(BOOL)animated{
    
    if (animated) {
        [UIView animateWithDuration:.3 animations:^{
            [self setFrame:frame];
        }];
    }else{
        [self setFrame:frame];
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBarFrameDidChange:frame:)]) {
//        [self.delegate chatBarFrameDidChange:self frame:frame];
//    }
}
@end
