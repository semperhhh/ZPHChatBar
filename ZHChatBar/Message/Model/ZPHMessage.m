//
//  ZPHMessage.m
//  ZHChatBar
//
//  Created by zph on 27/03/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import "ZPHMessage.h"

@implementation ZPHMessage

/**
 *  重写init方法
 */
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(instancetype)messageWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
