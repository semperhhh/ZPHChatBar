//
//  ViewController.m
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/12.
//  Copyright © 2017年 zph. All rights reserved.
//

#import "ViewController.h"
#import "ZHChatBar.h"

@interface ViewController ()
/**
 文本框
 */
@property (nonatomic,strong)UITextView *textView;
/**
 放按钮的背景
 */
@property (nonatomic,strong)UIView *backView;
/**
 输入框
 */
@property (nonatomic,strong)ZHChatBar *zhChatBar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _zhChatBar = [[ZHChatBar alloc]init];
    _zhChatBar.superController = self;
    [_zhChatBar setSuperViewHeight:[UIScreen mainScreen].bounds.size.height];
    [self.view addSubview:_zhChatBar];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesbegan");
    //取消整个view的第一响应者
    [_zhChatBar endInputing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
