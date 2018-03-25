//
//  ZHChatBar.m
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/12.
//  Copyright © 2017年 zph. All rights reserved.
//

//适配iphonex
#define StausbarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define iPhoneX  StausbarHeight >20? YES:NO
// 底部安全区域远离高度
#define kBottomSafeHeight   (StausbarHeight >20? 34 : 0)

#import "ZHChatBar.h"
#import "ZPHTextView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZPHChatLabelling.h"//标签
#import "ZPHChatMoreView.h" //更多
#import "ZPHChatFaceView.h" //表情

CGFloat chatBarHeight = 64;
CGFloat chatBarMoreHeight = 270;
CGFloat chatBarFaceHeight = 200;

@interface ZHChatBar ()<UITextViewDelegate,ZPHChatLabellingDataSource,ZPHChatLabellingDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
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
/**
 表情界面
 */
@property (nonatomic,strong)ZPHChatFaceView *chatfaceView;
@property (nonatomic,assign)CGFloat bottomHeight;
@end
@implementation ZHChatBar

-(instancetype)init {
    
    self = [self initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height -64, [UIScreen mainScreen].bounds.size.width, chatBarHeight)];
    
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

#pragma mark --UITextViewDelegate

//输入框将要改变
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    //占位符判断
    self.textView.placeholderLabel.hidden = textView.text.length != 0 ? YES : NO;
    [self showMoreView:NO];
    [self showFaceView:NO];
}

//输入框改变
-(void)textViewDidChange:(UITextView *)textView {
    
    CGRect textViewFrame = self.textView.frame;
    
    //文本size
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    
    CGFloat offset = 10;
    //文本的滚动
    textView.scrollEnabled = (textSize.height +0.1 > kMaxHeight -offset);
    //文本框的高
    textViewFrame.size.height = 64;
    
    //文本框的位置
    CGRect addBarFrame = self.frame;
    addBarFrame.size.height = textViewFrame.size.height;
    addBarFrame.origin.y = self.superViewHeight - self.bottomHeight - addBarFrame.size.height;
    [self setFrame:addBarFrame animated:NO];
    
    //文本框滚动
    if (textView.scrollEnabled) {
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 2, 1)];
    }
}

//文本框限制输入
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSLog(@"textView change text - %@",text);
    
    if ([text isEqualToString:@"\n"]) {
        
        [self setTextMessage:text];
        return NO;
    }

    return YES;
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
            [self chatStartTheCamera];
        }
            break;
        case ZPHChatLabellingTypeFace: {
            
            NSLog(@"face");
            [self showFaceView:YES];
            [self showMoreView:NO];
        }
            break;
        case ZPHChatLabellingTypePicture: {
            
            NSLog(@"picture");
            [self chatStartThePhotoAlbum];
        }
            break;
        case ZPHChatLabellingTypeVoice: {
            
            NSLog(@"voice");
        }
            break;
        case ZPHChatLabellingTypeMore: {
            
            NSLog(@"more");
            [self showMoreView:YES];
            [self showFaceView:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark --切换界面
-(void)showViewWithType:(PHViewShowType)showType {
    
    
}

//表情展示
-(void)showFaceView:(BOOL)show {
    
    if (show) {
        
        [self addSubview:self.chatfaceView];
        [self setFrame:CGRectMake(0, self.superViewHeight -chatBarFaceHeight -chatBarHeight -kBottomSafeHeight, self.frame.size.width, chatBarHeight) animated:YES];
    }else {
        
        [self.chatfaceView removeFromSuperview];
    }
}

//更多展示
-(void)showMoreView:(BOOL)show {
    
    if (show) {
        
        [self addSubview:self.chatmoreView];
        [self setFrame:CGRectMake(0, self.superViewHeight -chatBarMoreHeight -chatBarHeight -kBottomSafeHeight, self.frame.size.width, chatBarHeight) animated:YES];
    }else {
        [self.chatmoreView removeFromSuperview];
    }
}

#pragma mark --调用相机
-(void)chatStartTheCamera {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//读取设备授权状态
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        NSLog(@"相机权限受限");
        return;
    }
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"设备没有摄像头");
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.superController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark --调用相册
-(void)chatStartThePhotoAlbum {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.superController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark --UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSLog(@"%@",info);
    //调用代理
}

#pragma mark --发送消息
//发送文本
-(void)setTextMessage:(NSString *)message {
    
    if (!message && message.length == 0) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBarSendMessageWithChatBar:message:)]) {
        [self.delegate chatBarSendMessageWithChatBar:self message:message];
    }
}

//发送图片
-(void)setPictureMessage:(UIImage *)image {
    
    
}
//发送声音
-(void)setVoiceData:(NSData *)voiceData {
    
    
}

#pragma mark --添加占位符
-(void)chatAddTextViewPlaceholderWithTitle:(NSString *)title placeholderColor:(UIColor *)color {
    
    self.textView.placeholderColor = color;
    self.textView.placeholderString = title;
}

//关闭输入框
-(void)endInputing {
    
    [self.textView resignFirstResponder];//取消键盘响应
    [self setFrame:CGRectMake(0, self.superViewHeight -chatBarHeight, self.frame.size.width, chatBarHeight) animated:YES];//输入框移到底部
}

//chatbar到底部的距离
-(CGFloat)bottomHeight {
    
    if (self.chatmoreView.superview) {
        return MAX(self.keyboardFrame.size.height, self.chatmoreView.frame.size.height);
    }else{
        return MAX(self.keyboardFrame.size.height, CGFLOAT_MIN);
    }
}

#pragma mark --lazy loading

//输入框
-(ZPHTextView *)textView {
    
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

//表情界面
-(ZPHChatFaceView *)chatfaceView {
    
    if (!_chatfaceView) {
        _chatfaceView = [[ZPHChatFaceView alloc]init];
    }
    return _chatfaceView;
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
