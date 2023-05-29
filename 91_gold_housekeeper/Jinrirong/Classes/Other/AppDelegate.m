//
//  AppDelegate.m
//  Jinrirong
//
//  Created by ahxb on 2018/5/3.
//  Copyright © 2018年 ahxb. All rights reserved.
//

#import "AppDelegate.h"
#import "XBJinRRBaseTabbarViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LF_ShowVersionView.h"
//#import "WXApi.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate/*,WXApiDelegate*/>
{
    LF_ShowVersionView *versionView;
}
/**
 *  友盟推送消息
 */
@property(nonatomic, strong)NSDictionary *userInfo;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [XBUMManager initUmManagerWithLaunchOptions:launchOptions Delegate:self];
    [XBUMManager initIQKeyboardManager];
    
    self.window.rootViewController = [[XBJinRRBaseTabbarViewController alloc]init];

    
    return YES;
}
/*************************************************************/
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * device_token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                stringByReplacingOccurrencesOfString: @">" withString: @""]
                               stringByReplacingOccurrencesOfString: @" " withString: @""];
    [UMessage registerDeviceToken:deviceToken];//1.2.7版本不用设置
    
    
    
    MyLog(@"device_token---  %@",device_token);
//    [XBJinRRNetworkApiManager ].device_token = device_token;
    
    [UDefault setObject:device_token keys:@"device_token"];
    
    
    
    
    
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
    //关闭U-Push自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    self.userInfo = userInfo;
    /*
     // app was already in the foreground
     if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
     {
     UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"许多鲜通知"
     message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
     delegate:self
     cancelButtonTitle:@"确定"
     otherButtonTitles:nil];
     [alert show];
     }
     */
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 统计消息点击事件
    [UMessage sendClickReportForRemoteNotification:self.userInfo];
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self checkVersion];
}


- (void )checkVersion{
    [XBJinRRNetworkApiManager checkVersionBlock:^(id data) {
        NSDictionary *dataDic = data[@"data"];
        if ([dataDic allValues].count>0) {
            NSString *localVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];//当前版本
            if ([dataDic[@"Ver"] compare: localVersion] == NSOrderedDescending) {
                NSString *str = [LLUtils filterHTMLByVersionDes:dataDic[@"Updates"]];
                MyLog(@"%@",data);
                if ([[NSString stringWithFormat:@"%@",dataDic[@"isForced"]] isEqualToString:@"2"]) {
                    //非强制更新
                    [self->versionView removeFromSuperview];
                    //强制更新版本
                    self->versionView = [LF_ShowVersionView alterViewWithTitle:[NSString stringWithFormat:@"发现新版本v%@",dataDic[@"Ver"]] content:str cancel:@"取消" sure:@"前往更新" cancelBtClcik:^{
                        
                    } sureBtClcik:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dataDic[@"Url"]]];
                    }];
                }else{
                    //强制更新
                    [self->versionView removeFromSuperview];
                    //强制更新版本
                    self->versionView = [LF_ShowVersionView alterViewWithTitle:[NSString stringWithFormat:@"发现新版本v%@",dataDic[@"Ver"]] content:str cancel:@"" sure:@"前往更新" cancelBtClcik:^{
                        
                    } sureBtClcik:^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dataDic[@"Url"]]];
                    }];
                }
                
            }
            
            
            
        }
        
    } fail:^(NSError *errorString) {
        
    }];
}





- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    /*
    if([url.absoluteString rangeOfString:@"wx7db7e5982abe238e"].location != NSNotFound){
        //微信支付返回
        return  [WXApi handleOpenURL:url delegate:self];
    };
     */
    if (result == FALSE) {
       
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
                NSLog(@"result = %@",resultDic);
            }];
            if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
                
                [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                    //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
                    NSLog(@"result = %@",resultDic);
                }];
            }
            
        }
     }
    
    return result;
}

//ios9.0之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    /*
     //微信回调成功了，但是不携带任何信息，无法作出回调处理
    if ([options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.xin"]&& [url.absoluteString containsString:@"jrr.ahceshi.com://"]){
        //微信支付返回
        return  [WXApi handleOpenURL:url delegate:self];
    }
     */
    //支付宝支付回调
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"listenAlipayResults" object:self userInfo:@{@"resultDic":resultDic}];
        }];
    }
    
    return result;
}
    
    
/*
// 微信支付成功或者失败回调
-(void)onResp:(BaseResp*)resp
{
    NSInteger result = 0;
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"恭喜您,支付成功!";
                result = 1;
                break;
            }
            case WXErrCodeUserCancel:{
                strMsg = @"已取消支付!";
                result = 2;
                break;
            }
            default:{
                strMsg = [NSString stringWithFormat:@"支付失败!"];
                result = 0;
                break;
            }
        }
        [NSNotic_Center postNotificationName:@"weixinPaystatusSuccess" object:nil userInfo:@{@"status":strMsg,@"result":@(result)}];
    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}
    
   */
@end
