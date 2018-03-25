//
//  ZHChatBar.h
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/12.
//  Copyright © 2017年 zph. All rights reserved.
//

#define kMaxHeight 60.0f
#define kMinHeight 45.0f
#define kFunctionViewHeight 210.0f
#define kChatLabellingHeight 32.0f

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PHViewShowType){
    PHViewShowTypeNothing = 0,  //不显示
    PHViewShowTypeFace = 2,     //显示表情
    PHViewShowTypeMore = 5,     //显示更多
};

@class ZHChatBar;

@protocol ZHChatBarDelegate <NSObject>

@optional

/**
 chatBarFrame改变回调

 @param chatBar 输入框
 @param frame 位置
 */
-(void)chatBarFrameDidChange:(ZHChatBar *)chatBar frame:(CGRect)frame;

@end

@interface ZHChatBar : UIView
@property (assign, nonatomic) CGFloat superViewHeight;
/**
 父控制器
 */
@property (nonatomic,strong)UIViewController *superController;
/**
 默认inti是64高度

 @return 输入框
 */
-(instancetype)init;
/**
 添加占位符内容和颜色

 @param title 内容
 @param color 颜色
 */
-(void)chatAddTextViewPlaceholderWithTitle:(NSString *)title placeholderColor:(UIColor *)color;
/**
 取消键盘
 */
-(void)endInputing;
@end
