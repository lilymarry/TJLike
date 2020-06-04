//
//  TJFloorCommentsViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/23.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFloorCommentsViewController.h"
#import "TJSubCommentModel.h"
#import "TJCommentModel.h"
#import "TJFloorViewCell.h"
//#import "TJSubTextView.h"
#import "TJSubjectViewModel.h"
#import "TJFloorTextView.h"

@interface TJFloorCommentsViewController ()<UITableViewDataSource,UITableViewDelegate,TJFloorTextViewDelegate,TJFloorViewCellDelegate>
{
    TJFloorTextView *textFloorView;
}
@property (nonatomic, strong) TJSubjectViewModel *viewModel;
@property (nonatomic, strong) TJSubCommentModel *subItem;
@property (nonatomic, strong) TJCommentModel    *mainItem;
@property (nonatomic, assign) NSInteger         myFloor;

@property (nonatomic, strong) UITableView       *tableView;

@end

@implementation TJFloorCommentsViewController

- (instancetype)initWIthObjc:(id)mainModel withSubObjc:(id)subModel withFloor:(NSInteger)indexFloor
{
    if (self = [super init]) {
        self.mainItem = (TJCommentModel *)mainModel;
        self.subItem  = (TJSubCommentModel *)subModel;
        self.myFloor  = indexFloor;
        _viewModel = [[TJSubjectViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];

}

- (void)initialNaviBar
{
    [self.naviController setNaviBarTitle:@"更多评论"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"navi_back" imgHighlight:nil withFrame:CGRectMake(0, 0, 50,40)];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
}

- (void)buildUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    textFloorView = [[TJFloorTextView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40 , SCREEN_WIDTH, 40) withisImage:NO];
     textFloorView.myFrame = CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40);
    textFloorView.delegate = self;
   // [textFloorView handleKeyboard];
    [self.view addSubview:textFloorView];
   
  //  textView.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initialNaviBar];
    
   // NSLog(@"AAAA____ %@",self.subItem);
    if(self.subItem){
        [textFloorView callSubCommits:self.subItem.replyidnickname];
    }
    else{
        [textFloorView callMainComments];
    }
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
            return cell.frame.size.height;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strSubCell = @"TJFloorViewCell";
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    TJFloorViewCell *cell = (TJFloorViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TJFloorViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strSubCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell setCellTag:indexPath.row];
        [cell setContentItem:self.contentItem];
        [cell bindModel:self.mainItem andFloor:indexPath.row];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [textFloorView callbackKeyboard];
}

- (void)tapbtnPraise
{
    
}
- (void)tapBtnImages
{
    
}

- (void)sendComments:(NSString *)strComments
{
    if (StringEqual(strComments, @"")) {
        return;
    }
    
    NSString *parentID = nil;
    NSString *replyidID = nil;
    if (!self.subItem) {
        parentID = self.mainItem.cid;
        replyidID = self.mainItem.commentuserid;
    }
    else{
         //  parentID = self.subItem.cid;
          parentID = self.mainItem.cid;
          replyidID = self.subItem.commentuserid;
}
  
    [_viewModel postBBSAddComment:self.mainItem.bid withUserID:UserManager.userInfor.userId  withParent:parentID withReplyid:replyidID withContent:strComments withImage:nil andFinishBlock:^(id result) {
        
        if (textFloorView) {
            [textFloorView callbackKeyboard];
        }
        
        [self.view makeToast:@"评论发表成功" duration:2.0 position:CSToastPositionCenter];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
        
        
        
    } andFaileBlock:^(NSString *error) {
        [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
    }];
    
    
}
//- (void)sendCommentsForUser:(TJSubCommentModel *)model withMesg:(NSString *)strComments
//{
//    if (StringEqual(strComments, @"")) {
//        return;
//    }
//    
//    NSString *parentID = nil;
//    NSString *replyidID = nil;
//    if (!self.subItem) {
//        parentID = self.mainItem.cid;
//        replyidID = self.mainItem.commentuserid;
//    }
//    else{
//        parentID = self.subItem.cid;
//        replyidID = self.subItem.commentuserid;
//    }
//    [_viewModel postBBSAddComment:self.mainItem.bid withUserID:UserManager.userInfor.userId  withParent:model.commentuserid withReplyid:UserManager.userInfor.userId  withContent:strComments withImage:nil andFinishBlock:^(id result) {
//        
//        if (textFloorView) {
//            [textFloorView callbackKeyboard];
//        }
//        
//        [self.view makeToast:@"评论发表成功" duration:2.0 position:CSToastPositionCenter];
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
//        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
//        
//        
//        
//    } andFaileBlock:^(NSString *error) {
//        [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
//    }];
//
//
//
//
//}


- (void)delayMethod
{
    NSObject<CommonDelegate> *tmpDele=self.refreshDelegate;
    [tmpDele refreshingDataList];
    [self.naviController popViewControllerAnimated:YES];
    
    
}


- (void)mainCommentCellEvent
{
    [textFloorView callMainComments];
}
- (void)subCommentCellEvent:(NSString *)str withSubItem:(TJSubCommentModel *)model
{
    [textFloorView callSubCommits:str];
    self.subItem=model;
}
- (void)subCommentCellEvent:(NSString *)str
{
    [textFloorView callSubCommits:str];
}
//- (void)subCommentCellEventWithModel:(TJSubCommentModel *)model
//{
//    [textFloorView callSubCommitsModel:model];
//}

- (void)judgeUserLogin
{
    
}


@end
