//
//  ZPHChatMoreView.h
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/18.
//  Copyright © 2017年 zph. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPHChatLabelling;

typedef NS_ENUM(NSInteger,ZPHChatLabellingType) {
    ZPHChatLabellingTypeCamera = 0,
    ZPHChatLabellingTypeFace,
    ZPHChatLabellingTypePicture,
    ZPHChatLabellingTypeVoice,
    ZPHChatLabellingTypeMore,
};

@protocol ZPHChatLabellingDataSource <NSObject>

@required
/**
 标签数组

 @return 数组
 */
-(NSArray *)titlesOfbtnLabelling;

@end

@protocol ZPHChatLabellingDelegate <NSObject>

@optional
/**
 选择

 @param chatLabelling 标签
 @param itemType 选择的类型
 */
-(void)chatLabelling:(ZPHChatLabelling *)chatLabelling selectIndex:(ZPHChatLabellingType)itemType;

@end

@interface ZPHChatLabelling : UIView
@property (nonatomic,strong)NSArray *btnLabellingArray;
/**
 数据代理
 */
@property (nonatomic,weak)id<ZPHChatLabellingDataSource> dataSource;
@property (nonatomic,weak)id<ZPHChatLabellingDelegate> delegate;
@end
