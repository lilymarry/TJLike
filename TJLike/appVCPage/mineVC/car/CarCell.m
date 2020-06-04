//
//  CarCell.m
//  TJLike
//
//  Created by MC on 15/4/18.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "CarCell.h"
#import "JSONKit.h"

@interface CarCell ()<NSURLConnectionDownloadDelegate>
{
}


@end

@implementation CarCell
{
    UILabel *nameLabel;
    UILabel *wLabel;
    UILabel *nLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 70)];
        mView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:mView];
        
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 44, 44)];
        icon.image = [UIImage imageNamed:@"carname.png"];
        [mView addSubview:icon];
        
        icon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-35, 20, 28, 28)];
        icon.image = [UIImage imageNamed:@"set.png"];
        [mView addSubview:icon];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 13, 200, 20)];
        nameLabel.textColor = UIColorFromRGB(0x333333);
        nameLabel.font = [UIFont systemFontOfSize:18];
        nameLabel.backgroundColor = [UIColor clearColor];
        [mView addSubview:nameLabel];
        
        wLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 43, 200, 20)];
        wLabel.textColor = [UIColor redColor];
        wLabel.font = [UIFont systemFontOfSize:18];
        wLabel.text = @"未处理违章次数: 0";
        
        
        [mView addSubview:wLabel];
        
//        nLabel = [[UILabel alloc]initWithFrame:CGRectMake(mView.bounds.size.width-100, 0, 50, 70)];
//        nLabel.backgroundColor = [UIColor clearColor];
//        nLabel.textColor = [UIColor blackColor];
//        nLabel.font = [UIFont systemFontOfSize:30];
//        nLabel.text = @"0";
//        nLabel.textAlignment = NSTextAlignmentRight;
//        [mView addSubview:nLabel];
        
        
    }
    return self;
}
- (void)LoadContent:(TJFoundCarModel *)model{
    nameLabel.text =  [NSString stringWithFormat:@"%@：%@",model.name,model.num];
    
    NSString *postUrl = @"http://www.tjits.cn/wfcx/vehiclelist____aacccccccccc.asp";
    NSString *city = @"津";
    NSString *type = model.model;
    NSString *vehicleNo = model.num;
    NSLog(@"%@  %@  %@",city,type,vehicleNo);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postUrl]];
    [request addValue:@"http://www.tjits.cn/wfcx/index.asp" forHTTPHeaderField:@"Referer"];

    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *strPost = [NSString stringWithFormat:@"provice=%@&lei=%@&txtVehicleNo=%@",city,type,vehicleNo];
    NSData *postData = [strPost dataUsingEncoding:encoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    request.timeoutInterval=20;
    [request setHTTPBody:postData];
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"sendAsynchronousRequest");
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
//        NSLog(@"%@",retStr);
        
        NSString *regexString = @"red>(\\d.*?)</font>";
//        NSArray *matchArray = NULL;
//        matchArray = [retStr componentsSeparatedByString:<#(NSString *)#>:regexString];
        NSRange range = [retStr rangeOfString:regexString options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            NSString *strResult = [retStr substringWithRange:range];
            strResult = [[strResult componentsSeparatedByString:@">"] objectAtIndex:1];
            strResult = [[strResult componentsSeparatedByString:@"<"] firstObject];
            NSLog(@"%@",strResult);
            NSString *str = [NSString stringWithFormat:@"未处理违章次数: %@",strResult];
          //  wLabel.text = [NSString stringWithFormat:@"未处理违章次数%@次",strResult];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
            
            
            UIColor *color = UIColorFromRGB(0x333333);
            [attrString addAttribute:NSForegroundColorAttributeName
                               value:color
                               range:[str rangeOfString:@"未处理违章次数: "]];
            
            [wLabel setAttributedText:attrString];
           // [attrString addAttribute:NSForegroundColorAttributeName
                             //  value:color
                            //   range:[wLabel.text rangeOfString:@"次"]];
            
           // [wLabel setAttributedText:attrString];
            

            
            nLabel.text = [NSString stringWithFormat:@"%@",strResult];
            
            
        }
        
    }];
    
    
}
- (void)awakeFromNib {
    // Initialization code
      [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
//    NSArray *keys = [dictionary allKeys];
//    NSMutableString *reString = [NSMutableString string];
//    [reString appendString:@"    {"];
//    NSMutableArray *keyValues = [NSMutableArray array];
//    for (int i=0; i<[keys count]; i++) {
//        NSString *name = [keys objectAtIndex:i];
//        id valueObj = [dictionary objectForKey:name];
//        NSString *value = [NSString jsonStringWithObject:valueObj];
//        if (value) {
//            [keyValues addObject:[NSString stringWithFormat:@""%@":%@",name,value]];
//        }
//    }
//    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
//    [reString appendString:@"}"];
//    return reString;
//}

@end
