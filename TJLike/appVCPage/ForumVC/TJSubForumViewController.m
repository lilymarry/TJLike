//
//  TJSubForumViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJSubForumViewController.h"
#import "TJSendTopicalViewController.h"
#import "TJTopicHeadViewCell.h"
#import "TJTopNoticeViewCell.h"
#import "TJTieBaContentViewCell.h"
#import "TJNoticeViewController.h"
#import "TJSubjectPlacardViewController.h"
#import "AlertHelper.h"
#import "TJUserInfoEditViewController.h"
#import "MJRefresh.h"
#import "TJTopicViewModel.h"
#import "TJGongGaoCell.h"
#import "UIImageView+WebCache.h"
#import "TJUserNewsViewController.h"
#import <CDChatManager.h>
@interface TJSubForumViewController ()<UITableViewDataSource,UITableViewDelegate,TopicHeadNoticeDelegate,TJTieBaContentViewCellDelegate,CommonDelegate>
{
    int     requestInt;

}

@property (nonatomic, strong) TJBBSCateSubModel *sForumItem;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIButton          *btnRefresh;
@property (nonatomic, strong) TJTopicViewModel  *viewModel;

@property (nonatomic, strong) NSArray           *topNoticLists;
@property (nonatomic, strong) NSArray           *tieContentLists;

//@property (nonatomic, assign) ContentSort     sortStatus;

@end

@implementation TJSubForumViewController

- (instancetype)initWithItem:(TJBBSCateSubModel*)item
{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:COLOR(231, 232, 237, 1)];
        _sForumItem = [[TJBBSCateSubModel alloc] init];
        self.sForumItem = item;
        self.hidesBottomBarWhenPushed = YES;
        _viewModel = [[TJTopicViewModel alloc] init];
        [self bindViewModel];
        requestInt = 0;
    }
    return self;
}

- (void)bindViewModel
{
    _topNoticLists = [[NSArray alloc] init];
    _tieContentLists = [[NSArray alloc] init];
    @weakify(self)
    [[RACObserve(_viewModel, topLists) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.topNoticLists = value;
        [self.tableView reloadData];
    }];
    
    [[RACObserve(_viewModel, contentLists) filter:^BOOL(NSArray *value) {
        @strongify(self)
        self.tableView.scrollEnabled = NO;
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.tableView.scrollEnabled = YES;
        self.tieContentLists = value;
        [self.tableView reloadData];
    }];
}


- (void)initialNaviBar
{
    [self.naviController setNaviBarTitle:self.sForumItem.name];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"navi_back" imgHighlight:nil withFrame:CGRectMake(0, 0, 40,40)];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
    UIButton *rightBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"fatie_" imgHighlight:nil withFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    
        
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            
            TJSendTopicalViewController *sendVC = [[TJSendTopicalViewController alloc] initWithItem:_sForumItem];
            sendVC.refreshDelegate=self;
            [self.naviController pushViewController:sendVC animated:YES];
            
        } andFaile:^{
            
        }];
        
       
        
    }];
    
//    UIButton *rightBtnA = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:nil imgHighlight:nil withFrame:CGRectMake(0, 0, 40, 25)];
//    [rightBtnA setTitle:@"降序" forState:UIControlStateNormal];
//    [rightBtnA setTitleColor:COLOR(32, 141, 230, 1) forState:UIControlStateNormal];
//    [rightBtnA.layer setMasksToBounds:YES];
//    [rightBtnA.layer setBorderColor:COLOR(32, 141, 230, 1).CGColor];
//    [rightBtnA.layer setBorderWidth:1.0f];
//    [rightBtnA.layer setCornerRadius:4];
    
//    [[rightBtnA rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        
//        if (self.sortStatus == ContentSort_desc) {
//            self.sortStatus = ContentSort_asc;
//            [rightBtnA setTitle:@"升序" forState:UIControlStateNormal];
//        }
//        else if (self.sortStatus == ContentSort_asc)
//        {
//            self.sortStatus = ContentSort_desc;
//            [rightBtnA setTitle:@"降序" forState:UIControlStateNormal];
//        }
//        isSort = YES;
//        
//        NSString *strSort = nil;
//        if (self.sortStatus == ContentSort_desc) {
//            strSort = @"desc";
//        }
//        else if (self.sortStatus == ContentSort_asc)
//        {
//            strSort = @"asc";
//        }
//        @weakify(self)
//        [_viewModel postTopicBBSTieBaContent:_sForumItem.subID withPageIndex:requestInt withRank:strSort andFinishBlock:^(NSArray *results) {
//            @strongify(self)
//            [self.tableView headerEndRefreshing];
//            [self.tableView footerEndRefreshing];
//        } andFaileBlock:^(NSString *error) {
//            @strongify(self)
//            [self.tableView headerEndRefreshing];
//            [self.tableView footerEndRefreshing];
//        }];
//        
//    }];
    
    
    [self.naviController setNaviBarRightBtn:rightBtn];
//    [self.naviController setNaviBarRightBtnsWithButtonArray:@[rightBtn,rightBtnA]];
    
}

- (void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:COLOR(231, 232, 237, 1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    @weakify(self)
    [_tableView addHeaderWithCallback:^{
        @strongify(self)
        [self requestData];
    }];
    [self.tableView addFooterWithCallback:^{
        @strongify(self)
        self->requestInt = self->requestInt + 1;
        [self requestTieZiContent];
    }];
    
    
   UIImage *image = [UIImage imageNamed:@"刷新 2.png"];
    _btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRefresh setImage:[UIImage imageNamed:@"刷新 2.png"] forState:UIControlStateNormal];
    [[_btnRefresh rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self requestTieZiContent];
    }];
    [_btnRefresh setFrame:CGRectMake(SCREEN_WIDTH - image.size.width/2 - 20, SCREEN_HEIGHT - TABBAR_HEIGHT  - image.size.height/2,image.size.width/2, image.size.height/2)];
    [self.view addSubview:_btnRefresh];
    
    
}

- (void)requestTieZiContent
{
    @weakify(self)
    [_viewModel postTopicBBSTieBaContent:_sForumItem.subID withPageIndex:requestInt withRank:@"desc" andFinishBlock:^(NSArray *results) {
        @strongify(self)
         [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } andFaileBlock:^(NSString *error) {
        @strongify(self)
         [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}


- (void)requestData
{
     @weakify(self)
    [_viewModel postTopicBBSTopTieBa:_sForumItem.subID andFinishBlock:^(NSArray *results) {
        @strongify(self)
        [self.tableView headerEndRefreshing];
    } andFaileBlock:^(NSString *error) {
        @strongify(self)
        [self.tableView headerEndRefreshing];
    }];
    
    [self requestTieZiContent];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
     [_tableView headerBeginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initialNaviBar];
 
     self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return self.topNoticLists.count;
            break;
        case 3:
            return self.tieContentLists.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 91;
            break;
        case 1:
            return 61;
            break;
        case 2:
            return 40;
            break;
        case 3:
        {
            
            TJTieBaContentViewCell *cell = (TJTieBaContentViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight+10;
        }
            
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"TJTopicHeadViewCell";
    static NSString *strTopCell = @"TJTopNoticeViewCell";
   static NSString *gongCell = @"TJGongGaoCell";
    switch (indexPath.section) {
        case 0:
        {
                NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
                TJTopicHeadViewCell *cell = (TJTopicHeadViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:strCell owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                    [cell bindModel:_sForumItem];
                }
                return cell;
          
        }
            break;
        case 1:
        {
            NSString *cellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
            TJGongGaoCell *cell = (TJGongGaoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:gongCell owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
         
            }
            return cell;
            
        }
            break;
            
        case 2:
        {
            TJTopNoticeViewCell *cell = (TJTopNoticeViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:strTopCell owner:self options:nil] lastObject];
            }
            
            TJBBSTopTieBaModel *modle = (TJBBSTopTieBaModel *)[_topNoticLists objectAtIndex:indexPath.row];
            [cell bindModel:modle];

            return cell;
        }
            break;
        case 3:
        {
            NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld_%ld",(long)indexPath.section,(long)indexPath.row];
                TJTieBaContentViewCell *cell = [[TJTieBaContentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                TJTieBaContentModel *model = (TJTieBaContentModel *)[_tieContentLists objectAtIndex:indexPath.row];
                cell.delegate=self;
                [cell bindModel:model];

            return cell;

        }
            break;
        default:
            return nil;
            break;
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
        TJNoticeViewController *noticeVC = [[TJNoticeViewController alloc] initWIthID:_sForumItem.subID];
        [self.naviController pushViewController:noticeVC animated:YES];

        
        
    }

    if (indexPath.section == 2) {
   

        TJBBSTopTieBaModel *topModel = (TJBBSTopTieBaModel *)[_topNoticLists objectAtIndex:indexPath.row];
        TJSubjectPlacardViewController *spVC = [[TJSubjectPlacardViewController alloc] initWithItem:topModel.topID];
        spVC.isExistDelete = YES;
        [self.naviController pushViewController:spVC animated:YES];
    }
    else if (indexPath.section == 3)
    {
        TJTieBaContentModel *model = (TJTieBaContentModel *)[_tieContentLists objectAtIndex:indexPath.row];
        TJSubjectPlacardViewController *spVC = [[TJSubjectPlacardViewController alloc] initWithItem:model.tbId];
        spVC.isExistDelete = YES;
        [self.naviController pushViewController:spVC animated:YES];
    }
}

- (void)showUserNews:(id)model
{
    if ([UserAuthorManager gainCurrentStateForUserLoginAndBind]==0){
        [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
            NSLog(@"成功");
          
        }andFaile:^{
            NSLog(@"失败");
        }];
    }else{
        //登录
         TJTieBaContentModel *mod = (TJTieBaContentModel *)model;
        NSString *idstr=[NSString stringWithFormat:@"ID#%@",UserManager.userInfor.userId ];
        [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
        [[CDChatManager manager] openWithClientId:idstr  callback:^(BOOL succeeded, NSError *error) {
            [AlertHelper hideAllHUDsForView:self.view];
              if (succeeded) {
            TJUserNewsViewController *user=[[TJUserNewsViewController alloc]init];
            user.uid=mod.uid;
            [self.naviController pushViewController:user animated:YES];
              }
              else
              {
                  [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
                  
              }

        }];
        
    }
  
}

- (void)tapBoticeEvent:(NSString *)strid
{
    TJNoticeViewController *noticeVC = [[TJNoticeViewController alloc] initWIthID:strid];
    [self.naviController pushViewController:noticeVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
    
}
-(void)refreshingDataList
{
   [_tableView headerBeginRefreshing];

}
@end
