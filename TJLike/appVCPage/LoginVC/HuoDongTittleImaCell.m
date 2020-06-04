//
//  HuoDongTittleImaCell.m
//  TJLike
//
//  Created by imac-1 on 2016/10/19.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "HuoDongTittleImaCell.h"
#import "HuoDongModel.h"
#import "HuoDongTittleImaView.h"
#import "HuoDongDetailViewController.h"
@implementation HuoDongTittleImaCell{
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
    
    HuoDongTittleImaView *view = (HuoDongTittleImaView *)[pagingView dequeueReusablePage];
    if (view == nil) {
        view = [[HuoDongTittleImaView alloc] initWithFrame:pagingView.bounds];
        view.delegate = self;
        view.OnClick = @selector(OnBannerClick:);
    }
    HuoDongModel *info = [bannerArray objectAtIndex:index];
    [view LoadContent:info];
    return view;
}
//子视图 获取父视图控制器
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)OnBannerClick:(HuoDongTittleImaView *)sender{
     HuoDongModel *info = sender.mInfo;
    HuoDongDetailViewController *detail=[[HuoDongDetailViewController alloc]init];
    detail.fuliId=info.FuliId;
    detail.urlStr=@"HdView";
    detail.state=@"1";//
    detail.hidesBottomBarWhenPushed = YES;
   [[self viewController].navigationController pushViewController:detail animated:YES];    //    if ([sender.mInfo.property isEqualToString:@"专题"]) {
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
    //    if ([info.property isEqualToString:@"图文"]) {
    //        TJNewsImageDetailController *Ctrl = [[TJNewsImageDetailController alloc]init];
    //        Ctrl.nid = [NSString stringWithFormat:@"%d",info.ztid];
    //        Ctrl.tuwen = info.tuwen;
    //        Ctrl.mlbTitle = info.title;//评论页里的title
    //        Ctrl.hidesBottomBarWhenPushed = YES;
    //        [self.mRootCtrl.naviController pushViewController:Ctrl animated:YES];
    //    }else if([info.property isEqualToString:@"专题"]) {
    //        TjNewsZTListViewController *Ctrl = [[TjNewsZTListViewController alloc]init];
    //        Ctrl.ztid = [NSString stringWithFormat:@"%d",info.ztid];
    //        Ctrl.hidesBottomBarWhenPushed = YES;
    //        [self.mRootCtrl.naviController pushViewController:Ctrl animated:YES];
    //    }
    //    else{
    //        TJNewsNormalDetailController *Ctrl = [[TJNewsNormalDetailController alloc]init];
    //        Ctrl.nid = [NSString stringWithFormat:@"%d",info.nid];
    //        Ctrl.mlbTitle = info.title;//评论页里的title
    //        Ctrl.hidesBottomBarWhenPushed = YES;
    //        [self.mRootCtrl.naviController pushViewController:Ctrl animated:YES];
    //    }
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
