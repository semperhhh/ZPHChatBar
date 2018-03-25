//
//  ZPHChatFaceView.m
//  ZHChatBar
//
//  Created by zph on 25/03/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import "ZPHChatFaceView.h"

@implementation ZPHChatFaceView

-(instancetype)init {
    
    self = [self initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 210)];
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

@end
