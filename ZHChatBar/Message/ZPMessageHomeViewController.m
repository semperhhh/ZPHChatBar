//
//  ZPMessageHomeViewController.m
//  ZHChatBar
//
//  Created by aaa on 2018/9/3.
//  Copyright © 2018年 zph. All rights reserved.
//

#import "ZPMessageHomeViewController.h"
#import "ZPMessageHomeTableCell.h"
#import "ZPMessageViewController.h"//聊天

@interface ZPMessageHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 列表
 */
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation ZPMessageHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"对话";
    self.view.backgroundColor = UIColorRandom;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Kscreen_width, Kscreen_height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 88;
    
    [_tableView registerClass:[ZPMessageHomeTableCell class] forCellReuseIdentifier:@"cell"];
}

#pragma markd --UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPMessageHomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZPMessageViewController *message = [[ZPMessageViewController alloc]init];
    message.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
