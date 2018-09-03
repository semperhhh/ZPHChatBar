//
//  ZPNavigationController.m
//  ZHChatBar
//
//  Created by aaa on 2018/9/3.
//  Copyright © 2018年 zph. All rights reserved.
//

#import "ZPNavigationController.h"

@interface ZPNavigationController ()

@end

@implementation ZPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(void)initialize {
    
    //外观代理
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    NSDictionary *attrs = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    [navigationBar setTitleTextAttributes:attrs];
    navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    navigationBar.tintColor = [UIColor blackColor];
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
