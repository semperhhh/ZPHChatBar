//
//  ZPHChatManager.m
//  ZHChatBar
//
//  Created by zph on 04/04/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import "ZPHChatManager.h"
#import "ZPHUploadFile.h"

@implementation ZPHChatManager

//单例
+(instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    static ZPHChatManager *netWork = nil;
    dispatch_once(&onceToken, ^{
        netWork = [[ZPHChatManager alloc]init];
    });
    
    return netWork;
}

#pragma mark --发送文本消息
+(void)sendChatMessageWithContent:(NSString *)content {

    return [[ZPHChatManager shareManager]chatMessageWithContent:content];
}

-(void)chatMessageWithContent:(NSString *)content {
    
    if (!content || content == nil) return;
    
    NSString *URLString = @"http://openapi.tuling123.com/openapi/api/v2";
    NSDictionary *perceptionDictionary = @{@"inputText":@{@"text":content}};
    NSDictionary *userInfoDictionary = @{@"apiKey":@"f810e4f4c7e140f39cb273b5cf70d31c",@"userId":@"123"};
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:perceptionDictionary,@"perception",userInfoDictionary,@"userInfo", nil];
    [ZPHUploadFile requestWithURLString:URLString httpMethod:@"POST" params:param success:^(id data) {
        
        NSLog(@"message data = %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    } fail:^(NSError *error) {
        NSLog(@"message error = %@",error);
    }];
}

#pragma mark --发送图片消息
+(void)sendChatPictureWithImageData:(NSData *)imageData {
    
    return [[ZPHChatManager shareManager]chatPictureWithImageData:imageData];
}

-(void)chatPictureWithImageData:(NSData *)imageData {
    
    
}

#pragma mark --发送语音消息
+(void)sendChatVoiceWithVoiceData:(NSData *)voiceData {
    
    return [[ZPHChatManager shareManager]chatVoiceWithVoiceData:voiceData];
}

-(void)chatVoiceWithVoiceData:(NSData *)voiceData {
    
    
}


@end
