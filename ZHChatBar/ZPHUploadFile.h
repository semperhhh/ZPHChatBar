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

+(void)uploadRequestWithUrl:(NSString *)urlStr Data:(NSData *)fileData fileType:(ZPHFileType)fileType fileName:(NSString *)fileName success:(void(^)(NSData *successData))successBlock error:(void(^)(NSError *error))errorBlock;
@end
