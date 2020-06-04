
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AlertHelper : NSObject

+(void)singleAlertShow:(NSString*)msg;
+(void)singleMBHUDShow:(NSString*)msg ForView:(UIView*)view;
+(void)singleAlertShowAndMBHUDHid:(NSString*)msg ForView:(UIView*)view;
+(void)hidMBHUDFromView:(UIView*)view;
+(void)hideAllHUDsForView:(UIView *)view;
+(void)singleMBHUDShow:(NSString*)msg ForView:(UIView*)view AndDelayHid:(NSTimeInterval)second;

+(void)MBHUDShow:(NSString *)msg ForView:(UIView *)view AndDelayHid:(NSTimeInterval)second;

@end
