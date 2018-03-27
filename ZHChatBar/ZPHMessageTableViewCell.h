//
//  ZPHMessageTableViewCell.h
//  ZHChatBar
//
//  Created by zph on 27/03/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPHMessageTableViewCellLayout.h"

/**
 *  消息类型
 */
typedef NS_ENUM(NSUInteger, ZPHMessageType){
    ZPHMessageTypeText = 0 /**< 文本消息 */,
    ZPHMessageTypeImage /**< 图片消息 */,
    ZPHMessageTypeVoice /**< 语音消息 */,
    ZPHMessageTypeUnknow /**< 未知的消息类型 */,
};

@interface ZPHMessageTableViewCell : UITableViewCell
/**
 头像
 */
@property (nonatomic,strong)UIImageView *headImageView;
/**
 消息背景
 */
@property (nonatomic,strong)UIImageView *messageBackView;
/**
 *  消息的类型,只读类型,会根据自己的具体实例类型进行判断
 */
@property (nonatomic, assign)ZPHMessageType messageType;
/**
 时间
 */
@property (nonatomic,strong)UILabel *timeLabel;
/**
 数据和布局
 */
@property (nonatomic,strong)ZPHMessageTableViewCellLayout *layout;
/**
 行高
 */
@property (nonatomic,assign)CGFloat rowHeight;
@end
