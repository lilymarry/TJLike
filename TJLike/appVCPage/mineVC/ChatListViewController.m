//
//  ChatListViewController.m
//  leanCloudChat
//
//  Created by imac-1 on 16/9/18.
//  Copyright © 2016年 魏艳丽. All rights reserved.
//
#import <CDChatManager.h>
#import "ChatListViewController.h"
#import "ChatRoomViewController.h"
#import "LZStatusView.h"
#import "CDChatManager.h"
#import "CDEmotionUtils.h"
#import "CDConversationStore.h"
#import "CDChatManager_Internal.h"
#import "CDMacros.h"
#import "UIImageView+WebCache.h"
#import "CDMessageHelper.h"
#import <DateTools/DateTools.h>
@interface ChatListViewController ()<CDChatListVCDelegate>
{
    NSMutableArray *dataArray;
    UIButton *but1;
    UIButton *but2;
    BOOL SiXin;
    BOOL xitong;

}
@property (nonatomic, strong) NSMutableArray *conversations;

@end

@implementation ChatListViewController
-(void)selectSiXin
{
    but1.selected=YES;
    but2.selected=NO;
    SiXin=YES;
    xitong=NO;
      [self.tableView reloadData];
}
-(void)selectXiTong
{
    but1.selected=NO;
    but2.selected=YES;
    SiXin=NO;
    xitong=YES;
    [self.tableView reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
     but1.selected=YES;
    but2.selected=NO;
    SiXin=YES;
    xitong=NO;
    self.chatListDelegate = self;
    
    [[CDChatManager manager] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
        
        self.conversations=[NSMutableArray arrayWithArray:conversations];
        [self.tableView reloadData];
        }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 刷新 unread badge 和新增的对话
    [self performSelector:@selector(refresh:) withObject:nil afterDelay:0];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationConnectivityUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationMessageReceived object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationUnreadsUpdated object:nil];
}
- (void)viewController:(UIViewController *)viewController didSelectConv:(AVIMConversation *)conv
{
    ChatRoomViewController * chatRoom = [[ChatRoomViewController alloc]initWithConversation:conv];

     [self presentViewController:chatRoom animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // self.navigationController.tabBarController.tabBar.hidden = NO;
//    [self.naviController setNaviBarTitle:@"我的私信"];
//    [self.naviController setNavigationBarHidden:NO];
//    [self.naviController setNaviBarDefaultLeftBut_Back];
}
-(IBAction)dissChart:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (section==0) {
    //        return 100;
    //    }
    return 45;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,45)];
        headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        @autoreleasepool
        {
            
            but1= [UIButton buttonWithType:UIButtonTypeCustom];
            [but1 setTitleColor:UIColorFromRGB(0x161616) forState:UIControlStateNormal];
            [but1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            but1.frame = CGRectMake(0, 0, SCREEN_WIDTH/2-20, 45);
            but1.tag = 1000;
            but1.selected=SiXin;
            [but1 setTitle:@"我的私信" forState:UIControlStateNormal];
            
            [but1 addTarget:self action:@selector(selectSiXin) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:but1];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-10, 5, 0.5, 35)];
            label.backgroundColor = UIColorFromRGB(0x333333);
            [self.view addSubview:label];
            
            but2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [but2 setTitleColor:UIColorFromRGB(0x161616) forState:UIControlStateNormal];
            [but2 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            but2.frame = CGRectMake(SCREEN_WIDTH/2-10, 0, SCREEN_WIDTH/2-20, 45);
            but2.tag = 1001;
            but2.selected=xitong;
            [but2 setTitle:@"系统消息" forState:UIControlStateNormal];
            [but2 addTarget:self action:@selector(selectXiTong) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:but2];

        }
        
        
        return headView;
 

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (SiXin) {
        return [self.conversations count];

    }
    else
    {
       return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LZConversationCell *cell = [LZConversationCell dequeueOrCreateCellByTableView:tableView];
    AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
    if (conversation.type == CDConversationTypeSingle) {
        NSString *str=conversation.otherId;
        NSArray *keys=[conversation.attributes allKeys];
        NSString *url;
        for (int i=0;i<keys.count;i++)
              {
                  if ( [str isEqualToString:keys[i]]) {
                      url=[conversation.attributes objectForKey:str];
                  }

        }
        
        NSDictionary *dic=conversation.attributes;
       
        NSString *name=[self getUserName:dic[@"roomname"]] ;
        if (name.length==0) {
            name=@"未设置";
        }
       id <CDUserModelDelegate> user = [[CDChatManager manager].userDelegate getUserById:conversation.otherId name:name withUserUrl:url];
        cell.nameLabel.text = user.username;
        
        if ([self.chatListDelegate respondsToSelector:@selector(defaultAvatarImageView)] && user.avatarUrl) {
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[self.chatListDelegate defaultAvatarImageView]];
        } else {
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"avator"]];
        }
    } else {
        [cell.avatarImageView setImage:conversation.icon];
        cell.nameLabel.text = conversation.displayName;
    }
    if (conversation.lastMessage) {
        cell.messageTextLabel.attributedText = [[CDMessageHelper helper] attributedStringWithMessage:conversation.lastMessage conversation:conversation];
      cell.timestampLabel.text = [[NSDate dateWithTimeIntervalSince1970:conversation.lastMessage.sendTimestamp / 1000] timeAgoSinceNow];
    }
    if (conversation.unreadCount > 0) {
        if (conversation.muted) {
            cell.litteBadgeView.hidden = NO;
        } else {
            cell.badgeView.badgeText = [NSString stringWithFormat:@"%@", @(conversation.unreadCount)];
        }
    }
    if ([self.chatListDelegate respondsToSelector:@selector(configureCell:atIndexPath:withConversation:)]) {
        [self.chatListDelegate configureCell:cell atIndexPath:indexPath withConversation:conversation];
    }
    return cell;

}
-(NSString *)getUserName:(NSString*)str
{
    NSString *str1=@"&";
    NSRange range = [str rangeOfString:str1] ;
    if ( range.location != NSNotFound)
    {
        
        NSString *   string1 = [str substringFromIndex:range.length+range.location];
       return  string1;
    }

    return nil;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AVIMConversation *conversation = [self.conversations objectAtIndex:indexPath.row];
//    if ([self.chatListDelegate respondsToSelector:@selector(viewController:didSelectConv:)]) {
//        [self.chatListDelegate viewController:self didSelectConv:conversation];
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LZConversationCell heightOfCell];
}


@end
