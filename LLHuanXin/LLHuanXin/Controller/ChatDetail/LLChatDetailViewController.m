//
//  LLChatDetailViewController.m
//  LLHuanXin
//
//  Created by liushaohua on 2017/1/8.
//  Copyright © 2017年 liushaohua. All rights reserved.
//

#import "LLChatDetailViewController.h"



@interface LLChatDetailViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate>

@property (nonatomic, strong)NSArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LLChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 自定义行高
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    // 接受收到消息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(readMsgFromDB) name:KLLHuanXinDidReciveMsgInfo object:nil];
    
    // 进入聊天界面也要刷新数据
    [self readMsgFromDB];
}

// 从数据库中读取聊天内容
- (void)readMsgFromDB{
    // 获取当前联系人会话
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:self.userName type:EMConversationTypeChat createIfNotExist:YES];
    
    // fromID 传入 nil 则从最新的获取
    [conversation loadMessagesStartFromId:nil count:20 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
     
        self.messages = aMessages;
        [self.tableView reloadData];
    
    
    
    if (self.messages.count > 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
    }
    
}];

}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 构造消息
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:textField.text];
    
    NSString *from = [[EMClient sharedClient] currentUsername];

    //生成Message    Conversation 我和某个人的聊天内容就是一个回话 有一个本地存储 传 nil 传 nil 则会则会存储到和 to 同名的回话中
    EMMessage *message = [[EMMessage alloc] initWithConversationID:nil from:from to:self.userName body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    
    
    // 发送消息
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
       
        if (!error) {
            NSLog(@"消息发送成功");
            // 发送成功也要刷新数据
            [self readMsgFromDB];
        }
    }];
    // 清空消息框
    textField.text = nil;
    
    return  YES;
}

#pragma mark - EMChatManagerDelegate


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMMessage *message = self.messages[indexPath.row];

    UITableViewCell *cell;
    
    switch (message.direction) {
        case EMMessageDirectionReceive:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell" forIndexPath:indexPath];
            
        }
            break;
        case EMMessageDirectionSend:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell" forIndexPath:indexPath];
        }
            break;
    
        default:
            break;
    }
    
    EMMessageBody *msgBody = message.body;
    switch (msgBody.type) {
        case EMMessageBodyTypeText:
        {
            // 收到的文字消息
            EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
            NSString *txt = textBody.text;
            UILabel *label = [cell viewWithTag:1002];
            label.text = txt;
        }
            break;
        case EMMessageBodyTypeImage:
        {
            // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
            NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"大图的secret -- %@"    ,body.secretKey);
            NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
            NSLog(@"大图的下载状态 -- %lu",body.downloadStatus);
            
            
            // 缩略图sdk会自动下载
            NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
            NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
            NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
            NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
            NSLog(@"小图的下载状态 -- %lu",body.thumbnailDownloadStatus);
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
            NSLog(@"纬度-- %f",body.latitude);
            NSLog(@"经度-- %f",body.longitude);
            NSLog(@"地址-- %@",body.address);
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            // 音频sdk会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
            NSLog(@"音频的secret -- %@"        ,body.secretKey);
            NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"音频文件的下载状态 -- %lu"   ,body.downloadStatus);
            NSLog(@"音频的时间长度 -- %lu"      ,body.duration);
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
            
            NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"视频的secret -- %@"        ,body.secretKey);
            NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"视频文件的下载状态 -- %lu"   ,body.downloadStatus);
            NSLog(@"视频的时间长度 -- %lu"      ,body.duration);
            NSLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
            
            // 缩略图sdk会自动下载
            NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
            NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
            NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
            NSLog(@"缩略图的下载状态 -- %lu"      ,body.thumbnailDownloadStatus);
        }
            break;
        case EMMessageBodyTypeFile:
        {
            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
            NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
            NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
            NSLog(@"文件的secret -- %@"        ,body.secretKey);
            NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"文件文件的下载状态 -- %lu"   ,body.downloadStatus);
        }
            break;
            
        default:
            break;
    }

    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
