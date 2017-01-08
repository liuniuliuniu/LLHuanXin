//
//  LLNavigationController.m
//  LLHuanXin
//
//  Created by liushaohua on 2017/1/7.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "LLNavigationController.h"

@interface LLNavigationController ()

@end

@implementation LLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize{
    UINavigationBar *navBar =  [UINavigationBar appearance];
    navBar.barStyle = UIBarStyleBlack;
    navBar.tintColor = [UIColor whiteColor];
}
@end
