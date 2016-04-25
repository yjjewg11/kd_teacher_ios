//
//  HomeVC.h
//  KDteacher
//
//  Created by Mac on 15/12/28.
//  Copyright © 2015年 liumingquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSExport <JSExport>
JSExportAs
(setShareContent  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)setShareContent:(NSString *)title content:(NSString *)content pathurl:(NSString *)pathurl httpurl:(NSString *)httpurl
 );

JSExportAs
(selectImgPic  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)selectImgPic:(NSString *)groupuuid
 );

JSExportAs
(selectHeadPic  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)selectHeadPic:(NSString *)msg
 );

JSExportAs
(finishProject  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)finishProject:(NSString *)url
 );

JSExportAs
(jsessionToPhone  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)jsessionToPhone:(NSString *)jessid
 );

JSExportAs
(getJsessionid  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (NSString *)getJsessionid:(NSString *)jessid
 );

JSExportAs
(openNewWindowUrl  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)openNewWindow:(NSString *)title1 content:(NSString *)content pathurl:(NSString *)pathurl httpurl:(NSString *)httpurl
 );

JSExportAs
(hideLoadingDialog  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)hideLoadingDialog:(NSString *)msg
 );

JSExportAs
(jsessionToPhoneTel, /**接收用户电话号码
                                   */
 -(void)jsessionToPhoneTel:(NSString *)tel
 );

JSExportAs
(selectImgForCallBack  /** JavaScriptCall.selectImgForCallBack( callback, maxConut, quality(单位k))  作为js方法的别名 */,
 - (void)selectImgForCallBack:(NSString *)callback maxConut:(NSString *)maxConut quality:(NSString *)quality
 );
@end

@interface HomeVC : BaseViewController



@end
