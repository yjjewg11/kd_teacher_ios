//
//  HomeVC.m
//  KDteacher
//
//  Created by Mac on 15/12/28.
//  Copyright © 2015年 liumingquan. All rights reserved.
//

#import "HomeVC.h"
#import "KGHttpService.h"
#import "MainDomain.h"
#import "MJExtension.h"
#import "SDRotationLoopProgressView.h"
#import "KeychainItemWrapper.h"
#import "KDConstants.h"
#import "ShareDomain.h"
#import "UIImageView+WebCache.h"
#import <UShareUI/UShareUI.h>
#import "ZYQAssetPickerController.h"
#import "setUpTableViewController.h"
#import "CanShareVC.h"
#import "FPImagePickerVC.h"
#import "HLActionSheet.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "PhotoVC.h"
#define NewMessageKey @"newMessage"

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

@interface HomeVC () <UIWebViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,TestJSExport,UITabBarDelegate>
{
    NSString * _webUrl;
    
    JSContext * _context;
    
    UIWebView * _webView;
    NSTimer *_timer;	// 用于UIWebView保存图片
    int _gesState;	  // 用于UIWebView保存图片
    NSString *_imgURL;  // 用于UIWebView保存图片
    BOOL longPress;
    
    
    NSString * contentString;
    
    NSString * shareurl;
    
    
    __weak IBOutlet UITabBar *tabbar;
    
    __weak IBOutlet UITabBarItem *item1;
    
    __weak IBOutlet UITabBarItem *item2;
    
    __weak IBOutlet UITabBarItem *item3;
    
    __weak IBOutlet UITabBarItem *item4;
    
    NSString * _jessionid;
    
    UIActionSheet * _myActionSheet;
    NSString * _selectImgForCallBack_callback;
    NSInteger _selectImgForCallBack_maxConut;
    NSInteger _selectImgForCallBack_quality;
    
    
}
@property (assign, nonatomic) NSInteger sheetType;  //标记打开的actionsheet是否可以识别二维码
@property (strong, nonatomic) SDRotationLoopProgressView * loadingView;

@end

@implementation HomeVC

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}


-(void)viewDidAppear:(BOOL)animated
{
    
       [ super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
     self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //给tabbar创建按钮
    [self createTabbarItems];
    
    //获取最新老师版地址
    [self getNewerWebURL];
    
    [self initWebView];
    
    [self regNotification];
    
    if([[[UIDevice
          currentDevice] systemVersion] floatValue]>=8.0)
    {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    
    
    //二维码长按手势
    UILongPressGestureRecognizer *longtapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longtap:)];
    
    [_webView addGestureRecognizer:longtapGesture];
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



- (void)regNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didGetPhotoData:) name:@"didgetphotodata" object:nil];
    
    //添加一个通知修改资料
    NSNotificationCenter *changeData = [NSNotificationCenter defaultCenter];
    [changeData addObserver:self
                   selector:@selector(ChangeData)
                       name:@"changeData"
                     object:nil];
    //添加一个通知修改密码
    NSNotificationCenter *changePassword = [NSNotificationCenter defaultCenter];
    [changePassword addObserver:self
                       selector:@selector(ChangePassword)
                           name:@"changePassword"
                         object:nil];
    //添加一个通知注销
    NSNotificationCenter *cancellation = [NSNotificationCenter defaultCenter];
    [cancellation addObserver:self
                     selector:@selector(cancellation)
                         name:@"cancellation"
                       object:nil];
    //添加一个通知注销
    NSNotificationCenter *clearBuffer = [NSNotificationCenter defaultCenter];
    [clearBuffer addObserver:self
                    selector:@selector(clearBuffer)
                        name:@"clearBuffer"
                      object:nil];
    
    NSNotificationCenter *hidentabbar = [NSNotificationCenter defaultCenter];
    [hidentabbar addObserver:self
                    selector:@selector(hidentabbar)
                        name:@"hidentabbar"
                      object:nil];
    
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - 获取最新url地址
- (void)getNewerWebURL
{
    [self showLoadView];
    
    [[KGHttpService sharedService] getNewerMainUrl:^(id newurl)
    {
        
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        
        app.mainDomain = [MainDomain objectWithKeyValues:newurl];

//        _webUrl = domain.url;
     
//        app.mainDomain.url = @"https://www.wenjienet.com/px-rest/kd/index1.html?v=2281232333";
//        NSLog(@"webtest == %@",_webUrl);
        
        NSLog(@"webUrl == %@",app.mainDomain.url);

        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:app.mainDomain.url]]];
    }
    faild:^(NSString *errMessage)
    {
        _jessionid = @"";
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://kd.wenjienet.com/px-rest/kd/index.html?v=1228"]]];
    }];
}

#pragma mark - 初始化webview
- (void)initWebView
{
    _webView = [[UIWebView alloc] init];
    
    _webView.delegate = self;
    
    _webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50);
    
    _webView.scrollView.bounces = NO;
    
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_webView];
    
    _webView.hidden = YES;
}

#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _context = [[JSContext alloc] init];
    
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //打印异常
    _context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"异常:%@", exceptionValue);
    };
    
    //以 JSExport 协议关联 native 的方法
    _context[@"JavaScriptCall"] = self;

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

#pragma mark - 创健 tabbaritem
- (void)createTabbarItems
{
    tabbar.hidden = YES;
    tabbar.delegate = self;
    
    item1.title = @"主页";
    item1.tag = 0;
    item1.image = [UIImage imageNamed:@"hxuexiao.png"];
    item1.selectedImage = [UIImage imageNamed:@"hxuexiao2.png"];
    
    item2.title = @"通讯录";
    item2.tag = 1;
    item2.image = [UIImage imageNamed:@"htongxunlu2.png"];
    item2.selectedImage = [UIImage imageNamed:@"htongxunlu1.png"];
    
    item3.title = @"消息";
    item3.tag = 2;
    item3.image = [UIImage imageNamed:@"hxiaoxi.png"];
    item3.selectedImage = [UIImage imageNamed:@"hxiaoxi2.png"];
    
    item4.title = @"设置";
    item4.tag = 3;
    item4.image = [UIImage imageNamed:@"hwode.png"];
    item4.selectedImage = [UIImage imageNamed:@"hwode3.png"];
}

#pragma mark - 通知方法
//实现通知方法
- (void)ChangeData
{
    [_webView stringByEvaluatingJavaScriptFromString:@"G_jsCallBack.user_info_update()"];
}

- (void)ChangePassword
{
    [_webView stringByEvaluatingJavaScriptFromString:@"G_jsCallBack.user_info_updatepassword()"];
}

- (void)cancellation
{
    [_webView stringByEvaluatingJavaScriptFromString:@"javascript:G_jsCallBack.userinfo_logout()"];
}

- (void)clearBuffer
{
    [self getNewerWebURL];
    [_webView stringByEvaluatingJavaScriptFromString:@"javascript:menu_dohome()"];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

-(void)hidentabbar
{
    tabbar.hidden = YES;
}


#pragma mark - js调用方法
/**
 *  登录成功要调这个
 *
 *  @param jessid
 */
- (void)jsessionToPhone:(NSString *)jessid
{
    tabbar.hidden = NO;
    
    _jessionid = jessid;
    
    if (_jessionid == nil)
    {
        _jessionid = @"";
    }
    
    [KGHttpService sharedService].jssionID = _jessionid;
    
    NSMutableDictionary * cookieDic = [NSMutableDictionary dictionary];
    [cookieDic setObject:@"JSESSIONID" forKey:NSHTTPCookieName];
    [cookieDic setObject:_jessionid forKey:NSHTTPCookieValue];
    [cookieDic setObject:@"wenjienet.com" forKey:NSHTTPCookiePath];
    [cookieDic setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieDic setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie * cookieUser = [NSHTTPCookie cookieWithProperties:cookieDic];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieUser];
    
    KeychainItemWrapper * wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeyChain" accessGroup:nil];
    
    NSString *status;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:NewMessageKey])
    {
        status = @"0";
    }
    else
    {
        status = @"2";
    }
    
    [[KGHttpService sharedService] submitPushTokenWithStatus:status success:^(NSString *msgStr)
    {
        [wrapper setObject:[KGHttpService sharedService].pushToken forKey:(__bridge id)kSecAttrAccount];
    }
    faild:^(NSString *errorMsg)
    {
        
    }];
}

- (void)hideLoadingDialog:(NSString *)msg
{
    //do sth
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

- (NSString *)getJsessionid:(NSString *)jessid
{
    return _jessionid;
}

- (void)setShareContent:(NSString *)title content:(NSString *)content pathurl:(NSString *)pathurl httpurl:(NSString *)httpurl
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_webView endEditing:YES];
    });
    
    ShareDomain * domain = [[ShareDomain alloc] init];
    
    domain.title = title;
    
    domain.pathurl = pathurl;
    
    domain.httpurl = httpurl;
    
    domain.content = title;
    
    NSArray *titles = @[@"微博",@"微信",@"朋友圈",@"QQ好友",@"复制链接"];
    NSArray *imageNames = @[@"xinlang",@"weixin",@"pyquan",@"qq",@"fuzhilianjie"];
    HLActionSheet *sheet = [[HLActionSheet alloc] initWithTitles:titles iconNames:imageNames];
    [sheet showActionSheetWithClickBlock:^(NSInteger btnIndex)
    {
        switch (btnIndex)
        {
            case 0:
            {
                [self handelShareWithShareType:UMSocialPlatformType_Sina domain:domain];
            }
                break;
                
            case 1:
            {
                [self handelShareWithShareType:UMSocialPlatformType_WechatSession domain:domain];
            }
                break;
                
            case 2:
            {
                [self handelShareWithShareType:UMSocialPlatformType_WechatTimeLine domain:domain];
            }
                break;
                
            case 3:
            {
                [self handelShareWithShareType:UMSocialPlatformType_QQ domain:domain];
            }
                break;
                
            case 4:
            {
                UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = domain.httpurl;
                //提示复制成功
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已复制分享链接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [av show];
                });
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
}

#pragma mark - 处理分享操作
- (void)handelShareWithShareType:(UMSocialPlatformType)shareType domain:(ShareDomain *)domain
{
   contentString = domain.title;
    
    shareurl = domain.httpurl;
    
    
    if(!shareurl || [shareurl length] == 0)
    {
        shareurl = @"http://www.wenjienet.com";
    }
    
    
    [self shareWebPageToPlatformType:shareType];
    return;
    
//    
//    //微信title设置方法：
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = domain.title;
//    
//    //朋友圈title设置方法：
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = domain.title;
//    [UMSocialWechatHandler setWXAppId:@"wx6699cf8b21e12618" appSecret:@"639c78a45d012434370f4c1afc57acd1" url:domain.httpurl];
//    [UMSocialData defaultData].extConfig.qqData.title = domain.title;
//    [UMSocialData defaultData].extConfig.qqData.url = domain.httpurl;
//    
//    if (shareType == UMShareToSina)
//    {
//        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",contentString,shareurl];
//        [UMSocialData defaultData].extConfig.sinaData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:shareurl];
//    }
//    
//    //设置分享内容，和回调对象
//    [[UMSocialControllerService defaultControllerService] setShareText:contentString shareImage:[UIImage imageNamed:@"sharelogo"] socialUIDelegate:self];
//    
//    UMSocialSnsPlatform * snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareType];
//    
//    snsPlatform.snsClickHandler(self, [UMSocialControllerService defaultControllerService],YES);
}



- (void)selectHeadPic:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_webView endEditing:YES];
    });
    
    
    _myActionSheet = [[UIActionSheet alloc]
                      initWithTitle:nil
                      delegate:self
                      cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                      otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
      self.sheetType = 0;
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_myActionSheet showInView:self.view];
    });
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
        
        switch (buttonIndex)
        {
            case 0:  //打开照相机拍照
                [self takePhoto];
                break;
                
            case 1:  //打开本地相册
                [self LocalPhoto];
                break;
        }

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

//开始拍照
-(void)takePhoto
{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        //主线程更新ui
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self presentViewController:picker animated:YES completion:nil];
        });
    }
    else
    {
        
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self presentViewController:picker animated:YES completion:nil];
    });
    
}

//上传头像
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(198.0, 198.0)];
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.5);
        
        //转base64
        NSString * imgBase64Str = [data base64EncodedStringWithOptions:0];
        
        NSString * commitStr = [NSString stringWithFormat:@"%@%@",@"data:image/png;base64,",imgBase64Str];
        
        NSString *imgJs = [NSString stringWithFormat:@"javascript:G_jsCallBack.selectHeadPic_callback('%@')", commitStr];
        
        [_webView stringByEvaluatingJavaScriptFromString:imgJs];
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
        //关闭相册界面
        
    }
}

- (void)uploadAllImages
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self presentViewController:picker animated:YES completion:NULL];
                   });
    
    
}

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i=0; i<assets.count; i++)
    {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        //tempImg = [UtilMethod imageWithImageSimple:tempImg scaledToSize:CGSizeMake(120.0, 120.0)];
        NSData *data;
        data = UIImageJPEGRepresentation(tempImg, 0.1);
        
        //转base64
        NSString * imgBase64Str = [data base64EncodedStringWithOptions:0];
        
        NSString * commitStr = [NSString stringWithFormat:@"%@%@",@"data:image/png;base64,",imgBase64Str];
        
        NSString *imgJs = [NSString stringWithFormat:@"javascript:G_jsCallBack.selectPic_callback('%@')", commitStr];
        
        [_webView stringByEvaluatingJavaScriptFromString:imgJs];
    }
}

- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

#pragma mark - tabbar代理
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag)
    {
        case 0:
        {
            [_webView stringByEvaluatingJavaScriptFromString:@"javascript:menu_dohome()"];
        }
            break;
        case 1:
        {
            [_webView stringByEvaluatingJavaScriptFromString:@"G_jsCallBack.QueueTeacher()"];
        }
            break;
        case 2:
        {
            [_webView stringByEvaluatingJavaScriptFromString:@"javascript:G_jsCallBack.queryMyTimely_myList()"];
        }
            break;
        case 3:
        {
            setUpTableViewController *setup = [[setUpTableViewController alloc]initWithNibName:@"setUpTableViewController" bundle:nil];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setup];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self presentViewController:nav animated:YES completion:nil];
                           });
        }
            break;
            
        default:
            break;
    }
}
 -(void)jsessionToPhoneTel:(NSString *)tel
{
    
    [[NSUserDefaults standardUserDefaults] setObject:tel forKey:@"personTel"];
}
;

- (void)selectImgPic:(NSString *)groupuuid
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [_webView endEditing:YES];
                   });
    [self selectImgForCallBack:@"G_jsCallBack.selectPic_callback" maxConut:@"0" quality:@"2028"];
//    [self uploadAllImages];
}
- (void)selectImgForCallBack:(NSString *)callback maxConut:(NSString *)maxConut quality:(NSString *)quality{
    _selectImgForCallBack_callback=callback;
    if([callback length]<1){
        _selectImgForCallBack_callback=@"G_jsCallBack.selectPic_callback";
    }
    
    //quality 单位k
    _selectImgForCallBack_maxConut=[maxConut integerValue];
    _selectImgForCallBack_quality=[quality integerValue]*1024;
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                        [self.navigationController pushViewController:[[FPImagePickerVC alloc] init] animated:YES];
                   });
  

}
//获取到了图片
- (void)didGetPhotoData:(NSNotification *)noti
{
    NSArray * urls = noti.object;
    
    for (NSInteger i=0; i<urls.count; i++)
    {
        [self startUpLoad:urls[i] count:urls.count];
      
    }
}
#pragma mark - 开始上传
- (void)startUpLoad: (NSURL *) localUrl count:(NSInteger) count
{
    ALAssetsLibrary * library=[HomeVC defaultAssetsLibrary];
  
    [library assetForURL:localUrl resultBlock:^(ALAsset *asset)
     {
         
         if(asset==nil){
            
             return;
         }
         //获取大图
         UIImage * tempImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
         
         
         NSData *data = UIImageJPEGRepresentation(tempImg, 0.5);
         if(_selectImgForCallBack_quality>0&&[data length]>_selectImgForCallBack_quality){
             NSLog(@"_selectImgForCallBack_quality=%ld,data.length=%ld",_selectImgForCallBack_quality,[data length]);
             data=UIImageJPEGRepresentation(tempImg, 0.1);
         }
         //转base64
         NSString * imgBase64Str = [data base64EncodedStringWithOptions:0];
         
         NSString * commitStr = [NSString stringWithFormat:@"%@%@",@"data:image/png;base64,",imgBase64Str];
         
         NSString *imgJs = [NSString stringWithFormat:@"javascript:%@('%@','%ld')",_selectImgForCallBack_callback, commitStr,count];
         
         [_webView stringByEvaluatingJavaScriptFromString:imgJs];

         
           }
                 failureBlock:^(NSError *error)
     {
         NSLog(@"根据local url 查找失败");
     }];
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



- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *userinfo =result;
        NSString *message = [NSString stringWithFormat:@"name: %@\n icon: %@\n gender: %@\n",userinfo.name,userinfo.iconurl,userinfo.gender];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UserInfo"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    
    //创建网页内容对象
//    NSString* thumbURL =  @"https://www.wenjienet.com/px-rest/i/denglulogo.png";
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
   
   NSString*  thumbURL=G_shareImageUrl;
    
    if( app.mainDomain&& app.mainDomain.shareImgUrl){
        thumbURL= app.mainDomain.shareImgUrl;
    }
    
//     NSLog(@"share title content=%@,thumbUrl=%@ == %@",contentString,thumbURL);
//    shareurl=@"http://mobile.umeng.com/social";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:contentString descr:contentString thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = shareurl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        UIAlertView * alertView;
        NSString * string;
        
        
        if (error) {
            string = @"分享失败";
            if(error.code==2008){
                string=@"应用未安装";
            }
            NSLog(@"************Share fail with error %@*********",error);
            
            
        }else{
            string = @"分享成功";
            NSLog(@"response data is %@",data);
            
            
        }
        
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [alertView show];
                       });
    }];
}
@end
