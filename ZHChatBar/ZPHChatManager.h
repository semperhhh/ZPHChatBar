//
//  ZPHChatManager.h
//  ZHChatBar
//
//  Created by zph on 04/04/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPHChatManager : NSObject
//单例
+(instancetype)shareManager;
/**
 发送文本消息

 @param content 文本
 @param answerBlock 机器人答案回调
 */
+(void)sendChatMessageWithContent:(NSString *)content answerBlock:(void(^)(id data))answerBlock;
/**
 发送图片消息

 @param imageData 图片
 */
+(void)sendChatPictureWithImageData:(NSData *)imageData;
/**
 发送语音消息

 @param voiceData 语音
 */
+(void)sendChatVoiceWithVoiceData:(NSData *)voiceData;
@end
