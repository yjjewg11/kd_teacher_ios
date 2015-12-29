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
#import "UMSocial.h"
#import "ZYQAssetPickerController.h"
#import "setUpTableViewController.h"
#import "CanShareVC.h"

#define NewMessageKey @"newMessage"

@interface HomeVC () <UIWebViewDelegate,UIActionSheetDelegate,UMSocialUIDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,TestJSExport,UITabBarDelegate>
{
    NSString * _webUrl;
    
    JSContext * _context;
    
    UIWebView * _webView;
    
    __weak IBOutlet UITabBar *tabbar;
    
    __weak IBOutlet UITabBarItem *item1;
    
    __weak IBOutlet UITabBarItem *item2;
    
    __weak IBOutlet UITabBarItem *item3;
    
    __weak IBOutlet UITabBarItem *item4;
    
    NSString * _jessionid;
    
    UIActionSheet * _myActionSheet;
    
}

@property (strong, nonatomic) SDRotationLoopProgressView * loadingView;

@end

@implementation HomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //给tabbar创建按钮
    [self createTabbarItems];
    
    //获取最新老师版地址
    [self getNewerWebURL];
    
    [self initWebView];
    
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
        MainDomain * domain = [MainDomain objectWithKeyValues:newurl];
        
        _webUrl = domain.url;
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
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
    
    _webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    
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
-(void)ChangeData
{
    [_webView stringByEvaluatingJavaScriptFromString:@"G_jsCallBack.user_info_update()"];
}
-(void)ChangePassword
{
    [_webView stringByEvaluatingJavaScriptFromString:@"G_jsCallBack.user_info_updatepassword()"];
}
-(void)cancellation
{
    [_webView stringByEvaluatingJavaScriptFromString:@"javascript:G_jsCallBack.userinfo_logout()"];
}
-(void)clearBuffer
{
    [_webView stringByEvaluatingJavaScriptFromString:@"javascript:menu_dohome()"];
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
    CanShareVC * vc = [[CanShareVC alloc] init];
    
    vc.httpcontent = httpurl;
    
    vc.mainTitle = title;
    
    vc.sharecontent = content;
    
    vc.imgUrl = pathurl;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)getJsessionid:(NSString *)jessid
{
    return _jessionid;
}

- (void)setShareContent:(NSString *)title content:(NSString *)content pathurl:(NSString *)pathurl httpurl:(NSString *)httpurl
{
    ShareDomain * domain = [[ShareDomain alloc] init];
    
    domain.title = title;
    
    domain.pathurl = pathurl;
    
    domain.httpurl = httpurl;
    
    domain.content = title;
    
    //微博
    [UMSocialData defaultData].extConfig.sinaData.urlResource.resourceType = UMSocialUrlResourceTypeImage;
    [UMSocialData defaultData].extConfig.sinaData.shareText = domain.httpurl;
    //微信
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = domain.httpurl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = domain.httpurl;
    //qq
    [UMSocialData defaultData].extConfig.qqData.urlResource.resourceType = UMSocialUrlResourceTypeImage;
    [UMSocialData defaultData].extConfig.qqData.url = domain.httpurl;
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"55be15a4e0f55a624c007b24" shareText:domain.content shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:domain.pathurl]]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil] delegate:self];
}

- (void)selectImgPic:(NSString *)groupuuid
{
    [self uploadAllImages];
}

- (void)selectHeadPic
{
    _myActionSheet = [[UIActionSheet alloc]
                      initWithTitle:nil
                      delegate:self
                      cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                      otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [_myActionSheet showInView:self.view];
}

#pragma mark - 图片相关
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
        
        [self presentViewController:picker animated:YES completion:nil];
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
    [self presentViewController:picker animated:YES completion:nil];
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
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
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
    
    [self presentViewController:picker animated:YES completion:NULL];
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
            
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

@end