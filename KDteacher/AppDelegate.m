//
//  AppDelegate.m
//  KDteacher
//
//  Created by liumingquan on 15/8/13.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
//#import "MobClick.h"
#import "UMessage.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif
#import "UMFeedback.h"
#import "UMOpus.h"
#import "UMOpenMacros.h"
#import "KeychainItemWrapper.h"
#import "KGHttpService.h"

#import <UMSocialCore/UMSocialCore.h>


#import <Bugly/Bugly.h>




#define BUGLY_APP_ID @"900011891"


#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define _IPHONE80_ 80000
#define NewMessageKey @"newMessage"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
//    return [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
//    return  [UMSocialSnsService handleOpenURL:url];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [UMessage startWithAppkey:@"55cc8dece0f55a2379004ba7" launchOptions:launchOptions];
    
    //设置 AppKey 及 LaunchOptions
//    [UMessage startWithAppkey:@"your appkey" launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    //end push message
    
    //    [UMSocialData openLog:YES];
       //share start
    //打开日志
//    [[UMSocialManager defaultManager] openLog:YES];
    
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"55cc8dece0f55a2379004ba7"];
   
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxc784adf432c9f59d" appSecret:@"078b3b3e3515f1d434c87d20dc02ab8c" redirectURL:@"http://www.wenjienet.com/"];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1104762949"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://www.wenjienet.com/"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1987919613"  appSecret:@"cd53ba43727161b6a3ac688ff49f99e9" redirectURL:@"http://www.wenjienet.com/"];
    

    //share end
    [UMFeedback setAppkey:@"55cc8dece0f55a2379004ba7"];
    
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
//    HomePageViewController *home = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];

    HomeVC * home = [[HomeVC alloc] init];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:home];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
//    
//    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
//    {
//        //register remoteNotification types （iOS 8.0及其以上版本）
//        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//        action1.identifier = @"action1_identifier";
//        action1.title=@"Accept";
//        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//        
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//        action2.identifier = @"action2_identifier";
//        action2.title=@"Reject";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//        
//        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
//        categorys.identifier = @"category1";//这组动作的唯一标示
//        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
//        
//        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
//                                                                                     categories:[NSSet setWithObject:categorys]];
//        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
//        
//    }
//    else
//    {
//        //register remoteNotification types (iOS 8.0以下)
//        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//         |UIRemoteNotificationTypeSound
//         |UIRemoteNotificationTypeAlert];
//    }
//#else
//    
//    //register remoteNotification types (iOS 8.0以下)
//    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//     |UIRemoteNotificationTypeSound
//     |UIRemoteNotificationTypeAlert];
//    
//#endif
//    //for log
//    [UMessage setLogEnabled:YES];
//    
//    
    #pragma mark - bugly配置
    
//    [[CrashReporter sharedInstance] enableLog:YES];
    
    
    [self setupBugly];
    

//    [Bugly startWithAppId:@"900011891"];
    
//     BuglyConfig *config = [[BuglyConfig alloc] init];
//    config.blockMonitorEnable = YES;
//    
//    [Bugly startWithAppId:@"900011891" config:config];
//    
    
    #pragma mark - 设置推送默认开启
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:NewMessageKey];
    if (temp == nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NewMessageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
    //[MobClick startWithAppkey:@"55cc8dece0f55a2379004ba7" reportPolicy:BATCH channelId:@"app store"];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    NSArray * strAry = [token componentsSeparatedByString:@" "];
    NSMutableString * key = [NSMutableString stringWithString:@""];
    for(NSString * str in strAry){
        [key appendString:str];
    }
    
    if(![key isEqualToString:@""])
    {
        NSLog(@"== %@",[KGHttpService sharedService].pushToken);
        [KGHttpService sharedService].pushToken = key;
    }

//    [UMessage registerDeviceToken:deviceToken];
//    
//    NSLog(@"umeng message alias is: %@", [UMFeedback uuid]);
//    
//    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error)
//    {
//        if (error != nil) {
//            NSLog(@"%@", error);
//            NSLog(@"%@", responseObject);
//        }
//    }];
}

- (void)savePushToken:(NSString *)key
{
    KeychainItemWrapper * wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeyChain" accessGroup:nil];
    //    NSString * wrapperToken = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
    
    //    if(![key isEqualToString:wrapperToken] || [key isEqualToString:String_DefValue_Empty]){
    
    
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:NewMessageKey];
    if (temp == nil)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NewMessageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString * status;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:NewMessageKey])
    {
        status = @"0";
    }
    else
    {
        status = @"2";
    }
    
    [[KGHttpService sharedService] submitPushTokenWithStatus:status success:^(NSString *msgStr) {
        [wrapper setObject:key forKey:(__bridge id)kSecAttrAccount];
        NSLog(@"msgStr=%@",msgStr);
    } faild:^(NSString *errorMsg) {
        
    }];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败，无法获取设备ID, 具体错误: %@", error);
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


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
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


- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.blockMonitorEnable=YES;
    config.unexpectedTerminatingDetectionEnable=YES;
    config.appTransportSecurityEnable=YES;
    config.symbolicateInProcessEnable=YES;
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    //[self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
}


@end
