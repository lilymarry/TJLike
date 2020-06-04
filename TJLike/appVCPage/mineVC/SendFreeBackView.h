//
//  SendFreeBackView.h
//  TJLike
//
//  Created by imac-1 on 2016/12/5.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SendFinish)();

@interface SendFreeBackView : UIView
{
    UITextView *mTextView;
    UIView *mBackView;
}
@property (nonatomic, strong) NSString *nid;
@property (nonatomic, copy) SendFinish mBlock;

- (void)HiddenView;

@end
