//
//  KDConstants.h
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/8.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDConstants : NSObject
#define URL(baseURL, businessURL) [NSString stringWithFormat:@"%@%@", baseURL, businessURL];

#define G_baseServiceURL       @"http://kd.wenjienet.com/px-rest/"      //正式
//#define G_baseServiceURL @"http://120.25.212.44/px-rest/"                 //测试
//#define G_baseServiceURL @"http://192.168.0.116:8080/px-rest/"

#define G_rest_uploadFile_upload       @"rest/uploadFile/upload.json"      //正式

#define Webview_URL      @"http://kd.wenjienet.com/px-rest/kd/index.html"
//#define Webview_URL      @"http://120.25.212.44/px-rest/kd/index.html"    //测试

//#define Webview_URL @"http://192.168.0.116:8080/px-rest/"

#define String_Success                          @"success"
#define Push_Token      @"rest/pushMsgDevice/save.json"

#define G_Web_IOS       @"ios"      //正式
#define Web_IOS_sessionid     @"sessionid"      //正式

//调js的相关方法
#define Star_Js        @"G_jsCallBack.setIosApp()"//加载完webview代码
#define Share_Js       @"G_jsCallBack.setIosApp_canShareURL()" //允许分享
#define Head_Pic       @"selectHeadPic"
#define Image_Pic      @"selectImgPic"
#define Share_Content  @"setShareContent"
#define Open_Window    @"openNewWindowUrl"

#define Share_Object   @"G_jsCallBack.getShareObject()"


//友盟
#define UmengAPPKEY = @"55cc8dece0f55a2379004ba7"

@end
