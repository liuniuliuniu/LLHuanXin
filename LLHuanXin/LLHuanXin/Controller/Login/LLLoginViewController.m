//
//  LLLoginViewController.m
//  LLHuanXin
//
//  Created by liushaohua on 2017/1/7.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "LLLoginViewController.h"

@interface LLLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountFld;

@property (weak, nonatomic) IBOutlet UITextField *psdFld;


@end

@implementation LLLoginViewController
- (IBAction)registerBtnClick:(id)sender {
    
    EMError *error = [[EMClient sharedClient] registerWithUsername:self.accountFld.text password:self.psdFld.text];
    if (error==nil) {
        NSLog(@"注册成功");
    }else{
        
        NSLog(@"%@",error);
    }
}
- (IBAction)loginBtnClick:(id)sender {
    EMError *error = [[EMClient sharedClient] loginWithUsername:self.accountFld.text password:self.psdFld.text];
    if (!error) {
        NSLog(@"登录成功");
        // 自动登录
         [[EMClient sharedClient].options setIsAutoLogin:YES];
        //跳转控制器
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarVc = [mainSB instantiateViewControllerWithIdentifier:@"LLTabBar"];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;

    }

}


@end
