//
//  NewsCommentCell.m
//  TJLike
//
//  Created by MC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "NewsCommentCell.h"
#import "UIImageView+WebCache.h"
#import "AutoAlertView.h"

@implementation NewsCommentCell
{
    NSDateFormatter *formatter;
    UIButton *btn;
    NewsCommentInfo *mlInfo;
}
@synthesize delegate,click;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 100)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        _iconView = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 32, 32)];
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = 16;
        [self.contentView addSubview:_iconView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(62, 10, self.frame.size.width-92, 20);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _goodView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-35, 4, 30, 30)];
        _goodView.image = [UIImage imageNamed:@"zan01.png"];
        [self.contentView addSubview:_goodView];
        
        _goodNum = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160, 10, 120, 20)];
        _goodNum.textAlignment = NSTextAlignmentRight;
        _goodNum.backgroundColor = [UIColor clearColor];
        _goodNum.textColor = [UIColor lightGrayColor];
        _goodNum.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_goodNum];
        
        
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 32, SCREEN_WIDTH-82, 14)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 55, SCREEN_WIDTH-82, 40)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_detailLabel];
        
        _sepeLine= [[UIImageView alloc]initWithFrame:CGRectMake(20, 100-0.5, SCREEN_WIDTH-40, 0.5)];
        _sepeLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_sepeLine];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH-70, 5, 65, 25);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(ReportComment) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        _reportView = [[ReportAndPraiseView alloc]initWithFrame:CGRectMake(btn.frame.origin.x-110, 5, 120, 30)];
        _reportView.delegate = self;
        _reportView.praise = @selector(Praise);
        _reportView.report = @selector(Report);
        _reportView.hidden = YES;
        [self.contentView addSubview:_reportView];
        
        
        
        
        
        
    }
    return self;
}
- (void)Praise{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/AddGood"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",mlInfo.cid] forKey:@"cid"];
  [HttpClient request:dict URL:urlStr success:^(NSDictionary *info) {
        [AutoAlertView ShowMessage:@"赞成功"];
        _goodNum.text=[NSString stringWithFormat:@"%d",[_goodNum.text intValue]+1];
        [self hidenReportVIew];
        
  } fail:^{
      [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
  }];
}
- (void)Report{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/CreateCreport"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",mlInfo.nid] forKey:@"nid"];
    [dict setObject:[NSString stringWithFormat:@"%d",mlInfo.cid] forKey:@"cid"];
    [HttpClient request:dict URL:urlStr success:^(NSDictionary *info) {
        [AutoAlertView ShowMessage:@"举报成功,管理员会对此条评论进行处理"];
        [self hidenReportVIew];
    } fail:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }];
}
- (void)ReportComment{
    if (_reportView.hidden) {
        SafePerformSelector([delegate performSelector:click withObject:self]);
    }
    _reportView.hidden = !_reportView.hidden;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidenReportVIew];
}

- (void)hidenReportVIew
{
    if (!_reportView.hidden) {
        _reportView.hidden = YES;
    }
}
- (void)dealloc{
    mlInfo = nil;
}
-(void)UserNews:(id)sender
{
    SafePerformSelector([delegate performSelector:_showUserNews withObject:self]);
    
}
- (void)LoadContent:(NewsCommentInfo *)list{
    mlInfo = list;
   
    _usid=[NSString stringWithFormat:@"%d",mlInfo.uid] ;
    
    UIImageView *imaView=[[UIImageView alloc]initWithFrame:self.iconView.bounds];
    [imaView  sd_setImageWithURL:[NSURL URLWithString:list.icon] placeholderImage:ImageCache(@"news_list_default") options:SDWebImageLowPriority | SDWebImageRetryFailed];
    [self.iconView addSubview:imaView];
    [self.iconView addTarget:self action:@selector(UserNews:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
  //  [_iconView sd_setImageWithURL:[NSURL URLWithString:list.icon]];
    [_nameLabel setText:list.nickname];
    [_goodNum setText:[NSString stringWithFormat:@"%d",list.number]];
    [_timeLabel setText:list.time];
    //NSDate *date = [formatter dateFromString:list.time];
    [_detailLabel setText:list.content];
}

+ (int)HeightOfContent:(NewsCommentInfo *)list {
    int iHeight = 20;
    NSString *content = list.content;
    if (content) {
        CGSize size = CGSizeMake(SCREEN_WIDTH-40, 300);
        //CGSize calcSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:nil];
        CGRect calcRect = [content boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil];
        CGSize calcSize = calcRect.size;
        iHeight = calcSize.height;
    }
    iHeight += 10;
    
    return iHeight;
}

- (NSDate *)GetStartDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [df stringFromDate:date];
    return [df dateFromString:dateString];
}
- (NSString *)GetFormatDateString:(NSDate *)date {
    NSDate *startdate = [self GetStartDate:[NSDate date]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:date toDate:startdate options:0];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSInteger iOffset = (hour*60+minute)*60+second;
    
    if (year == 0 && month == 0 && day < 2) {
        NSString *title = nil;
        if (day <= 0) {
            if (iOffset <= 0) {
                NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date toDate:[NSDate date] options:0];
                NSInteger hours = [components hour];
                NSInteger minutes = [components minute];
                if (hours == 0) {
                    return [NSString stringWithFormat:@"%d分钟前", (int)minutes];
                }
                else if (hours <= 3) {
                    return [NSString stringWithFormat:@"%d小时前", (int)hours];
                }
                else {
                    title = @"今天";
                }
            }
            else {
                title = @"昨天";
            }
        }
        else if (day == 1) {
            title = @"前天";
        }
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        return [df stringFromDate:date];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM-dd HH:mm";
    //df.dateFormat = @"yyyy-MM-dd";
    return [df stringFromDate:date];
}

- (NSString *)GetFormatDateByInterval:(NSTimeInterval)interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [self GetFormatDateString:date];
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
