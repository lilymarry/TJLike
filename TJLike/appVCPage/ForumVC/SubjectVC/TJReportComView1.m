//
//  TJReportComView1.m
//  TJLike
//
//  Created by 123 on 16/9/3.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJReportComView1.h"
@interface TJReportComView1()
//{
//    CGFloat  rWidth;
//    CGRect  rBFrame;
//    CGFloat  originRY;
//}
@property (nonatomic, weak) IBOutlet UIButton *btnReport;
@property (nonatomic, weak) IBOutlet UIButton *btnCommrnt;

//@property (nonatomic, weak) IBOutlet UIImageView *rImageView;
@property (nonatomic, weak) IBOutlet UIImageView *cImageView;
//@property (nonatomic, weak) IBOutlet UILabel     *lblRrport;
//@property (nonatomic, weak) IBOutlet UILabel     *lblComment;
//@property (nonatomic, weak) IBOutlet UIView      *rView;
//@property (nonatomic, weak) IBOutlet UIView      *cView;

@end
@implementation TJReportComView1

+ (instancetype)instalReportView
{
    
    TJReportComView1 *view = [[[NSBundle mainBundle] loadNibNamed:@"TJReportComView1" owner:self options:nil] lastObject];
    //  [view setFrame:CGRectMake(SCREEN_WIDTH-50, 5, 40, view.frame.size.height)];
    return view;
}

- (void)showReportView
{
   // [UIView animateWithDuration:0.3 animations:^{
        
        self.hidden = NO;
        [self setFrame:CGRectMake(SCREEN_WIDTH-127, 5, 117, 44)];
     //   self.frame =CGRectMake(SCREEN_WIDTH - self.frame.origin.x - self.frame.size.width + (IS_IPHONE5?0:40), 5, rWidth, self.frame.size.height);
        
//    } completion:^(BOOL finished) {
//        self.rView.hidden = self.cView.hidden= self.lblComment.hidden = self.lblRrport.hidden = NO;
//        self.rStatus = Report_Status_Open;
 //   }];
    
    
    
}

//- (void)dissmisReportView:(CGRect)frame
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        self.rView.hidden = self.cView.hidden= self.lblComment.hidden = self.lblRrport.hidden = YES;
//        
//        self.frame = frame;
//        
//    } completion:^(BOOL finished) {
//        self.hidden = YES;
//        self.rStatus = Report_Status_Close;
//    }];
//    
//    
//    
//}
//
//- (void)awakeFromNib
//{
//    rBFrame = self.frame;
//    rWidth =  self.frame.size.width;
//    
//    self.rView.hidden = self.cView.hidden= self.lblComment.hidden = self.lblRrport.hidden = self.hidden = YES;
//}
- (IBAction)pressReport:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reportEvent)]) {
        [self.delegate reportEvent];
    }
}
- (IBAction)pressComment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(commentEvent)]) {
        [self.delegate commentEvent];
    }
}


@end