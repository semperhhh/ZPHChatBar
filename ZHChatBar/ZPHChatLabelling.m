//
//  ZPHChatMoreView.m
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/18.
//  Copyright © 2017年 zph. All rights reserved.
//

#import "ZPHChatLabelling.h"

@interface ZPHChatLabelling ()
/**
 点击的button
 */
@property (nonatomic,strong)UIButton *seleButton;
@end

@implementation ZPHChatLabelling

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

//更新布局
-(void)reloadData {

    NSArray *array = [self.dataSource titlesOfbtnLabelling];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / array.count;

    for (int i = 0; i < array.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i +1000;//区分tag
        [btn setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i * width, 0, width, 32);
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

-(void)buttonAction:(UIButton *)sender {
    
    ZPHChatLabellingType labellingType = sender.tag -1000;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatLabelling:selectIndex:)]) {
        [self.delegate chatLabelling:self selectIndex:labellingType];
    }
}

-(void)setDataSource:(id<ZPHChatLabellingDataSource>)dataSource {
    
    _dataSource = dataSource;
    [self reloadData];
}

@end
