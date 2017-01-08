//
//  LLAddContactViewController.m
//  LLHuanXin
//
//  Created by liushaohua on 2017/1/7.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "LLAddContactViewController.h"

@interface LLAddContactViewController ()<UITextFieldDelegate>

@end

@implementation LLAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    EMError *error = [[EMClient sharedClient].contactManager addContact:textField.text message:@"我想加您为好友"];
    if (!error) {
        NSLog(@"发送请求成功");
    }
    return YES;

}


@end
