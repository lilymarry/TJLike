//
//  TJVillageView.h
//  TJLike
//
//  Created by IPTV_MAC on 15/4/24.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PageStype){
    Village_ViewStype_City,
    Village_ViewStype_street,
    Village_ViewStype_community
    
    
};


@protocol TJVillageViewDelegate <NSObject>

- (void)didSelectRow:(id)modelObjc andType:(PageStype)type;

@end

@interface TJVillageView : UIView

@property (nonatomic, weak) id<TJVillageViewDelegate> delegate;
@property (nonatomic, assign) PageStype  pageStype;

- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray *)dataLists withStytle:(PageStype)stype;

- (void)showVillageView;
- (void)hideVillageView;

@end
