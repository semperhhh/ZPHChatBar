//
//  ZPHUploadFile.h
//  ZPHDownImage
//
//  Created by zph on 31/01/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ZPHFileType){
    ZPHFileTypeImage = 0,//图片
    ZPHFileTypeVoice,   //音频
    ZPHFileTypeVideo,   //视频
};

@interface ZPHUploadFile : NSObject
/**
 网络请求

 @param URLString 网络地址
 @param method 请求方式 GET/POST
 @param params 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+(void)requestWithURLString:(NSString *)URLString httpMethod:(NSString *)method params:(NSDictionary *)params success:(void (^)(id data))success fail:(void (^)(NSError *error))fail;
/**
 上传文件

 @param urlStr 网络地址
 @param fileData data文件
 @param fileType 文件类型
 @param fileName 文件名称
 @param successBlock 成功回调
 @param errorBlock 失败回调
 */
+(void)uploadRequestWithUrl:(NSString *)urlStr Data:(NSData *)fileData fileType:(ZPHFileType)fileType fileName:(NSString *)fileName success:(void(^)(NSData *successData))successBlock error:(void(^)(NSError *error))errorBlock;
@end
