//
//  ViewController.m
//  ZHChatBar
//
//  Created by 张鹏辉 on 2017/9/12.
//  Copyright © 2017年 zph. All rights reserved.
//

#import "ViewController.h"
#import "ZHChatBar.h"
#import "ZPHMessageTableViewCellLayout.h"
#import "ZPHMessageTableViewCell.h"
#import "ZPHMessageTableViewCellText.h"
#import "ZPHMessageTableViewCellImage.h"
#import "ZPHMessageTableViewCellVoice.h"
#import "ZPHChatManager.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ZHChatBarDelegate>
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
    
    self.navigationItem.title = @"对话";
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    //消息列表
    _messageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -64 -64) style:UITableViewStylePlain];
    _messageTableView.backgroundColor = [UIColor clearColor];
    _messageTableView.dataSource = self;
    _messageTableView.delegate = self;
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_messageTableView];
    _messageTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    //添加列表点击
    UITapGestureRecognizer *tableViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    tableViewTap.cancelsTouchesInView = NO;
    [_messageTableView addGestureRecognizer:tableViewTap];

    //输入框
    _zhChatBar = [[ZHChatBar alloc]init];
    _zhChatBar.superController = self;
    _zhChatBar.delegate = self;
    [_zhChatBar setSuperViewHeight:[UIScreen mainScreen].bounds.size.height];
    [self.view addSubview:_zhChatBar];
    
    //注册cell
    [_messageTableView registerClass:[ZPHMessageTableViewCellText class] forCellReuseIdentifier:@"OwnerOther_text"];
    [_messageTableView registerClass:[ZPHMessageTableViewCellImage class] forCellReuseIdentifier:@"OwnerOther_image"];
    [_messageTableView registerClass:[ZPHMessageTableViewCellVoice class] forCellReuseIdentifier:@"OwnerOther_voice"];
    [_messageTableView registerClass:[ZPHMessageTableViewCellText class] forCellReuseIdentifier:@"OwnerSelf_text"];
    [_messageTableView registerClass:[ZPHMessageTableViewCellImage class] forCellReuseIdentifier:@"OwnerSelf_image"];
    [_messageTableView registerClass:[ZPHMessageTableViewCellVoice class] forCellReuseIdentifier:@"OwnerSelf_voice"];
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
    
    ZPHMessageTableViewCellLayout *layout = self.messageArray[indexPath.row];
    NSString *ownerKey; NSString *typeKey;
    switch (layout.model.isSelf) {
        case 0: ownerKey = @"OwnerOther"; break;
        case 1: ownerKey = @"OwnerSelf"; break;
    }
    switch (layout.model.category) {
        case 0: typeKey = @"text"; break;
        case 1: typeKey = @"image"; break;
        case 2: typeKey = @"voice"; break;
    }
    NSString *identifier = [NSString stringWithFormat:@"%@_%@",ownerKey,typeKey];
    ZPHMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row < self.messageArray.count) {
        cell.layout = layout;
    }
    
    return cell;
}

#pragma mark --UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.messageArray.count) {
        ZPHMessageTableViewCellLayout *layout = self.messageArray[indexPath.row];
        return layout.rowHeight;
    }else {
        return 0;
    }
}

-(void)addMessageWithDictionary:(NSDictionary *)messageDictionary isSelf:(BOOL)isSelf {
    
    NSLog(@"add message");
    
    //时间字符串
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];//设定时间格式
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    NSMutableDictionary *nmDictionary = [[NSMutableDictionary alloc]init];
    [nmDictionary setValue:messageDictionary[@"content"] forKey:@"content"];
    [nmDictionary setValue:messageDictionary[@"category"] forKey:@"category"];
    [nmDictionary setValue:dateStr forKey:@"time"];
    if (isSelf) {
        [nmDictionary setValue:@1 forKey:@"isSelf"];
    }else {
        [nmDictionary setValue:@0 forKey:@"isSelf"];
    }
    
    //转模型
    ZPHMessageTableViewCellLayout *layout = [[ZPHMessageTableViewCellLayout alloc]initWithDictionary:nmDictionary];
    
    //保存到数组
    [self.messageArray addObject:layout];
    
    //更新ui
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSIndexPath* insertion = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
        [self.messageTableView reloadData];
        [self tableviewScrollToRowWithIndex:insertion];
    });
}

#pragma mark --ZHChatBarDelegate
-(void)chatBarSendMessageWithChatBar:(ZHChatBar *)chatBar message:(NSString *)message {
    
//    NSLog(@"send message - %@",message);
    [self addMessageWithDictionary:@{@"category":@0,@"content":message} isSelf:YES];
    
    [ZPHChatManager sendChatMessageWithContent:message answerBlock:^(id data) {
        NSLog(@"请求到的data = %@",data);
        NSDictionary *dataDictionary = data;
        NSArray *results = dataDictionary[@"results"];
        for (NSDictionary *resultDict in results) {
            NSDictionary *valuesDict = resultDict[@"values"];
            [self addMessageWithDictionary:@{@"category":@0,@"content":valuesDict[@"text"]} isSelf:NO];
        }
    }];
}

-(void)chatBarSendPictureWithChatBar:(ZHChatBar *)chatBar picture:(UIImage *)image {
    
    NSLog(@"send picture");
}

-(void)chatBarSendVoiceWithChatBar:(ZHChatBar *)chatBar voice:(NSData *)voiceData {
    
    NSLog(@"send voice");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesbegan");
    //取消整个view的第一响应者
    [_zhChatBar endInputing];
}

//输入框改变
-(void)chatBarFrameDidChange:(ZHChatBar *)chatBar frame:(CGRect)frame {
    
    __weak ViewController *weakSelf = self;
    
    if (frame.origin.y == _messageTableView.frame.size.height) {
        return;
    }
    
    if (self.messageArray.count != 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.1 animations:^{
                [weakSelf.messageTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, frame.origin.y)];
                NSIndexPath * lastIndex = [NSIndexPath indexPathForRow:weakSelf.messageArray.count-1 inSection:0];
                [weakSelf tableviewScrollToRowWithIndex:lastIndex];
                
            } completion:nil];
        });
    }
}

//滑动
-(void)tableviewScrollToRowWithIndex:(NSIndexPath *)lastIndex {
    
    dispatch_queue_t queue = dispatch_queue_create("MessageArray", DISPATCH_QUEUE_SERIAL);//串行队列
    
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.messageTableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
    });
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
