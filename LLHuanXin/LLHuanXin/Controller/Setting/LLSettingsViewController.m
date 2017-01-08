//
//  LLSettingsViewController.m
//  LLHuanXin
//
//  Created by liushaohua on 2017/1/7.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "LLSettingsViewController.h"
#import "LLLoginViewController.h"
@interface LLSettingsViewController ()

@end

@implementation LLSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 3 && indexPath.row == 0 ) {
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            NSLog(@"退出成功");
            UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            LLLoginViewController *loginVC =  [mainSb instantiateInitialViewController];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
        }
    }
}


@end
