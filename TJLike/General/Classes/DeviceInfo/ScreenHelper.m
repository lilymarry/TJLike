

#import "ScreenHelper.h"


//#define Screen_height   [[UIScreen mainScreen] bounds].size.height
//#define Screen_width    [[UIScreen mainScreen] bounds].size.width
//#define BASE_Size @"iphone5"

@implementation ScreenHelper

//static  CGFloat autoSizeScaleX=1.0;
//static CGFloat autoSizeScaleY=1.0;

+(IphoneScreen)checkWhichIphoneScreen
{
    
    //320 480  , 320 568  ,375  667,  414  736
    
    if (SCREEN_WIDTH<375.0 && SCREEN_HEIGHT<568.0) {
        return 1;
    }else if (SCREEN_WIDTH<375.0 && SCREEN_HEIGHT <667.0)
    {
        return 2;
    }else if (SCREEN_WIDTH<414.0 && SCREEN_HEIGHT <736.0)
    {
        return 3;
    }else{
        return 4;
    }
    
}


//+(int)SCREEN_WIDTH
//{
//    return  (int) Screen_width;
//}
//+(int)SCREEN_HEIGHT
//{
//    return  (int) Screen_height;
//}

//以iphone5尺寸为基准,精算出不同尺寸
//+(CGRect)resizeCGRectX:(CGFloat)x
//                     Y:(CGFloat)y
//                 Width:(CGFloat)width
//                Height:(CGFloat)height
//{
//    [ScreenHelper culculateTheScale];
//    CGRect rect;
//    rect.origin.x = x * autoSizeScaleX;
//    rect.origin.y = y * autoSizeScaleY;
//    rect.size.width = width *autoSizeScaleX;
//    rect.size.height = height * autoSizeScaleY;
//    return rect;
//    
//}
//+(CGSize)resizeCGSizeWidth:(CGFloat)width
//                    Height:(CGFloat)height
//{
//    
//    [ScreenHelper culculateTheScale];
//    CGSize size;
//    size.width = width *autoSizeScaleX;
//    size.height = height * autoSizeScaleY;
//    return size;
//    
//}
//+(CGPoint)resizeCGPointX:(CGFloat)x
//                       Y:(CGFloat)y
//{
//    
//    [ScreenHelper culculateTheScale];
//    CGPoint point;
//    point.x = x *autoSizeScaleX;
//    point.y = y * autoSizeScaleY;
//    return point;
//    
//}


//+(void)culculateTheScale
//{
//    if(Screen_height > 480){
//        autoSizeScaleX = Screen_width/320;
//        autoSizeScaleY = Screen_height/568;
//    }else{
//        autoSizeScaleX = 1.0;
//        autoSizeScaleY = 1.0;
//    }
//}
//
////单独计算图片的高度
//+ (CGFloat)heightForImage:(UIImage *)image WithIBSetWidth:(CGFloat)ibImageWidth
//{
//    CGSize size = image.size;
//    CGFloat scale = ibImageWidth / size.width;
//    CGFloat imageHeight = size.height * scale;
//    return imageHeight;
//}
////单独计算文本的高度
//+ (CGFloat)heightForText:(NSString *)text WithIBSetFontSize:(CGFloat)ibFontSize AndIBCellWidth:(CGFloat)ibTextWidth
//{
//    //设置计算文本时字体的大小,以什么标准来计算
//    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:ibFontSize]};
//    return [text boundingRectWithSize:CGSizeMake(ibTextWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
//}

////16进制颜色值   #000000 -- >  blackcolor
//+(UIColor *)getColor:(NSString*)hexColor
//{
//    unsigned int red,green,blue;
//    NSRange range;
//    range.length = 2;
//    
//    range.location = 0;
//    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
//    
//    range.location = 2;
//    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
//    
//    range.location = 4;
//    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
//    
//    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
//}


//+(CGRect)areaToFullScreenDivStateAndNavBars{
//    CGRect rect=CGRectMake(0, 0, [ScreenHelper SCREEN_WIDTH], [ScreenHelper SCREEN_HEIGHT]-64) ;
//    return rect;
//}
//+(CGRect)areaToFullScreenDivStateAndTabBars{
//    CGRect rect=CGRectMake(0, 0, [ScreenHelper SCREEN_WIDTH], [ScreenHelper SCREEN_HEIGHT]-113) ;
//    return rect;
//}

@end
