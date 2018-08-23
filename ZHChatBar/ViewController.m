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
#import <FMDB/FMDatabase.h>

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
/**
 数据库
 */
@property (nonatomic,strong)FMDatabase *dataBase;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:self];
    [UIApplication sharedApplication].delegate.window.rootViewController = navi;
    
    self.navigationItem.title = @"对话";
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    //消息列表
    _messageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopBarHeight, self.view.frame.size.width, self.view.frame.size.height -kTopBarHeight -64) style:UITableViewStylePlain];
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

    [self createData];
    
    NSArray *array = [self readData];
    
    for (NSDictionary *dict in array) {
        
        ZPHMessageTableViewCellLayout *layout = [[ZPHMessageTableViewCellLayout alloc]initWithDictionary:dict];
        //保存到数组
        [self.messageArray addObject:layout];
    }
}

//创建数据库
-(void)createData {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:@"message.sqlite"];
    NSLog(@"fileName = %@",fileName);
    
    _dataBase = [FMDatabase databaseWithPath:fileName];
    
    if ([_dataBase open]) {
        NSLog(@"打开数据库成功");
    }else {
        NSLog(@"打开数据库失败");
    }
    
    //数据库建表
    BOOL result = [_dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_message (id integer PRIMARY KEY AUTOINCREMENT, name text, message text, time text, category integer, isSelf bool)"];
    if (result) {
        NSLog(@"创建表成功");
    }else {
        NSLog(@"创建表失败");
    }
}

//读取数据库
-(NSArray *)readData {
    
    FMResultSet *resultSet = [_dataBase executeQuery:@"select * from t_message"];
    
    if (resultSet) {
        NSMutableArray *nmArray = [NSMutableArray array];
        while ([resultSet next]) {
            NSString *name = [resultSet objectForColumn:@"name"];
            NSString *category = [resultSet objectForColumn:@"category"];
            NSString *message = [resultSet objectForColumn:@"message"];
            NSString *time = [resultSet objectForColumn:@"time"];
            NSString *isSelf = [resultSet objectForColumn:@"isSelf"];
            NSLog(@"name= %@, category= %@, message= %@ time= %@ isSelf= %@",name,category,message,time,isSelf);
            NSMutableDictionary *nmDictionary = [NSMutableDictionary dictionary];
            [nmDictionary setValue:name forKey:@"name"];
            [nmDictionary setValue:@([category integerValue]) forKey:@"category"];
            [nmDictionary setValue:message forKey:@"content"];
            [nmDictionary setValue:time forKey:@"time"];
            [nmDictionary setValue:@([isSelf integerValue]) forKey:@"isSelf"];
            [nmArray addObject:nmDictionary];
        }
        return nmArray;
        
    }else {
        NSLog(@"查询失败");
    }
    return nil;
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
    
    NSLog(@"send message - %@",message);
    [self addMessageWithDictionary:@{@"category":@0,@"content":message} isSelf:YES];

    [ZPHChatManager sendChatMessageWithContent:message answerBlock:^(id data) {
        
        NSLog(@"请求到的data = %@",data);
        NSDictionary *dataDictionary = data;
        NSArray *results = dataDictionary[@"results"];
        for (NSDictionary *resultDict in results) {
            NSDictionary *valuesDict = resultDict[@"values"];
            [self addMessageWithDictionary:@{@"category":@0,@"content":valuesDict[@"text"]} isSelf:NO];
            
            //保存到库
            BOOL success = [_dataBase executeUpdate:@"insert into t_message (name, category, message, isSelf) values (?, ?, ?, ?);", @"robit" ,@0, valuesDict[@"text"], @0];
            if (success) {
                NSLog(@"保存到数据库成功");
            }else {
                NSLog(@"保存到数据库失败");
            }
        }
    }];
    
    //保存到库
    BOOL success = [_dataBase executeUpdate:@"insert into t_message (name, category, message, isSelf) values (?, ?, ?, ?);", @"myself", @0, message, @1];
    if (success) {
        NSLog(@"保存到数据库成功");
    }else {
        NSLog(@"保存到数据库失败");
    }
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
