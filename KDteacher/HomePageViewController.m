//
//  HomePageViewController.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/8/27.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "HomePageViewController.h"
#import "setUpTableViewController.h"
#import "AFNetworking.h"
#import "KDConstants.h"
#import "UtilMethod.h"
#import "KGBaseDomain.h"
#import "MJExtension.h"
#import "ResMsgDomain.h"
#import "KGHttpService.h"
#import "CanShareVC.h"
#import "KeychainItemWrapper.h"
#import "MJExtension.h"
#import "UMSocial.h"
#import "MainDomain.h"

//#define SCREENHEIGHT   self.view.frame.size.height
#define NewMessageKey @"newMessage"

@interface HomePageViewController () <UMSocialUIDelegate>

@property (strong, nonatomic) NSString * newerMainURL;

@property (assign, nonatomic) NSInteger reqCount;

@end

@implementation HomePageViewController

//设置隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-48);
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-48)];
    
    [self.webView setScalesPageToFit:YES];
    self.webView.userInteractionEnabled = YES;
    self.webView.delegate = self;
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [self.view addSubview : activityIndicatorView] ;
    [self.webView setNeedsDisplayInRect:self.view.frame];
    [self.view addSubview: self.webView];
    NSURL *url = [NSURL URLWithString:Webview_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:3];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               
                               //转换NSURLResponse成为HTTPResponse
                               NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                               //获取headerfields
                               NSDictionary *fields = [HTTPResponse allHeaderFields];//原生NSURLConnection写法
                               // NSDictionary *fields = [operation.response allHeaderFields]; //afnetworking写法
//                               NSLog(@"fields = %@",[fields description]);
                               
                               //获取cookie方法1
                               // NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:url];
                               //获取cookie方法2
                               //NSString *cookieString = [[HTTPResponse allHeaderFields] valueForKey:@"Set-Cookie"];
                               //获取cookie方法3
                               NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                               for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//                                   NSLog(@"cookie=%@", cookie);
                               }
                           }];
    
    
    [self getNewerWebURL];
    

    //添加一个主页的按钮
    self.homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    CGFloat height=48;
    
    [self.homeBtn setImage:[UIImage imageNamed:@"zhuye2.png"] forState:UIControlStateNormal];
    [self.homeBtn setImage:[UIImage imageNamed:@"zhuye1.png"] forState:UIControlStateSelected];
    self.homeBtn.selected = YES;
    [self.homeBtn addTarget:self action:@selector(homeClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.homeBtn.frame = CGRectMake(0, 0, 80, 48);
    //添加一个通讯录按钮
    self.mailListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mailListBtn setImage:[UIImage imageNamed:@"tongxunlu2.png"] forState:UIControlStateNormal];
    [self.mailListBtn setImage:[UIImage imageNamed:@"tongxunlu1.png"] forState:UIControlStateSelected];
    [self.mailListBtn addTarget:self action:@selector(mailClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.mailListBtn.frame = CGRectMake(80, 0, 80, 48);
    //添加一个消息按钮
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.messageBtn setImage:[UIImage imageNamed:@"xiaoxi2.png"] forState:UIControlStateNormal];
    [self.messageBtn setImage:[UIImage imageNamed:@"xiaoxi1.png"] forState:UIControlStateSelected];
    [self.messageBtn addTarget:self action:@selector(messageClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.messageBtn.frame = CGRectMake(160, 0, 80, 48);
    //添加一个设置按钮
    self.setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setupBtn setImage:[UIImage imageNamed:@"shezhi2.png"] forState:UIControlStateNormal];
    [self.setupBtn setImage:[UIImage imageNamed:@"shezhi1.png"] forState:UIControlStateSelected];
    [self.setupBtn addTarget:self action:@selector(setupClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.setupBtn.frame = CGRectMake(240, 0, 80, 48);
 
    //添加一个视图好显示按钮
    self.myView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-48, SCREEN_WIDTH, 48)];
    self.myView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.myView addSubview:self.homeBtn];
    [self.myView addSubview:self.mailListBtn];
    [self.myView addSubview:self.messageBtn];
    [self.myView addSubview:self.setupBtn];
    [self.view addSubview:self.myView];
    [self.myView setHidden:YES];
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
}
//实现通知方法
-(void)ChangeData{
    [self.webView stringByEvaluatingJavaScriptFromString:@"G_jsCallBack.user_info_update()"];
}
-(void)ChangePassword{
    [self.webView stringByEvaluatingJavaScriptFromString:@"G_jsCallBack.user_info_updatepassword()"];
}
-(void)cancellation{
    
   [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:G_jsCallBack.userinfo_logout()"];
}
-(void)clearBuffer{
     
    [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:menu_dohome()"];
}
-(void)homeClicked:(UIButton *)homebtn{
    homebtn.selected = YES;
    self.messageBtn.selected = NO;
    self.setupBtn.selected = NO;
    self.mailListBtn.selected = NO;
    [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:menu_dohome()"];
    
    
}
-(void)mailClicked:(UIButton *)mailClick{
    mailClick.selected = YES;
    self.homeBtn.selected = NO;
    self.messageBtn.selected = NO;
    self.setupBtn.selected = NO;
    [self.webView stringByEvaluatingJavaScriptFromString:@"G_jsCallBack.QueueTeacher()"];
}
-(void)messageClicked:(UIButton *)messageBtn{
    messageBtn.selected = YES;
    self.homeBtn.selected = NO;
    self.mailListBtn.selected = NO;
    self.setupBtn.selected = NO;
    [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:G_jsCallBack.queryMyTimely_myList()"];
}
-(void)setupClicked:(UIButton *)setupBtn{
    setupBtn.selected = YES;
    self.homeBtn.selected = NO;
    self.mailListBtn.selected = NO;
    self.messageBtn.selected = NO;
    setUpTableViewController *setup = [[setUpTableViewController alloc]initWithNibName:@"setUpTableViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:setup];
    [self presentViewController:nav animated:YES completion:nil];
}
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//网页加载完时调用此方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取当前页面网址
   // [self.webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:Star_Js];
    
    [self.webView stringByEvaluatingJavaScriptFromString:Share_Js];
    
}
//网页加载失败时调用此方法
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"加载网页失败" message:@"请检查网络是否连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
//回调此方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSHTTPCookieStorage *myCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [myCookie cookies]) {
//        NSLog(@"cookie=%@", cookie);
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie]; // 保存
    }
    
       //得到当前访问页面的地址
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"urlString=%@",urlString);
    
    //先将这个字符串地址按://分割成两部分
    NSArray *urlArray = [urlString componentsSeparatedByString:@"/ios/"];
//    NSLog(@"urlArray=%@",urlArray);
    
    //获取最后一部分字符串
    NSString *subStr = [urlArray lastObject];
//    NSLog(@"subStr=%@",subStr);
    
    //把这个字符串用/分割
    NSArray *subArray = [subStr componentsSeparatedByString:@"/"];
    NSString *str1=subArray[0];
//    NSLog(@"模块名称: %@",str1);
    
    
        if ([str1 isEqualToString:Web_IOS_sessionid]) {//
            [KGHttpService sharedService].jssionID =subArray[1];
            [self.myView setHidden:NO];
            
             KeychainItemWrapper * wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"KeyChain" accessGroup:nil];
            NSString *status;
            if ([[NSUserDefaults standardUserDefaults] boolForKey:NewMessageKey]) {
                status = @"0";
            }else{
                status = @"2";
            }
            [[KGHttpService sharedService] submitPushTokenWithStatus:status success:^(NSString *msgStr) {
                [wrapper setObject:[KGHttpService sharedService].pushToken forKey:(__bridge id)kSecAttrAccount];
//                NSLog(@"msgStr=%@",msgStr);
            } faild:^(NSString *errorMsg) {
                
            }];

            if ([[KGHttpService sharedService].jssionID  isEqualToString:@""]) {
                [self.myView setHidden:YES];
            }
                return false;
            
        }else if ([str1 isEqualToString:Head_Pic]) {//
            [self UploadAvatar];
        
            
        }else if ([str1 isEqualToString:Image_Pic]) {//
        
            [self uploadAllImages];
        }else if ([str1 isEqualToString:Open_Window]) {

            NSString * dataStr = [self.webView stringByEvaluatingJavaScriptFromString:Share_Object];
            
            NSData * data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            
            ShareDomain * domain = [ShareDomain objectWithJSONData:data];
            
            CanShareVC * vc = [[CanShareVC alloc] init];
            
            vc.httpcontent = domain.httpurl;
            
            vc.mainTitle = domain.title;
            
            vc.sharecontent = domain.content;
            
            vc.imgUrl = domain.pathurl;
            
            [self presentViewController:vc animated:NO completion:nil];

        }else if (Share_Content && [urlString isEqualToString:@"http://120.25.212.44/px-rest/kd/ios/setShareContent"]) {
            
            NSString * dataStr = [self.webView stringByEvaluatingJavaScriptFromString:Share_Object];
            
            NSData * data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            
            ShareDomain * domain = [ShareDomain objectWithJSONData:data];
            
            if (domain.content == nil)
            {
                domain.content = @"分享:http://www.wenjienet.com/";
            }
            
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            
            [UMSocialData defaultData].extConfig.wechatSessionData.url = domain.httpurl;
            
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"55cc8dece0f55a2379004ba7"
                                              shareText:domain.content
                                             shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:domain.pathurl]]]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                               delegate:self];
        }
    
    return true;
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
    else
    {
        NSLog(@"%@",response);
    }
}

//上传头像的方法
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
-(void)UploadAvatar{
   
    // 判断是否支持相机
    self.myActionSheet = [[UIActionSheet alloc]
                   initWithTitle:nil
                   delegate:self
                   cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                   otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [self.myActionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == self.myActionSheet.cancelButtonIndex)
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
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
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

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
     image = [UtilMethod imageWithImageSimple:image scaledToSize:CGSizeMake(198.0, 198.0)];
        NSData *data;
            data = UIImageJPEGRepresentation(image, 0.5);
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
      NSString  *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        NSLog(@"filePath=%@",filePath);
     //上传图片的参数
    
       NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[KGHttpService sharedService].jssionID  forKey:@"JSESSIONID"];
        [parameters setObject:[NSNumber numberWithInteger:1] forKey:@"type"];
//上传图片的地址
        NSString *url = URL(G_baseServiceURL, G_rest_uploadFile_upload);
        //上传图片的方法
         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
       
        [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data
                                        name:@"file"
                                    fileName:filePath
                                    mimeType:@"image/jpeg/file"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
           //上传成功所处理的事情
            if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                //得到imgurl的地址
               NSString *imgUrls = [responseObject objectForKey:@"imgUrl"];
                NSLog(@"imgurl = %@",imgUrls);
                NSArray *imgSubuuid = [imgUrls componentsSeparatedByString:@"?uuid="];
              
                //得到它的uuid参数
                NSString *uuid = [imgSubuuid lastObject];
                NSLog(@"uuid=%@",uuid);
                //调用js的方法并传参数
                NSString *headJs = [NSString stringWithFormat:@"G_jsCallBack.selectHeadPic_callback_imgUrl('%@','%@');", imgUrls, uuid];
                [self.webView stringByEvaluatingJavaScriptFromString:headJs];
                //NSString *imgJs = [NSString stringWithFormat:@"G_jsCallBack.selectPic_callback_imgUrl('%@','%@');", imgUrls, uuid];
               // [self.webView stringByEvaluatingJavaScriptFromString:imgJs];
                
            } else {
                NSLog(@"failure:%@", baseDomain.ResMsg.message);
            }

            
            NSLog(@"Success: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}
//上传多张图片的方法
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
-(void)uploadAllImages{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
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
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
      //tempImg = [UtilMethod imageWithImageSimple:tempImg scaledToSize:CGSizeMake(120.0, 120.0)];
        NSData *data;
        data = UIImageJPEGRepresentation(tempImg, 0.1);
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        NSString  *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        NSLog(@"filePath=%@",filePath);
        //上传图片的参数
        
        NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[KGHttpService sharedService].jssionID  forKey:@"JSESSIONID"];
        [parameters setObject:[NSNumber numberWithInteger:1] forKey:@"type"];
        //上传图片的地址
        NSString *url = URL(G_baseServiceURL, G_rest_uploadFile_upload);
        //上传图片的方法
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data
                                        name:@"file"
                                    fileName:filePath
                                    mimeType:@"image/jpeg/file"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            KGBaseDomain * baseDomain = [KGBaseDomain objectWithKeyValues:responseObject];
            //上传成功所处理的事情
            if([baseDomain.ResMsg.status isEqualToString:String_Success]) {
                //得到imgurl的地址
                NSString *imgUrls = [responseObject objectForKey:@"imgUrl"];
                NSLog(@"imgurl = %@",imgUrls);
                NSArray *imgSubuuid = [imgUrls componentsSeparatedByString:@"?uuid="];
                
                //得到它的uuid参数
                NSString *uuid = [imgSubuuid lastObject];
                NSLog(@"uuid=%@",uuid);
                //调用js的方法并传参数
               
                NSString *imgJs = [NSString stringWithFormat:@"G_jsCallBack.selectPic_callback_imgUrl('%@','%@');", imgUrls, uuid];
                [self.webView stringByEvaluatingJavaScriptFromString:imgJs];
                
            } else {
                NSLog(@"failure:%@", baseDomain.ResMsg.message);
            }
            
            NSLog(@"Success: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

}
    
   
}

#pragma mark - 请求最新网页数据
- (void)getNewerWebURL
{
    [[KGHttpService sharedService] getNewerMainUrl:^(id newurl)
    {
        MainDomain * domain = [MainDomain objectWithKeyValues:newurl];
        
        self.newerMainURL = domain.url;
        
        NSUserDefaults *defu = [NSUserDefaults standardUserDefaults];
        
        [defu setObject:domain.url forKey:@"newurl"];
        
        [defu synchronize];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[defu objectForKey:@"newurl"]]]];
        
        [self httphandler];
    }];
    
}

- (void)httphandler
{
//    self.reqCount ++;
    if (self.newerMainURL == nil)
    {
        [self getNewerWebURL];
    }
    else
    {
        NSLog(@"请求十次还没请求到数据，算了不来了");
    }
}

@end
