
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum
{
    iphone4=1,
    iphone5,
    iphone6,
    iphone6plus
}IphoneScreen;

@interface ScreenHelper : NSObject



+(IphoneScreen)checkWhichIphoneScreen;
//+(int)SCREEN_WIDTH;
//+(int)SCREEN_HEIGHT;
//+(CGRect)resizeCGRectX:(CGFloat)x
//                     Y:(CGFloat)y
//                 Width:(CGFloat)width
//                Height:(CGFloat)height;
//+(CGPoint)resizeCGPointX:(CGFloat)x
//                       Y:(CGFloat)y;
//+(CGSize)resizeCGSizeWidth:(CGFloat)width
//                    Height:(CGFloat)height;
////+(int)AutoSizeScaleX;
////+(int)AutoSizeScaleY;
//
//+ (CGFloat)heightForImage:(UIImage *)image WithIBSetWidth:(CGFloat)ibImageWidth;
//+ (CGFloat)heightForText:(NSString *)text WithIBSetFontSize:(CGFloat)ibFontSize AndIBCellWidth:(CGFloat)ibTextWidth;
//
//+(CGRect)areaToFullScreenDivStateAndNavBars;
//+(CGRect)areaToFullScreenDivStateAndTabBars;
////#007aff  系统蓝色
//+(UIColor *)getColor:(NSString*)hexColor;



@end
