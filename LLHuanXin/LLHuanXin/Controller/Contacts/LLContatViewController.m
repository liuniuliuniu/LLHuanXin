//
//  LLContatViewController.m
//  LLHuanXin
//
//  Created by liushaohua on 2017/1/7.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "LLContatViewController.h"
#import "LLUserInfoViewController.h"

@interface LLContatViewController ()

@property (nonatomic, strong)NSArray<NSString *> *contacts;

@end

@implementation LLContatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getContactsFromServer];
}


- (void)getContactsFromServer{
    
    NSError *error = nil;
   NSArray *userList =  [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    
    if (!error) {
        // 赋值给数据源
        self.contacts = userList;
        // 刷新数据源
        [self.tableView reloadData];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"contacts"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        LLUserInfoViewController *userVC = segue.destinationViewController;

        userVC.userName = self.contacts[indexPath.row];
        
    }

}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.contacts[indexPath.row];
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除好友
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:self.contacts[indexPath.row]];
        if (!error) {
            NSLog(@"删除成功");
            // 刷新界面
            [self getContactsFromServer];
        }
    }
}



@end
