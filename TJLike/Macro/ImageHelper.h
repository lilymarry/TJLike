//
//  ImageHelper.h
//  TJLike
//
//  Created by imac-1 on 16/9/6.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject
+(UIImage*)imageScaleWithImage:(UIImage*)image;
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
