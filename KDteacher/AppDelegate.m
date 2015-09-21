//
//  AppDelegate.m
//  KDteacher
//
//  Created by liumingquan on 15/8/13.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "AppDelegate.h"
//#import "MobClick.h"
#import "HomePageViewController.h"
#import "UMessage.h"
#import "UMFeedback.h"
#import "UMOpus.h"
#import "UMOpenMacros.h"
#import "KeychainItemWrapper.h"
#import "KGHttpService.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define _IPHONE80_ 80000
#define NewMessageKey @"newMessage"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UMFeedback setAppkey:@"55cc8dece0f55a2379004ba7"];
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    HomePageViewController *home = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
    
    self.window.rootViewController=home;
    [self.window makeKeyAndVisible];
[UMessage startWithAppkey:@"55cc8dece0f55a2379004ba7" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
    
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
    
    if(![key isEqualToString:@""]){
        [KGHttpService sharedService].pushToken = key;
    }

    [UMessage registerDeviceToken:deviceToken];
    
    NSLog(@"umeng message alias is: %@", [UMFeedback uuid]);
    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
            NSLog(@"%@", responseObject);
        }
    }];
}

- (void)savePushToken:(NSString *)key{
    KeychainItemWrapper * wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeyChain" accessGroup:nil];
    //    NSString * wrapperToken = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
    
    //    if(![key isEqualToString:wrapperToken] || [key isEqualToString:String_DefValue_Empty]){
    
    
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:NewMessageKey];
    if (temp == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NewMessageKey];
    }
    NSString * status;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:NewMessageKey]) {
        status = @"0";
    }else{
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

@end
