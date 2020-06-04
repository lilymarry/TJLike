//
//  TJVillageView.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/24.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJVillageView.h"
#import "TJCityModel.h"

@interface TJVillageView ()<UITableViewDataSource,UITableViewDelegate>
{
    CGRect  myFrame;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *datas;

@end

@implementation TJVillageView

- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray *)dataLists withStytle:(PageStype)stype
{
    if (self = [super init]) {
        self.datas = dataLists;
        myFrame = frame;
        self.pageStype = stype;
        self.frame = CGRectMake(myFrame.origin.x, myFrame.origin.y, myFrame.size.width, 0);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.6;
    }
    return self;
}

- (void)buildTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, myFrame.size.width, myFrame.size.height) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    _tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_tableView];
}


- (void)showVillageView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = NO;
        self.frame = myFrame;
        
    } completion:^(BOOL finished) {
        
        [self buildTableView];
    }];
}
- (void)hideVillageView
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(myFrame.origin.x, myFrame.origin.y, myFrame.size.width, 0);
        
        
    } completion:^(BOOL finished) {
      self.hidden = YES;
      self.datas = nil;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 21;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"strCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
        cell.backgroundColor = [UIColor clearColor];
    }
    TJCityModel *model = (TJCityModel *)[self.datas objectAtIndex:indexPath.row];
    [cell.textLabel setText:model.villageName];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TJCityModel *model = (TJCityModel *)[self.datas objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectRow: andType:)]) {
        [self.delegate didSelectRow:model andType:self.pageStype];
    }
}


@end
