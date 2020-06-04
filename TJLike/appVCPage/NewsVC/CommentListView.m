//
//  CommentListView.m
//  TJLike
//
//  Created by MC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "CommentListView.h"
#import "NewsCommentInfo.h"
#import "NewsCommentCell.h"
#import "NewsCommentTitleCell.h"

@interface CommentListView ()
{
    UITableView *_theTable;
    NSMutableArray *hotArray;
    NSMutableArray *simpleArray;
    NewsCommentCell *tapCell;
    NSString *mNid;
    NSString *strAlter;
    UILabel *subLabel ;
}
@end

@implementation CommentListView
- (id)initWithFrame:(CGRect)frame WithNid:(id) nid{
    self = [super initWithFrame:frame];
    if (self) {
        mNid = nid;
        hotArray = [[NSMutableArray alloc]init];
        simpleArray = [[NSMutableArray alloc]init];
        
        _theTable = [[UITableView alloc]initWithFrame:self.bounds];
        _theTable.delegate = self;
        _theTable.dataSource = self;
        _theTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _theTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _theTable.backgroundColor = COLOR(240, 240, 240, 1);
        
        [self addSubview:_theTable];
        
        [self GetData];
    }
    return self;
}
- (void)GetData{
    [hotArray removeAllObjects];
    [simpleArray removeAllObjects];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/ArticleCommentList"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:mNid forKey:@"nid"];
  [HttpClient request:dict URL:urlStr success:^(NSDictionary *info) {
        NSLog(@"评论----------------------%@",info);
        NSDictionary *data = info[@"data"];
        NSArray *hot = data[@"hot"];
        for (int i = 0; i<hot.count; i++) {
            NewsCommentInfo *info = [NewsCommentInfo CreateWithDict:hot[i]];
            [hotArray addObject:info];
        }
        NSArray *simple = data[@"simple"];
        for (int i = 0; i<simple.count; i++) {
            NewsCommentInfo *info = [NewsCommentInfo CreateWithDict:simple[i]];
            [simpleArray addObject:info];
        }
        self.commentBottomView.comment = (int)(hotArray.count + simpleArray.count);
        _theTable.tableHeaderView = [self GetHeaderView];
        [_theTable reloadData];
        
  } fail:^{
      [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
  }];

}

- (UIView *)GetHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, 67)];
    title.backgroundColor = [UIColor clearColor];
    title.text = self.mlTitle;
    title.numberOfLines = 2;
    title.font = [UIFont systemFontOfSize:20];
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentLeft;
    [view addSubview:title];
    
    subLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 67, SCREEN_WIDTH-24, 18)];
    subLabel.backgroundColor = [UIColor clearColor];
    
    subLabel.font = [UIFont systemFontOfSize:10];
    subLabel.textColor = [UIColor grayColor];
    subLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:subLabel];
    
    return view;
}

#pragma mark -tabview dalegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return hotArray.count+1;
    }else {
        return simpleArray.count+1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        static NSString *CellIdentifier = @"CellIdentifierTitle";
        NewsCommentTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NewsCommentTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        NSString * title = nil;
        if (indexPath.section==0) {
            title = [NSString stringWithFormat:@"热门评论(%d)",(int)hotArray.count];
        }
        else{
            title = [NSString stringWithFormat:@"最新评论(%d)",(int)simpleArray.count];
        }
        [cell LoadText:title];
        return cell;
    }else{
        static NSString *CellIdentifier = @"CellIdentifierSimple";
        NewsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NewsCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.delegate = self;
            cell.click = @selector(pressReport:);
            cell.showUserNews=@selector(showUserNews:);
            
        }
        if (indexPath.section==0) {
            NewsCommentInfo *info = [hotArray objectAtIndex:indexPath.row-1];
            
            [cell LoadContent:info];
        
            cell.sepeLine.hidden = (indexPath.row == hotArray.count);
        }
        else if (indexPath.section == 1){
            NewsCommentInfo *info = [simpleArray objectAtIndex:indexPath.row-1];
            [cell LoadContent:info];
            cell.sepeLine.hidden = (indexPath.row == simpleArray.count);
        }
        
        return cell;
    }
}
-(void)showUserNews:(NewsCommentCell *)showCell
{
    NSLog(@"AAA___ %@",showCell.usid);
    [self.delegate showUserNewsView:showCell.usid];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (tapCell) {
        [tapCell hidenReportVIew];
    }
}

- (void)pressReport:(NewsCommentCell *)showCell
{
    [tapCell hidenReportVIew];
    tapCell = showCell;
    
}

- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
   
    strAlter =[NSString stringWithFormat:@"%@ %@ %d评论",self.dataDict[@"source"],self.dataDict[@"pubtime"],(int)(hotArray.count + simpleArray.count)];
     subLabel.text = strAlter;
     NSLog(@"%@ ",strAlter);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
