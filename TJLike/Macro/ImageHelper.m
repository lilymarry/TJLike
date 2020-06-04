//
//  ImageHelper.m
//  TJLike
//
//  Created by imac-1 on 16/9/6.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "ImageHelper.h"
#import "ScreenHelper.h"
@implementation ImageHelper
///对图片尺寸进行压缩--
+(UIImage*)imageScaleWithImage:(UIImage*)image
{
    //设置image的尺寸
    CGSize imagesize = image.size;
    
    //iphone5
    CGFloat a=(imagesize.height>imagesize.width)?320.0:568;
    //iphone6
    if ([ScreenHelper checkWhichIphoneScreen] == iphone6) {
        a=(imagesize.height>imagesize.width)?375:667;
    }else if ([ScreenHelper checkWhichIphoneScreen] == iphone6plus){
        a=(imagesize.height>imagesize.width)?414:736;
    }
    
    float XX=imagesize.width/a;//宽度比
    float VY=imagesize.height/XX;//在屏幕上的高度
    
    imagesize.width = a;//放大倍数100
    imagesize.height =VY;
    
    UIImage *ima = [self imageWithImage:image scaledToSize:imagesize];
   // NSLog(@"")
    return ima;
    
    
}
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
