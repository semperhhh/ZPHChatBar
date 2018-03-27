//
//  ZPHMessage.h
//  ZHChatBar
//
//  Created by zph on 27/03/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPHMessage : NSObject
/**
 内容
 */
@property (nonatomic,copy)NSString *content;
/**
 类型
 */
@property (nonatomic,assign)int category;
/**
 是否自己发送
 */
@property (nonatomic,assign)BOOL isSelf;
/**
 时间字符串
 */
@property (nonatomic,copy)NSString *time;

//重写init方法
-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)messageWithDic:(NSDictionary *)dic;
@end
