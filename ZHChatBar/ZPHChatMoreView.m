//
//  ZPHChatMoreView.m
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/19.
//  Copyright © 2017年 zph. All rights reserved.
//

#import "ZPHChatMoreView.h"

@implementation ZPHChatMoreView

-(instancetype)init {
    
    self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 270)];
    
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
