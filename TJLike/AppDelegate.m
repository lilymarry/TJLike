//
//  AppDelegate.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/28.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//
#import "TJMainTabbarControllerViewController.h"
#import "AppDelegate.h"
#import "SDReachability.h"
#import "ShareSDK.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import "TJStartView.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "UserFactory.h"
#import "XHLaunchAd.h"
//#import "AdvertViewController.h"
#import "WebApi.h"
#import "UIImageView+WebCache.h"
#import "ScrollViewController.h"
#import "TJAddverViewController.h"
#import "XKTabBarController.h"
//静态广告
//#define ImgUrlString1 @"http://d.hiphotos.baidu.com/image/pic/item/14ce36d3d539b60071473204e150352ac75cb7f3.jpg"
//动态广告
//#define ImgUrlString2 @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg"
//#define ImgUrlString3 [UIImage imageNamed:@"LaunchImage"]

@interface AppDelegate ()
{
   XHLaunchAd *launchAdd;
    NSDictionary *addDic;

}
@property (nonatomic, strong) TJAppContext *appContext;
//@property (nonatomic, strong) WTVHttpClient *httpClient;
@property (nonatomic, strong) UIWindow     *startImageWindow;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [ShareSDK registerApp:@"6afd87eb76b6"];
    [ShareSDK  connectSinaWeiboWithAppKey:@"4229658652" appSecret:@"f86396c7ad1868d241a3d54dfeb2596d" redirectUri:@"www.sina.com" weiboSDKCls:[WeiboSDK class]];
    [ShareSDK connectWeChatWithAppId:@"wx7cccb57dbdb2f8bd"   //微信APPID
                           appSecret:@"a706d91a4b8c3ba0a9fe76d31277f3fb"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    [AVOSCloud setApplicationId:@"4LsaK2PN7RCDvUQNPLO6UDai-gzGzoHsz" clientKey:@"LFCMsb9RnJcEoxKeCJROgoQk"];
    
   [CDChatManager manager].userDelegate = [[UserFactory alloc]init];
    
    self.appContext = AppContext;
    [self.appContext initialConfig];
    [self monitorReachability];
  //  [self applicationBuildStartPage];
    [self getData];
    
  
   
    [self.window makeKeyAndVisible];
    
    return YES;
}
/**
 *  启动页广告
 */
-(void)example
{
    /**
     *  1.显示启动页广告
     */
    [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height) setAdImage:^(XHLaunchAd *launchAd) {
        
        //未检测到广告数据,启动页停留时间,不设置默认为3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
      // launchAd.noDataDuration = 3;
      //  launchAdd=launchAd;
        
        
        //获取广告数据
        [self requestImageData:^(NSString *imgUrl, NSInteger duration, NSString *openUrl) {
            
            /**
             *  2.设置广告数据
             */
            
            //定义一个weakLaunchAd
            __weak __typeof(launchAd) weakLaunchAd = launchAd;
            [launchAd setImageUrl:imgUrl duration:duration skipType:SkipTypeTimeText options:XHWebImageDefault completed:^(UIImage *image, NSURL *url) {
                
                //异步加载图片完成回调(若需根据图片尺寸,刷新广告frame,可在这里操作)
                //weakLaunchAd.adFrame = ...;
                
            } click:^{
                
                //广告点击事件
                
                //1.用浏览器打开
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
              
                
                UIStoryboard *s = [UIStoryboard storyboardWithName:@"Adverse" bundle:[NSBundle mainBundle]];
                TJAddverViewController *ctrl = [s instantiateViewControllerWithIdentifier:@"addver"];
                ctrl.nid=addDic[@"id"];
                ctrl.sharePicUrl=addDic[@"url"];
           
               [weakLaunchAd presentViewController:ctrl animated:YES completion:nil];
            
                
                //2.在webview中打开
//                TJNewsNormalDetailController *VC = [[TJNewsNormalDetailController alloc] init];
//            //   AdvertViewController *VC = [[AdvertViewController alloc] init];
//              //  VC.urlString = openUrl;
//                VC.nid = addDic[@"id"];
//                VC.sharePicUrl=openUrl;
//                
//              //  VC.refreshDelegate=self;
//               [weakLaunchAd presentViewController:VC animated:YES completion:nil];
              //  weakLaunchAd.noDataDuration = 0;
                
            }];
            
        }];
        
    } showFinish:^{
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        BOOL Have = [user boolForKey:@"cunzai"];
        if (!Have)
        {
            ScrollViewController* start = [[ScrollViewController alloc] init];
            self.window.rootViewController =start;
         //   [self presentViewController:start animated:YES completion:nil];
            
        }else
        {

        //广告展示完成回调,设置window根控制器
      //  self.window.rootViewController = [[TJMainTabbarControllerViewController alloc]  init];
             self.window.rootViewController = [[XKTabBarController alloc]  init];
        }
        
    }];
}
-(void)getData
{
   [[WebApi sharedRequest]GetUserAddverWithSuccess:^(NSDictionary *userInfo) {
      
        if ([[userInfo objectForKey:@"code"] integerValue] == 200) {
            addDic=[userInfo[@"data"] copy];
            [self example];
        }
        else
        {
            [self monitorReachability];

        }
   } fail:^{
       [self monitorReachability];

   }];

}
/**
 *  模拟:向服务器请求广告数据
 *
 *  @param imageData 回调imageUrl,及停留时间,跳转链接
 */
-(void)requestImageData:(void(^)(NSString *imgUrl,NSInteger duration,NSString *openUrl))imageData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(imageData)
        {
            imageData(addDic[@"pic"],3,addDic[@"url"]);
        }
    });
}
-(void)refreshingDataList
{
   // launchAdd.noDataDuration = 0;

}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"Application did receive local notifications");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:notification.alertBody delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{

    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationBuildStartPage
{
    if (_startImageWindow == nil) {
        _startImageWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _startImageWindow.backgroundColor = [UIColor clearColor];
        _startImageWindow.userInteractionEnabled = YES;
        _startImageWindow.windowLevel = UIWindowLevelStatusBar + 1;
        _startImageWindow.hidden = NO;
        
    }
    
    TJStartView *startView = [[TJStartView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    
    [_startImageWindow addSubview:startView];
    @weakify(self)
    startView.tapHidden = ^{
        @strongify(self)
        [self hiddenStartPage];
    };
    
    
}
- (void)hiddenStartPage
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.type = kCATransitionFade;
    self.startImageWindow.alpha = 0;
    transition.delegate = self;
    [_startImageWindow.layer addAnimation:transition forKey:nil];
    _startImageWindow.windowLevel = UIWindowLevelStatusBar - 1;
}

- (void)monitorReachability
{
//    [HttpClient.networkStatusSignal subscribeNext:^(id x) {
//        switch ([x intValue]) {
//            case SDNotReachable:
//                
//                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络故障,请检查网络设置" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
//                
//                break;
//                
//            default:
//                break;
//        }
//    }];
}

@end
