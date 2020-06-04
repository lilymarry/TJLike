//
//  TJSubjcetItemButton.m
//  TJLike
//
//  Created by imac-1 on 16/9/7.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "TJSubjcetItemButton.h"

@implementation TJSubjcetItemButton
- (id)initWithFrame:(CGRect)frame andlabName:( NSString *) labName andImaName:(NSString *)imaName
{
   
        self = [super initWithFrame:frame];
        if (self)
        {
            UIImageView *imag=[[UIImageView alloc]initWithFrame:CGRectMake(11, 4, 35, 35)];
             imag.image=[UIImage imageNamed:imaName];
            [self addSubview:imag];
            
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-21, 56, 21)];
            lab.text=labName;
            lab.textAlignment=NSTextAlignmentCenter;
            lab.font=[UIFont systemFontOfSize:14];
            [self addSubview:lab];
        
            
        }
        return self;
    
}

@end
