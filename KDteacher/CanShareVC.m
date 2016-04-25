//
//  CanShareVC.m
//  KDteacher
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 liumingquan. All rights reserved.
//

#import "CanShareVC.h"
#import "UMSocial.h"
#import "HLActionSheet.h"
#import "ShareDomain.h"
#import "UMSocialWechatHandler.h"
#import "HLActionSheet.h"
#import "UMSocialWechatHandler.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "PhotoVC.h"
// 用于UIWebView保存图片
enum
{
    GESTURE_STATE_NONE = 0,
    GESTURE_STATE_START = 1,
    GESTURE_STATE_MOVE = 2,
    GESTURE_STATE_END = 4,
    GESTURE_STATE_ACTION = (GESTURE_STATE_START | GESTURE_STATE_END),
};

//js注入用
static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};";


@interface CanShareVC () <UIWebViewDelegate,UIActionSheetDelegate,UMSocialUIDelegate>
{
      UIActionSheet * _myActionSheet;
    NSTimer *_timer;	// 用于UIWebView保存图片
    int _gesState;	  // 用于UIWebView保存图片
    NSString *_imgURL;  // 用于UIWebView保存图片
    BOOL longPress;

}
@property (assign, nonatomic) NSInteger sheetType;  //标记打开的actionsheet是否可以识别二维码
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@end

@implementation CanShareVC

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.titleLbl.text = self.domain.title;
    });
    
    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.domain.httpurl]];
    
    [self.webView loadRequest:req];
    self.webView.delegate=self;
    //二维码长按手势
    UILongPressGestureRecognizer *longtapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longtap:)];
    
    [_webView addGestureRecognizer:longtapGesture];

}

- (IBAction)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)load:(id)sender
{
    ShareDomain * domain = [[ShareDomain alloc] init];
    
    domain = self.domain;
    
    NSArray *titles = @[@"微博",@"微信",@"朋友圈",@"QQ好友",@"复制链接"];
    
    NSArray *imageNames = @[@"xinlang",@"weixin",@"pyquan",@"qq",@"fuzhilianjie"];
    
    HLActionSheet *sheet = [[HLActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [sheet showActionSheetWithClickBlock:^(NSInteger btnIndex)
         {
             switch (btnIndex)
             {
                 case 0:
                 {
                     [self handelShareWithShareType:UMShareToSina domain:domain];
                 }
                     break;
                     
                 case 1:
                 {
                     [self handelShareWithShareType:UMShareToWechatSession domain:domain];
                 }
                     break;
                     
                 case 2:
                 {
                     [self handelShareWithShareType:UMShareToWechatTimeline domain:domain];
                 }
                     break;
                     
                 case 3:
                 {
                     [self handelShareWithShareType:UMShareToQQ domain:domain];
                 }
                     break;
                     
                 case 4:
                 {
                     UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
                     pasteboard.string = domain.httpurl;
                     //提示复制成功
                     UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已复制分享链接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                     [av show];
                 }
                     break;
                     
                 default:
                     break;
             }
         }
                                 cancelBlock:^
         {
             NSLog(@"取消");
         }];
    });
    
}

#pragma mark - 处理分享操作
- (void)handelShareWithShareType:(NSString *)shareType domain:(ShareDomain *)domain
{
    NSString * contentString = domain.title;
    
    NSString * shareurl = domain.httpurl;
    
    if(!shareurl || [shareurl length] == 0)
    {
        shareurl = @"http://wenjie.net";
    }
    
    //微信title设置方法：
    [UMSocialData defaultData].extConfig.wechatSessionData.title = domain.title;
    
    //朋友圈title设置方法：
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = domain.title;
    [UMSocialWechatHandler setWXAppId:@"wx6699cf8b21e12618" appSecret:@"639c78a45d012434370f4c1afc57acd1" url:domain.httpurl];
    [UMSocialData defaultData].extConfig.qqData.title = domain.title;
    [UMSocialData defaultData].extConfig.qqData.url = domain.httpurl;
    
    if (shareType == UMShareToSina)
    {
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",contentString,shareurl];
        [UMSocialData defaultData].extConfig.sinaData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:shareurl];
    }
    
    //设置分享内容，和回调对象
    [[UMSocialControllerService defaultControllerService] setShareText:contentString shareImage:[UIImage imageNamed:@"sharelogo"] socialUIDelegate:self];
    
    UMSocialSnsPlatform * snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareType];
    
    snsPlatform.snsClickHandler(self, [UMSocialControllerService defaultControllerService],YES);
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    UIAlertView * alertView;
    NSString * string;
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        string = @"分享成功";
    }
    else if (response.responseCode == UMSResponseCodeCancel)
    {
    }
    else
    {
        string = @"分享失败";
    }
    if (string && string.length)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [alertView show];
        });
    }
}


#pragma mark - 手势长按
- (void)longtap:(UILongPressGestureRecognizer * )longtapGes
{
    if (_imgURL)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self handleLongTouch];
                       });
    }
}


#pragma mark - 保存图片用于识别
- (void)recognizeTwoCode
{
    if (_imgURL)
    {
        //            NSLog(@"imgurl = %@", _imgURL);
    }
    
    NSString *urlToSave = [_webView stringByEvaluatingJavaScriptFromString:_imgURL];
    //        NSLog(@"image url = %@", urlToSave);
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
    UIImage* image = [UIImage imageWithData:data];
    
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
    //        NSLog(@"UIImageWriteToSavedPhotosAlbum = %@", urlToSave);
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - 长按保存图片
// 功能：UIWebView响应长按事件
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[_request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"])
    {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            NSLog(@"you are touching!");
            //            NSTimeInterval delaytime = 2;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                _gesState = GESTURE_STATE_START;
                NSLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [_webView stringByEvaluatingJavaScriptFromString:js];
                _imgURL = nil;
                
                if ([tagName isEqualToString:@"IMG"])
                {
                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                }
                if (_imgURL && longPress)
                {
                    
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                    longPress = NO;
                }
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                _gesState = GESTURE_STATE_MOVE;
                NSLog(@"you are move");
            }  else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
                [_timer invalidate];
                _timer = nil;
                _gesState = GESTURE_STATE_END;
                longPress = YES;
                NSLog(@"touch end");
            }
            
            
        }
        return NO;
    }
    
    return YES;
}

- (void)handleLongTouch
{
    
    longPress=YES;
    NSLog(@"%@", _imgURL);
    if (_imgURL && _gesState == GESTURE_STATE_START)
    {
        _myActionSheet = nil;
        _myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"识别二维码图片",@"浏览原图", nil];
        _myActionSheet.cancelButtonIndex = _myActionSheet.numberOfButtons - 1;
        
        self.sheetType = 1;
        
        _gesState = GESTURE_STATE_END;
        
        [_myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}


//end 长按事件

#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    _context = [[JSContext alloc] init];
//    
//    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    
//    //打印异常
//    _context.exceptionHandler =
//    ^(JSContext *context, JSValue *exceptionValue)
//    {
//        context.exception = exceptionValue;
//        NSLog(@"异常:%@", exceptionValue);
//    };
//    
//    //以 JSExport 协议关联 native 的方法
//    _context[@"JavaScriptCall"] = self;
    
    [_webView stringByEvaluatingJavaScriptFromString:Share_Js];
    
    _webView.hidden = NO;
    
    [self hidenLoadView];
    
    
    //下面是二维码相关
    // 当iOS版本大于7时，向下移动20dp
    // 防止内存泄漏
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    // 响应touch事件，以及获得点击的坐标位置，用于保存图片
    [_webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
    
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"加载网页失败" message:@"请检查网络是否连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    [alert show];
}


#pragma mark - 图片相关
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if(self.sheetType == 0){
        //呼出的菜单按钮点击后的响应
        if (buttonIndex == _myActionSheet.cancelButtonIndex)
        {
            NSLog(@"取消");
        }
//        
//        switch (buttonIndex)
//        {
//            case 0:  //打开照相机拍照
//                [self takePhoto];
//                break;
//                
//            case 1:  //打开本地相册
//                [self LocalPhoto];
//                break;
//        }
        
    }else{
        //识别二维码调用的
        
        //呼出的菜单按钮点击后的响应
        if (buttonIndex == _myActionSheet.cancelButtonIndex)
        {
            NSLog(@"取消");
        }
        else
        {
            
            switch (buttonIndex)
            {
                case 0:  //打开照相机拍照
                    [self recognizeTwoCode];
                    break;
                    
                case 1:  //显示原图
                    if (_imgURL)
                    {
                        NSString *urlToSave = [_webView stringByEvaluatingJavaScriptFromString:_imgURL];
                        [self showBigPhoto:urlToSave];
                    }
                    
                    
                    break;
            }
            
            
        }
    }
    
}

// 功能：显示图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error)
    {
        [self showAlert:@"出错了..."];
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        
        if (image)
        {
            [LBXScanWrapper recognizeImage:image success:^(NSArray<LBXScanResult *> *array)
             {
                 [weakSelf scanResultWithArray:array];
             }];
        }
    }
}

// 功能：显示对话框
-(void)showAlert:(NSString *)msg
{
    //    NSLog(@"showAlert = %@", msg);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self showAlert:@"识别失败了！"];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array)
    {
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    if (strResult.strScanned == nil)
    {
        
        
        [self showAlert:@"识别失败了！"];
    }
    else
    {
        //        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        //        pasteboard.string = strResult.strScanned;
        
        
        [ self openNewWindow:strResult.strScanned content:strResult.strScanned pathurl:strResult.strScanned httpurl:strResult.strScanned];
        
        //提示复制成功
        //        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已复制二维码链接到剪贴板,您可以复制到浏览器中打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [av show];
    }
}


- (void)showBigPhoto:(NSString *)localUrl
{
    //NSInteger index = [noti.object integerValue];
    NSString * path = [[localUrl componentsSeparatedByString:@"@"] firstObject];
    NSMutableArray *array = [NSMutableArray array];
    
    
    array=@[path];
    PhotoVC * vc = [[PhotoVC alloc] init];
    vc.imgMArray = array;
    vc.isShowSave = YES;
    vc.curentPage = 0;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)openNewWindow:(NSString *)title content:(NSString *)content pathurl:(NSString *)pathurl httpurl:(NSString *)httpurl
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [_webView endEditing:YES];
                   });
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       CanShareVC * vc = [[CanShareVC alloc] init];
                       
                       ShareDomain * domain = [[ShareDomain alloc] init];
                       
                       domain.title = title;
                       
                       domain.pathurl = pathurl;
                       
                       domain.httpurl = httpurl;
                       
                       domain.content = title;
                       
                       vc.domain = domain;
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [self.navigationController pushViewController:vc animated:YES];
                                      });
                   });
}
@end
