//
//  ZPHTextView.h
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/12.
//  Copyright © 2017年 zph. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPHTextView : UITextView
/**
 占位文字
 */
@property (nonatomic,strong)NSString *placeholderString;
/**
 文字颜色
 */
@property (nonatomic,strong)UIColor *placeholderColor;
/**
 文本
 */
@property (nonatomic,strong)UILabel *placeholderLabel;
@end
