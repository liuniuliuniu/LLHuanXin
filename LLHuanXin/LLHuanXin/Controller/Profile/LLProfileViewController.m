//
//  LLProfileViewController.m
//  LLHuanXin
//
//  Created by liushaohua on 2017/1/7.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "LLProfileViewController.h"

@interface LLProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;

@end

@implementation LLProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userNameLbl.text = [EMClient sharedClient].currentUsername;
}


@end
