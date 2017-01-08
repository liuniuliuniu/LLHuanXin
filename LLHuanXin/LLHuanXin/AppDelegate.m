//
//  AppDelegate.m
//  LLHuanXin
//
//  Created by liushaohua on 2017/1/7.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "AppDelegate.h"
// SDK
#import "EMSDK.h"

// VC
#import "LLContatViewController.h"


@interface AppDelegate ()<EMClientDelegate,EMContactManagerDelegate,EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject);
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    EMOptions *options = [EMOptions optionsWithAppkey:@"1143161217115750#llhuanxin"];
    options.apnsCertName = nil;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    // 是否自动登录
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (isAutoLogin) {
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tabBarVc = [mainSB instantiateViewControllerWithIdentifier:@"LLTabBar"];
        self.window.rootViewController = tabBarVc;
    }
    
    
    
    // 注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

    return YES;
}

#pragma mark - EMChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages{

    NSLog(@"收到消息");
    
    [[NSNotificationCenter defaultCenter]postNotificationName:KLLHuanXinDidReciveMsgInfo object:nil];
    
    
}




#pragma mark - EMContactManagerDelegate
/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调(接收到好友请求)
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"好友请求" message:[NSString stringWithFormat:@"收到来自%@的好友请求,附加信息为%@",aUsername,aMessage] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
        if (!error) {
            NSLog(@"发送同意成功");
            
            
            // 要刷新联系人列表
            UITabBarController *tabberVC = self.window.rootViewController;
            LLContatViewController *contactVC = tabberVC.childViewControllers[1].childViewControllers[0];
            [contactVC getContactsFromServer];

            
            
        }
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
        if (!error) {
            NSLog(@"发送拒绝成功");
        }
    }];
    
    [alertC addAction:action1];
    [alertC addAction:action2];
    
    [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
    
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)friendRequestDidApproveByUser:(NSString *)aUsername{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"好友通知" message:[NSString stringWithFormat:@"%@已经成为你的好友",aUsername] preferredStyle:UIAlertControllerStyleAlert];
    [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
    // 要刷新联系人列表
    UITabBarController *tabberVC = self.window.rootViewController;
    LLContatViewController *contactVC = tabberVC.childViewControllers[1].childViewControllers[0];
    [contactVC getContactsFromServer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertC dismissViewControllerAnimated:YES completion:nil];
    });
 
}


/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"好友通知" message:[NSString stringWithFormat:@"%@拒绝成为你的好友",aUsername] preferredStyle:UIAlertControllerStyleAlert];
    
    [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertC dismissViewControllerAnimated:YES completion:nil];
    });
}


//用户B删除与用户A的好友关系后，用户A会收到这个回调
- (void)friendshipDidRemoveByUser:(NSString *)aUsername{
    
    //刷新联系人列表
    UITabBarController *tabBarVc = self.window.rootViewController;
    LLContatViewController *contactVc = tabBarVc.childViewControllers[1].childViewControllers[0];
    [contactVc getContactsFromServer];
}






- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


#pragma mark - EMClientDelegate

/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState{
    
    NSLog(@"连接状态发生变化后调用");
}







@end
