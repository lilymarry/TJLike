//
//  NewsBannerCell.m
//  TJLike
//
//  Created by MC on 15-3-30.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsBannerCell.h"
#import "BannerView.h"
#import "NewsBannerInfo.h"
#import "TJNewsNormalDetailController.h"
#import "TjNewsZTListViewController.h"
#import "TJNewsImageDetailController.h"

@implementation NewsBannerCell{
    GCPagingView *pageView;
    NSMutableArray *bannerArray;
}

- (void)dealloc{
    [pageView stopAutoScroll];
    pageView = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        bannerArray = [[NSMutableArray alloc]init];
        pageView = [[GCPagingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 165)];
        pageView.delegate = self;
        [self.contentView addSubview:pageView];
    }
    return self;
}
- (void)LoadContent:(NSMutableArray *)mArray{
    bannerArray = mArray;
    [pageView reloadData];
}
#pragma -mark GCPagingViewDelegate
- (NSInteger)numberOfPagesInPagingView:(GCPagingView*)pagingView{
    return bannerArray.count;
}
- (UIView*)GCPagingView:(GCPagingView*)pagingView viewAtIndex:(NSInteger)index{
    
    BannerView *view = (BannerView *)[pagingView dequeueReusablePage];
    if (view == nil) {
        view = [[BannerView alloc] initWithFrame:pagingView.bounds];
        view.delegate = self;
        view.OnClick = @selector(OnBannerClick:);
    }
    NewsBannerInfo *info = [bannerArray objectAtIndex:index];
    [view LoadContent:info];
    return view;
}
- (void)OnBannerClick:(BannerView *)sender{
    NewsBannerInfo *info = sender.mInfo;
//    if ([sender.mInfo.property isEqualToString:@"专题"]) {
//        TjNewsBannerZTViewController *ctrl = [[TjNewsBannerZTViewController alloc]init];
//        ctrl.nid = info.ztid;
//        ctrl.hidesBottomBarWhenPushed = YES;
//        [self.mRootCtrl.naviController pushViewController:ctrl animated:YES];
//    }
//    else if ([sender.mInfo.property isEqualToString:@"图文"]){
//        
//    }
//    else {
//        NewsRelationDetailViewController *ctrl = [[NewsRelationDetailViewController alloc]init];
//        ctrl.nid =[NSString stringWithFormat:@"%d",info.nid];
//        ctrl.hidesBottomBarWhenPushed = YES;
//        [self.mRootCtrl.naviController pushViewController:ctrl animated:YES];
//    }
    if ([info.property isEqualToString:@"图文"]) {
        TJNewsImageDetailController *Ctrl = [[TJNewsImageDetailController alloc]init];
        Ctrl.nid = [NSString stringWithFormat:@"%d",info.ztid];
        Ctrl.tuwen = info.tuwen;
        Ctrl.mlbTitle = info.title;//评论页里的title
        Ctrl.hidesBottomBarWhenPushed = YES;
        [self.mRootCtrl.naviController pushViewController:Ctrl animated:YES];
    }else if([info.property isEqualToString:@"专题"]) {
        TjNewsZTListViewController *Ctrl = [[TjNewsZTListViewController alloc]init];
        Ctrl.ztid = [NSString stringWithFormat:@"%d",info.ztid];
        Ctrl.hidesBottomBarWhenPushed = YES;
        [self.mRootCtrl.naviController pushViewController:Ctrl animated:YES];
    }
    else{
        TJNewsNormalDetailController *Ctrl = [[TJNewsNormalDetailController alloc]init];
        Ctrl.nid = [NSString stringWithFormat:@"%d",info.nid];
        Ctrl.mlbTitle = info.title;//评论页里的title
        Ctrl.hidesBottomBarWhenPushed = YES;
        [self.mRootCtrl.naviController pushViewController:Ctrl animated:YES];
    }
}

- (void)awakeFromNib {
    // Initialization code
      [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
