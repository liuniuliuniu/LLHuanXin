//
//  LLUserInfoViewController.m
//  LLHuanXin
//
//  Created by liushaohua on 2017/1/8.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "LLUserInfoViewController.h"
#import "LLChatDetailViewController.h"

@interface LLUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@end

@implementation LLUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.nameLable.text = self.userName;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    LLChatDetailViewController *chatVC = segue.destinationViewController;
    chatVC.userName = self.userName;
    
    
}

#pragma mark - Table view data source

@end
