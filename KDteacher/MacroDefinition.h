//
//  MacroDefinition.h
//  PublicCulture
//
//  Created by huangfang on 15/8/26.
//  Copyright (c) 2015年 huangfang. All rights reserved.
//

#ifndef PublicCulture_MacroDefinition_h
#define PublicCulture_MacroDefinition_h




#define JZNavBarTitleFontSize 20
#define JZNavBarItemFontSize 15

#define JZTabBarNormalTitleColor [UIColor whiteColor]
#define JZTabBarSelectedTitleColor [UIColor whiteColor]

#define JZNavigationBarBackgrundColor(RGB)    \
if (currentSystemVersion() >= 7.0)              \
{                                             \
[self.navigationController.navigationBar  \
setBackgroundImage:[UIImage imageWithColor:RGB withSize:CGSizeMake(320, 64)]    \
forBarMetrics:UIBarMetricsDefault];      \
}                                             \
else{                                         \
[self.navigationController.navigationBar  \
setBackgroundImage:[UIImage imageWithColor:RGB withSize:CGSizeMake(320, 44)]    \
forBarMetrics:UIBarMetricsDefault];      \
}

#define JZStatusBarStyle(statusBarStyle)      \
if (currentSystemVersion() >= 7) {            \
[[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle];        \
}                                             \
else{                                         \
[[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle];        \
}

#define JZVcTopSettingWithColorAndStatusBarStyle(firstColor, firstBarStyle, otherColor, otherBarStyle) \
if (self.navigationController.viewControllers.count > 1 || self.presentingViewController) {            \
JZStatusBarStyle((otherBarStyle))                \
JZNavigationBarBackgrundColor((otherColor))      \
}                                                    \
else{                                                \
JZStatusBarStyle((firstBarStyle))                \
JZNavigationBarBackgrundColor((firstColor))      \
}

//----------------------------------------------------------------------------------------------------------------------


/**
 *  第一部分,颜色部分
 */
#define CH_COLOR_normal(_R,_G,_B) [UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:1]
#define CH_COLOR_alpha(_R,_G,_B,_A) [UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:_A]
#define CH_COLOR_gray(_light,_alpha) [UIColor colorWithRed:_light / 255.0f green:_light / 255.0f blue:_light / 255.0f alpha:_alpha]
#define CH_COLOR_white [UIColor whiteColor]
#define CH_COLOR_clear [UIColor clearColor]
#define CH_COLOR_image(_imageName) [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:_imageName]]]

/**
 *  第二部分,关于屏幕尺寸
 */
#define CH_SCREEN_width [[UIScreen mainScreen] bounds].size.width
#define CH_SCREEN_height [[UIScreen mainScreen] bounds].size.height
#define CH_SCREEN_frame [[UIScreen mainScreen] bounds]
#define CH_SCREEN_size [[UIScreen mainScreen] bounds].size
#define CH_SCREEN_4 [[UIScreen mainScreen] bounds].size.height > 500 ? YES : NO

#define CH_Status_height 20
#define CH_Navbar_height 64
#define CH_Tabbar_height 48

/**
 *  第三部分,关于系统
 */
#define UIDeviceVersion [[[UIDevice currentDevice] systemVersion]floatValue]
#define CH_IOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define CH_IOS [[UIDevice currentDevice] systemVersion]
#define CH_AppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define CH_RootController [UIApplication sharedApplication].keyWindow.rootViewController
#define CH_UserDefaults [NSUserDefaults standardUserDefaults]
#define CH_FileManager [NSFileManager defaultManager]

/**
 *  第四部分,关于视图尺寸
 */
#define CH_VIEW_size(_view) _view.frame.size
#define CH_VIEW_centerX(_view) _view.center.x
#define CH_VIEW_centerY(_view) _view.center.y
#define CH_VIEW_width(_view) _view.frame.size.width
#define CH_VIEW_height(_view) _view.frame.size.height

/**
 *  第五部分,关于文件缓存管理
 */
#define CH_Caches_Temp [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches/Temp"]
#define CH_Caches_Temp_Voice [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches/Temp/VoiceNoteCache"]
#define CH_Caches_Temp_VidioCahe [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches/Temp/VideoCache"]
#define CH_Caches_Temp_UserData [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches/Temp/UserData"]
#define CH_Documents_Dicrectory [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()]
#define CH_FileManager [NSFileManager defaultManager]

/**
 *  第六部分,关于简单方法
 */
#define CH_IMAGE(_name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:_name]]
#define CH_Font_Sys(_size) [UIFont systemFontOfSize:_size]
#define CH_Font_Bold(_size) [UIFont boldSystemFontOfSize:_size]
#define CH_CGRM(_x,_y,_w,_h) CGRectMake(_x, _y, _w, _h)
#define CH_CGPM(_x,_y) CGPointMake(_x, _y)
#define CH_CGSM(_w,_h) CGSizeMake(_w, _h)


//#endif
#define COLOR(_R,_G,_B,_A) [UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:_A]

//#import "JZUserInfo.h"




#define isIos8 [[[UIDevice currentDevice] systemVersion] floatValue]>=8.0
#define isIos7 [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define LoadImage(name) [UIImage imageNamed:name] 
#define ITEM_IS_NULL(_A__ITEM__) ( [(_A__ITEM__) isEqual: [NSNull null]] \
||[(_A__ITEM__) length]==0 || [(_A__ITEM__) isEqualToString:@"<null>"] ||[(_A__ITEM__) isEqualToString:@"null"]|| [(_A__ITEM__) isEqualToString:@"(null)"]||[(_A__ITEM__) isEqualToString:@""])

#define alertContent(content) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" \
message:content \
delegate:nil   \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil];  \
[alert show];





#endif
