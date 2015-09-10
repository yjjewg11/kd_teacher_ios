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
#define G_rest_uploadFile_upload       @"rest/uploadFile/upload.json"      //正式
#define Webview_URL      @"http://kd.wenjienet.com/px-rest/kd/index.html"
#define String_Success                          @"success"


#define G_Web_IOS       @"ios"      //正式
#define Web_IOS_sessionid     @"sessionid"      //正式
@end