 //
//  TJSubjectPlacardViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJSubjectPlacardViewController.h"
#import "TJSubjectViewModel.h"
//#import "TJBBSCommendModel.h"
#import "MJRefresh.h"
#import "TJSubjectViewCell.h"
#import "TJSubSubjectViewCell.h"
#import "TJSubTextView.h"
#import "TJSubCommentModel.h"
#import "TJCommentModel.h"
#import "TJFloorCommentsViewController.h"
#import "TJBBSOptionsView.h"
#import <ShareSDK/ShareSDK.h>
#import "TJShowImageView.h"
#import "UIImageView+WebCache.h"
#import "AlertHelper.h"
#import "ImageHelper.h"
#define SHEAR_IMAHE_WIDTH   (320)
#define SHEAR_IMAGE_HEIGHT  (320)

@interface TJSubjectPlacardViewController ()<UITableViewDataSource,UITableViewDelegate,TJSubSubjectViewCellDelegate,UIScrollViewDelegate,TJSubTextViewDelegate,TJBBSOptionsViewDelegate,TJSubjectViewCellDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CommonDelegate>
{
    NSInteger  requestIndex;
  //  TJSubSubjectViewCell *tapCell;
    TJSubTextView *textView;
    TJShowImageView *showImages;
    TJShowImageView *showAllImages;
     BOOL    isSort;
}

@property (nonatomic, strong) NSString           *bbsID;
@property (nonatomic, strong) NSString           *cateId;
@property (nonatomic, strong) TJSubjectViewModel *viewModel;
@property (nonatomic, strong) UITableView        *tableView;

@property (nonatomic, strong) TJBBSContentModel  *contentModel;
@property (nonatomic, strong) NSArray            *comments;
@property (nonatomic, strong) TJBBSOptionsView   *optionsView;
@property (nonatomic, strong) NSString           *commentid;
@property (nonatomic, strong) UIImagePickerController *pickerVC;
@property (nonatomic, strong) UIImage         *editedImage;
@property (nonatomic, strong) NSData          *imageData;

@property (nonatomic, assign) ContentSort     sortStatus;

@end

@implementation TJSubjectPlacardViewController

- (instancetype)initWithItem:(NSString *)cateId{
    self = [super init];
    if (self) {
        _comments = [[NSArray alloc] init];
        self.bbsID = cateId;
        requestIndex = 0;
        _viewModel = [[TJSubjectViewModel alloc] init];
        [self.view setBackgroundColor:COLOR(231, 232, 237, 1)];
        self.hidesBottomBarWhenPushed = YES;
        self.commentid = @"0";
        self.sortStatus = ContentSort_asc;
    }
    return self;
}


- (void)bindViewModel
{
    
    @weakify(self)
    [[RACObserve(_viewModel, bbsContent) filter:^BOOL(id value) {
        return value != nil;
    }] subscribeNext:^(TJBBSContentModel *value) {
        @strongify(self)
        self.contentModel = value;
        [self.tableView reloadData];
        
        [textView refreshGoodNum:self.contentModel.good];

        

        BOOL mode= [self.contentModel.uid isEqualToString:UserManager.userInfor.userId] ;
            if (!self.optionsView) {
            
                _optionsView = [[TJBBSOptionsView alloc] initWithFrame:CGRectMake(0,STATUSBAR_HEIGHT + NAVIBAR_HEIGHT, SCREEN_WIDTH, 0)Withmode:mode];
                _optionsView.delegate = self;
                [self.view addSubview:_optionsView];
            }
           //
        
        
        
    }];
    
    [[RACObserve(_viewModel, commentLists) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.comments = value;
        [self.tableView reloadData];
    }];
}
//- (UIButton *)GetRightBtn{
//    //news_top_4_
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 44, 44);
//    rightBtn.backgroundColor = [UIColor clearColor];
//    [rightBtn setImage:[UIImage imageNamed:@"gengduo.png"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(RightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    return rightBtn;
//}
//- (void)RightBtnClick{}

- (void)initialNaviBar
{
  
    [self.naviController setNaviBarTitle:@"主题帖"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"navi_back" imgHighlight:nil withFrame:CGRectMake(0, 0, 50,40)];
    @weakify(self)
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [textView callbackKeyboard];
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
    
    UIButton *rightBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"gengduo.png" imgHighlight:nil withFrame:CGRectMake(0, 0, 50, 40)];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        //        分享
        if (!self.optionsView.isShow) {
          
            [self.optionsView showOptionView];
        }
        else{
            [self.optionsView hideOptionView];
        }
    }];
     [self.naviController setNaviBarRightBtn:rightBtn];
    
    
    /*
    
    UIButton *rightBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"operation_Icon" imgHighlight:nil withFrame:CGRectMake(0, 0, 15, 25)];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
//        分享
        if (!self.optionsView.isShow) {
            [self.optionsView showOptionView];
        }
        else{
            [self.optionsView hideOptionView];
        }
    }];
    
    UIButton *landBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:nil imgHighlight:nil withFrame:CGRectMake(0, 0, 40, 25)];
    [landBtn setTitle:@"楼主" forState:UIControlStateNormal];
    [landBtn setTitleColor:UIColorFromRGB(0xc72a2a) forState:UIControlStateNormal];
    [landBtn.layer setMasksToBounds:YES];
    [landBtn.layer setBorderColor:UIColorFromRGB(0xc72a2a).CGColor];
    [landBtn.layer setBorderWidth:1.0f];
    [landBtn.layer setCornerRadius:4];

//    [landBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[landBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        只显示楼主接口
        if (StringEqual(self.commentid, @"0")) {
            self.commentid = self.contentModel.uid;
            [landBtn setTitle:@"全部" forState:UIControlStateNormal];
        }
        else{
            self.commentid = @"0";
            [landBtn setTitle:@"楼主" forState:UIControlStateNormal];
        }
        
        [self requestData];
        
        
    }];
    
    UIButton *rightBtnA = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:nil imgHighlight:nil withFrame:CGRectMake(0, 0, 40, 25)];
    [rightBtnA setTitle:@"降序" forState:UIControlStateNormal];
    [rightBtnA setTitleColor:UIColorFromRGB(0xc72a2a) forState:UIControlStateNormal];
    [rightBtnA.layer setMasksToBounds:YES];
    [rightBtnA.layer setBorderColor:UIColorFromRGB(0xc72a2a).CGColor];
    [rightBtnA.layer setBorderWidth:1.0f];
    [rightBtnA.layer setCornerRadius:4];
    
    [[rightBtnA rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (self.sortStatus == ContentSort_desc) {
            self.sortStatus = ContentSort_asc;
            [rightBtnA setTitle:@"升序" forState:UIControlStateNormal];
        }
        else if (self.sortStatus == ContentSort_asc)
        {
            self.sortStatus = ContentSort_desc;
            [rightBtnA setTitle:@"降序" forState:UIControlStateNormal];
        }
        isSort = YES;
        
        NSString *strSort = nil;
        if (self.sortStatus == ContentSort_desc) {
            strSort = @"desc";
        }
        else if (self.sortStatus == ContentSort_asc)
        {
            strSort = @"asc";
        }
        @weakify(self)
        
        [self.viewModel postBBSCommentList:self.bbsID withPage:[NSString stringWithFormat:@"%ld",(long)requestIndex] withCommentid:self.commentid withRank:strSort andFinishBlock:^(NSArray *results) {
            @strongify(self)
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            
        } andFaileBlock:^(NSString *error) {
            @strongify(self)
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        }];
    
        
    }];
    
    [self.naviController setNaviBarRightBtnsWithButtonArray:@[landBtn,rightBtnA]];
     */
}
- (void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView setBackgroundColor:COLOR(231, 232, 237, 1)];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    @weakify(self)
    [_tableView addHeaderWithCallback:^{
        @strongify(self)
        [self requestData];
    }];
    [self.tableView addFooterWithCallback:^{
        @strongify(self)
        self->requestIndex = self->requestIndex + 1;
        [self requestData];
    }];
    textView = [[TJSubTextView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40) withisImage:YES goodNum:self.contentModel.good];
    textView.myFrame =CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    textView.delegate = self;
    //    [textView handleKeyboard];
    [self.view addSubview:textView];
 
    
}
- (void)requestData
{
    @weakify(self)
    [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [_viewModel requestBBsContent:self.bbsID andFinish:^(TJBBSContentModel *result) {
        @strongify(self)
         [AlertHelper hideAllHUDsForView:self.view];
        [self.tableView headerEndRefreshing];
        
        
    } andFailed:^(NSString *error) {
       @strongify(self)
        [AlertHelper hideAllHUDsForView:self.view];
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:_tableView AndDelayHid:1];
       [self.tableView headerEndRefreshing];
    }];
    
     [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [self.viewModel postBBSCommentList:self.bbsID withPage:[NSString stringWithFormat:@"%ld",(long)requestIndex] withCommentid:self.commentid withRank:@"desc" andFinishBlock:^(NSArray *results) {
        @strongify(self)
        [AlertHelper hideAllHUDsForView:self.view];

        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    } andFaileBlock:^(NSString *error) {
        @strongify(self)
        [AlertHelper hideAllHUDsForView:self.view];
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:_tableView AndDelayHid:1];

        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
    
}

- (void)initImagePicker
{
    _pickerVC = [[UIImagePickerController alloc] init];
    _pickerVC.allowsEditing = YES;
    _pickerVC.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindViewModel];
    [self buildUI];
    [self initImagePicker];
    [self.tableView headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  //  [self.tableView headerBeginRefreshing];
    self.tabBarController.tabBar.hidden = YES;
//    [self.naviController setNaviBarRightBtn:[self GetRightBtn]];
    [self initialNaviBar];
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.hidesBottomBarWhenPushed = NO;
    [textView callbackKeyboard];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 1:
            return 12;
            
            break;
            
        default:
            return 0;
            break;
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
    
        case 1:
        {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
            view.backgroundColor = UIColorFromRGB(0xf0f0f0);
            return view;
            
        }
            
            break;
            
        default:
            return nil;
            break;
    }
    
    
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.comments.count;
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
        {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height+10;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"TJSubjectViewCell";
    static NSString *strSubCell = @"strSubCell";
    switch (indexPath.section) {
        case 0:
        {
            TJSubjectViewCell *cell = (TJSubjectViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
            if (!cell) {
                cell = [[TJSubjectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                
            }
            cell.isDelete =_isExistDelete;
            if (self.contentModel) {
                
                [cell bindModel:self.contentModel];
            }
            return cell;
        }
            break;
        case 1:
        {
            NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
            TJSubSubjectViewCell *cell = (TJSubSubjectViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[TJSubSubjectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strSubCell];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                NSInteger row = [indexPath row];
                if (self.comments.count > row) {
                    TJCommentModel *model = (TJCommentModel *)[self.comments objectAtIndex:indexPath.row];
                    [cell setCellTag:indexPath.row];
                    [cell setContentItem:self.contentModel];
                    [cell bindModel:model andFloor:indexPath.row];
                }
                
            }
            
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
    
    if (indexPath.section == 0) {
        if (UserManager.userInfor.userId) {
            [textView callShowKeyboard];
        }
    }
    else
    {
    
    
    }
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (tapCell) {
//        [tapCell hidenReportVIew];
//    }
    if (textView) {
        [textView callbackKeyboard];
    }
    
}

- (void)pressReport:(TJSubSubjectViewCell *)showCell
{
   // [tapCell hidenReportVIew];
  //  tapCell = showCell;
}

- (void)tapbtnPraise
{
     [AlertHelper MBHUDShow:@"提交中..." ForView:self.view AndDelayHid:30];
    [_viewModel postBBSTiBaGood:self.contentModel.bbsId andFinishBlock:^(id result) {
     //    [self.view makeToast:@"点赞成功" duration:2.0 position:CSToastPositionCenter];
        [AlertHelper hideAllHUDsForView:self.view];
        [AlertHelper singleMBHUDShow:@"点赞成功" ForView:self.view AndDelayHid:1];
        [self  requestData];
        [textView refreshGoodNum:self.contentModel.good];

        
    } andFaileBlock:^(NSString *error) {
        // [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
         [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
    }];
}
- (void)tapBtnImages
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请选择照片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机",@"相册",nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 1:
            [self gainPhotoFromCamera];
            break;
        case 2:
            [self gainPhotoFromPhotogallery];
            break;
        case 3:
            
            break;
        default:
            break;
    }
    
}


- (void)sendComments:(NSString *)strComments
{
    if (StringEqual(strComments, @"")) {
        return;
    }
    @weakify(self)
     [AlertHelper MBHUDShow:@"提交中..." ForView:self.view AndDelayHid:30];
    [_viewModel postTopicAddComment:self.contentModel.bbsId withUserID:UserManager.userInfor.userId withParent:@"0" withReplyid:self.contentModel.uid withContent:strComments withImage:self.imageData andFinish:^(NSDictionary *resultDict) {
        [AlertHelper hideAllHUDsForView:self.view];
        @strongify(self)
        if (self->textView) {
            [self->textView callbackKeyboard];
        }
        [self.tableView headerBeginRefreshing];
     //   [self.view makeToast:@"评论发表成功" duration:2.0 position:CSToastPositionCenter];
        [AlertHelper singleMBHUDShow:@"评论发表成功" ForView:self.view AndDelayHid:1];
        
        
    } andFailed:^(NSString *error) {
        @strongify(self)
       [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
    }];
    
    
//    [_viewModel postBBSAddComment:self.contentModel.bbsId withUserID:UserManager.userInfor.userId withParent:@"0" withReplyid:self.contentModel.uid withContent:strComments withImage:nil andFinishBlock:^(id result) {
//        @strongify(self)
//        if (self->textView) {
//            [self->textView callbackKeyboard];
//        }
//        [self.tableView headerBeginRefreshing];
//        [self.view makeToast:@"评论发表成功" duration:2.0 position:CSToastPositionCenter];
//    } andFaileBlock:^(NSString *error) {
//        @strongify(self)
//        [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
//    }];
    
}

- (void)reportCellEvent:(id)model
{
    TJCommentModel  *myItem = (TJCommentModel *)model;
    
    
    [_viewModel postBBSCreport:myItem.bid withCid:myItem.cid andFinishBlock:^(NSArray *results) {
        
        [self.view makeToast:@"举报成功" duration:2.0 position:CSToastPositionCenter];
        
    } andFaileBlock:^(NSString *error) {
        [self.view makeToast:@"举报成功" duration:2.0 position:CSToastPositionCenter];
    }];
//    if (tapCell) {
//        [tapCell hidenReportVIew];
//    }
    
}
- (void)commentCellEvent:(id)model andFloor:(NSInteger)florr
{
    [self pushFloorCommentsVC:model withSubObjc:nil withFloor:florr];
   // TLog(@"%ld",(long)florr);
}
- (void)showFloorVC:(id)model withCommentModel:(id)mainModel andFloor:(NSInteger)florr
{
    TJSubCommentModel *subItem = (TJSubCommentModel *)model;
    TJCommentModel *mainItem = (TJCommentModel *)mainModel;
    [self pushFloorCommentsVC:mainItem withSubObjc:subItem withFloor:florr];
  //  TLog(@"%@ %@",subItem.commentidnickname,mainItem.nickname);
}

- (void)pushFloorCommentsVC:(id)mainModel withSubObjc:(id)subModel withFloor:(NSInteger)indexFloor
{
    TJFloorCommentsViewController *VC = [[TJFloorCommentsViewController alloc] initWIthObjc:mainModel withSubObjc:subModel withFloor:indexFloor];
    VC.refreshDelegate=self;
    VC.contentItem = self.contentModel;
    [self.naviController pushViewController:VC animated:YES];
}

- (void)shareBBSContent
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"奏耐天津"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          nil];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [AlertHelper singleMBHUDShow:@"分享成功" ForView:self.view AndDelayHid:1];
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                      [AlertHelper singleMBHUDShow:@"分享失败" ForView:self.view AndDelayHid:1];
                                }
                            }];

}
- (void)judgeUserLogin
{
    [UserAuthorManager authorizationLogin:self EnterPage:EnterPresentMode_push andSuccess:^{
        
        
    } andFaile:^{
        
    }];

}

- (void)deleteBBsData
{
    @weakify(self)
     [AlertHelper MBHUDShow:@"删除中..." ForView:self.view AndDelayHid:30];
    [_viewModel postDeleteBBs:self.contentModel.bbsId withUserId:self.contentModel.uid andFinishBlock:^(id result) {
        @strongify(self)
       // NSLog(@"XXAXX %@",result);
         [AlertHelper hideAllHUDsForView:self.view ];
      //  [self.view makeToast:@"删除成功" duration:2.0 position:CSToastPositionCenter];
        [AlertHelper singleMBHUDShow:@"删除成功" ForView:self.view  AndDelayHid:1];
        [self.naviController popViewControllerAnimated:YES];
        
    } andFaileBlock:^(NSString *error) {
        @strongify(self)
      //  [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
         [AlertHelper hideAllHUDsForView:self.view];
            [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:_tableView AndDelayHid:1];
    }];
}


- (void)showAllImages:(NSArray *)images
{
    if (showImages) {
        showImages = nil;
    }
    showImages = [[TJShowImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withImages:images];
    [SHARE_WINDOW addSubview:showImages];
    @weakify(self)
    showImages.tapHideBlock = ^{
        @strongify(self)
        self->showImages = nil;
    };
    
}

- (void)showSubAllImages:(NSArray *)images
{
    if (showAllImages) {
        showAllImages = nil;
    }
    showAllImages = [[TJShowImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withImages:images];
    [SHARE_WINDOW addSubview:showAllImages];
    @weakify(self)
    showAllImages.tapHideBlock = ^{
        @strongify(self)
        self->showAllImages = nil;
    };
}

-(void)searchLouZhu
{
   
    if (StringEqual(self.commentid, @"0")) {
        self.commentid = self.contentModel.uid;
     
    }
    else{
        self.commentid = @"0";
    }
    
    [self requestData];


}

-(void)replycontent
{
    if (self.sortStatus == ContentSort_desc) {
        self.sortStatus = ContentSort_asc;
     
    }
    else if (self.sortStatus == ContentSort_asc)
    {
        self.sortStatus = ContentSort_desc;
        
    }
    isSort = YES;
    
    NSString *strSort = nil;
    if (self.sortStatus == ContentSort_desc) {
        strSort = @"desc";
    }
    else if (self.sortStatus == ContentSort_asc)
    {
        strSort = @"asc";
    }
    @weakify(self)
    
     [AlertHelper MBHUDShow:@"加载中..." ForView:self.view AndDelayHid:30];
    [self.viewModel postBBSCommentList:self.bbsID withPage:[NSString stringWithFormat:@"%ld",(long)requestIndex] withCommentid:self.commentid withRank:strSort andFinishBlock:^(NSArray *results) {
        @strongify(self)
        [AlertHelper hideAllHUDsForView:self.view];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    } andFaileBlock:^(NSString *error) {
        @strongify(self)
        [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];


}

-(void)delectContent
{
    [self deleteBBsData];
    
    
}


- (void)reportBBSContent
{

    [_viewModel postBBSCreport:self.contentModel.uid withCid:self.contentModel.cid andFinishBlock:^(NSArray *results) {
        
        [self.view makeToast:@"举报成功" duration:2.0 position:CSToastPositionCenter];
        
    } andFaileBlock:^(NSString *error) {
        [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
    }];
 
    
}
- (void)refreshBBSContent
{
     [self  requestData];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
    self.viewModel = nil;
    
   // NSLog(@"dealloc");
}

- (void)gainPhotoFromPhotogallery
{
    _pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_pickerVC animated:YES completion:^{
        
    }];
}

- (void)gainPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerVC.mediaTypes = @[@"public.image"];
        
        [self presentViewController:_pickerVC animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"设备不支持相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
}
- (UIImage *)imageTelescopicToSize:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    
    [self.editedImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
- (NSData *)imageTransformData:(UIImage *)image
{
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    }
    else{
        data = UIImagePNGRepresentation(image);
    }
    
    return data;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if([type isEqualToString:@"public.image"]){
        UIImage *image = nil;
        
        if (_pickerVC.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            
        }
        else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
     //   self.editedImage = image;
        
      //  self.editedImage = [self imageTelescopicToSize:CGSizeMake(SHEAR_IMAHE_WIDTH, SHEAR_IMAGE_HEIGHT)];
        self.editedImage=[ImageHelper imageScaleWithImage:image];
    }
    
 
    [_pickerVC dismissViewControllerAnimated:YES completion:^{
     
     [textView dissPlayImag];
       self.imageData = [self imageTransformData:self.editedImage];
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setIsExistDelete:(BOOL)isExistDelete
{
    _isExistDelete = isExistDelete;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
    
}
-(void)refreshingDataList
{
    [self.tableView headerBeginRefreshing];

}
@end
