//
//  LLTabBarViewController.m
//  LLHuanXin
//
//  Created by liushaohua on 2017/1/7.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "LLTabBarViewController.h"

@interface LLTabBarViewController ()

@end

@implementation LLTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize{
    
    UITabBar *tabBar = [UITabBar appearance];
    tabBar.tintColor = [UIColor colorWithRed:32/255.0 green:190/255.0 blue:30/255.0 alpha:1.0];
    
}

@end
