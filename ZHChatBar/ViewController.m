//
//  ViewController.m
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/12.
//  Copyright © 2017年 zph. All rights reserved.
//

#import "ViewController.h"
#import "ZHChatBar.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
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
/**
 消息列表
 */
@property (nonatomic,strong)UITableView *messageTableView;
/**
 消息数组
 */
@property (nonatomic,strong)NSMutableArray *messageArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:self];
    [UIApplication sharedApplication].delegate.window.rootViewController = navi;
    
    _messageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -_zhChatBar.frame.size.height -64) style:UITableViewStylePlain];
    _messageTableView.dataSource = self;
    _messageTableView.delegate = self;
    [self.view addSubview:_messageTableView];
    _messageTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    UITapGestureRecognizer *tableViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    tableViewTap.cancelsTouchesInView = NO;
    [_messageTableView addGestureRecognizer:tableViewTap];

    _zhChatBar = [[ZHChatBar alloc]init];
    _zhChatBar.superController = self;
    [_zhChatBar setSuperViewHeight:[UIScreen mainScreen].bounds.size.height];
    [self.view addSubview:_zhChatBar];
}

//列表点击事件
-(void)hideKeyboard {
    
    [_zhChatBar endInputing];
}

#pragma mark --UITableViewDataSoure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [UITableViewCell new];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesbegan");
    //取消整个view的第一响应者
    [_zhChatBar endInputing];
}

#pragma mark --lazy loading
//消息数组
-(NSMutableArray *)messageArray {
    
    if (!_messageArray) {
        _messageArray = [[NSMutableArray alloc]init];
    }
    return _messageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
