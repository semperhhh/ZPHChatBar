//
//  ZPMessageHomeTableCell.m
//  ZHChatBar
//
//  Created by aaa on 2018/9/3.
//  Copyright © 2018年 zph. All rights reserved.
//

#import "ZPMessageHomeTableCell.h"

@implementation ZPMessageHomeTableCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        self.backgroundColor = UIColorRandom;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
