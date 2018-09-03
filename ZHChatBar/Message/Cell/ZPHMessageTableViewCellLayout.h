//
//  ZPHMessageTableViewCellLayout.h
//  ZHChatBar
//
//  Created by zph on 27/03/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPHMessage.h"
#import <UIKit/UIKit.h>

@interface ZPHMessageTableViewCellLayout : NSObject
/**
 数据
 */
@property (nonatomic,strong)ZPHMessage *model;
/**
 行高
 */
@property (nonatomic,assign)CGFloat rowHeight;
/**
 时间frame
 */
@property (nonatomic,assign)CGRect timeFrame;
/**
 时间文本
 */
@property (nonatomic,strong)NSAttributedString *timeAttributedString;
/**
 头像frame
 */
@property (nonatomic,assign)CGRect headPictureFrame;
/**
 头像图片
 */
@property (nonatomic,strong)UIImage *headImage;
/**
 文本frame
 */
@property (nonatomic,assign)CGRect contentFrame;
/**
 背景frame
 */
@property (nonatomic,assign)CGRect messageBackViewFrame;
/**
 富文本内容
 */
@property (nonatomic,strong)NSMutableAttributedString *layoutAttributedString;
/**
 初始化

 @param dictionary 字典
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
/**
 左边布局

 @param model 数据模型
 */
-(void)setLeftLayoutWithModel:(ZPHMessage *)model;
/**
 右边布局

 @param model 数据模型
 */
-(void)setRightLayoutWithModel:(ZPHMessage *)model;
/**
 计算文本高度
 
 @param attributedString 富文本
 @param proSize 最大尺寸
 @return 文本尺寸
 */
-(CGSize)sizeWithAttributedString:(NSMutableAttributedString *)attributedString proSize:(CGSize)proSize;
@end
