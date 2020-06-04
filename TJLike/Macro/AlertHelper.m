
#import "AlertHelper.h"

@implementation AlertHelper

//显示UIAlertView
+(void)singleAlertShow:(NSString *)msg{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    
}

//显示带进度条的 MBProgressHUD －－不会消失
+(void)singleMBHUDShow:(NSString *)msg ForView:(UIView*)view{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view  animated:YES];
    hud.labelText=msg;
}

//移除MBProgressHUD 并显示UIAlertView
+(void)singleAlertShowAndMBHUDHid:(NSString *)msg ForView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];

}

//隐藏所有MBProgressHUD
+(void)hideAllHUDsForView:(UIView *)view{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

//移除MBProgressHUD
+(void)hidMBHUDFromView:(UIView *)view{
     [MBProgressHUD hideHUDForView:view animated:NO];
}

//显示不带进度的 MBProgressHUD －－规定时间后消失
+(void)singleMBHUDShow:(NSString *)msg ForView:(UIView *)view AndDelayHid:(NSTimeInterval)second{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view  animated:YES];
    hud.labelText=msg;
    hud.removeFromSuperViewOnHide=YES;
    hud.mode=MBProgressHUDModeText;
   [hud hide:YES afterDelay:second];
}
//显示带进度的 MBProgressHUD －－规定时间后消失
+(void)MBHUDShow:(NSString *)msg ForView:(UIView *)view AndDelayHid:(NSTimeInterval)second{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:view  animated:YES];
    hud.labelText=msg;
    hud.removeFromSuperViewOnHide=YES;
    hud.mode=MBProgressHUDModeIndeterminate;
    [hud hide:YES afterDelay:second];
}

@end
