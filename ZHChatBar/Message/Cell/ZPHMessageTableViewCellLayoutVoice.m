//
//  ZPHMessageTableViewCellLayoutVoice.m
//  ZHChatBar
//
//  Created by zph on 27/03/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import "ZPHMessageTableViewCellLayoutVoice.h"

@implementation ZPHMessageTableViewCellLayoutVoice

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        
        ZPHMessage *messageModel = [ZPHMessage messageWithDic:dictionary];
        
        if (messageModel.isSelf) {
            [self setRightLayoutWithModel:messageModel];
        }else {
            [self setLeftLayoutWithModel:messageModel];
        }
    }
    
    return self;
}

//左
-(void)setLeftLayoutWithModel:(ZPHMessage *)model {
    
    [super setLeftLayoutWithModel:model];
}

//右
-(void)setRightLayoutWithModel:(ZPHMessage *)model {
    
    [super setRightLayoutWithModel:model];
}
@end
