//
//  HomePageViewController.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/8/27.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "HomePageViewController.h"
#import "setUpTableViewController.h"
@interface HomePageViewController ()

@end

@implementation HomePageViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    
    [self.webView setScalesPageToFit:YES];
    self.webView.delegate = self;
    [self.webView setNeedsDisplayInRect:self.view.bounds];
    NSString *url=@"http://jz.wenjienet.com/px-rest/kd/index.html";
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.view addSubview: self.webView];
    [self.webView loadRequest:request];
    //添加一个主页的按钮
    self.homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [self.homeBtn setImage:[UIImage imageNamed:@"zhuye2.png"] forState:UIControlStateNormal];
    [self.homeBtn setImage:[UIImage imageNamed:@"zhuye1.png"] forState:UIControlStateSelected];
    self.homeBtn.selected = YES;
    [self.homeBtn addTarget:self action:@selector(homeClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.homeBtn.frame = CGRectMake(0, 0, 80, 50);
    //添加一个通讯录按钮
    self.mailListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mailListBtn setImage:[UIImage imageNamed:@"tongxunlu2.png"] forState:UIControlStateNormal];
    [self.mailListBtn setImage:[UIImage imageNamed:@"tongxunlu1.png"] forState:UIControlStateSelected];
    [self.mailListBtn addTarget:self action:@selector(mailClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.mailListBtn.frame = CGRectMake(80, 0, 80, 50);
    //添加一个消息按钮
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.messageBtn setImage:[UIImage imageNamed:@"xiaoxi2.png"] forState:UIControlStateNormal];
    [self.messageBtn setImage:[UIImage imageNamed:@"xiaoxi1.png"] forState:UIControlStateSelected];
    [self.messageBtn addTarget:self action:@selector(messageClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.messageBtn.frame = CGRectMake(160, 0, 80, 50);
    //添加一个设置按钮
    self.setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setupBtn setImage:[UIImage imageNamed:@"shezhi2.png"] forState:UIControlStateNormal];
    [self.setupBtn setImage:[UIImage imageNamed:@"shezhi1.png"] forState:UIControlStateSelected];
    [self.setupBtn addTarget:self action:@selector(setupClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.setupBtn.frame = CGRectMake(240, 0, 80, 50);

    //添加一个视图好显示按钮
    self.myView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-80, 320, 80)];
    self.myView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.myView addSubview:self.homeBtn];
    [self.myView addSubview:self.mailListBtn];
    [self.myView addSubview:self.messageBtn];
    [self.myView addSubview:self.setupBtn];
    [self.view addSubview:self.myView];
    [self.myView setHidden:YES];
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
    [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:G_jsCallBack.QueueTeacher()"];
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
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取当前页面网址
    NSString *currentURL = [self.webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
     NSLog(@"currentURL=%@",currentURL);
    //获取当前页面标题
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"G_jsCallBack.setIosApp()"];
    NSLog(@"title=%@",title);
    
}
//回调
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //得到当前访问页面的地址
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString=%@",urlString);
    //先将这个字符串地址按://分割成两部分
    NSArray *urlArray = [urlString componentsSeparatedByString:@"://"];
    NSLog(@"urlArray=%@",urlArray);
    //获取最后一部分字符串
    NSString *subStr = [urlArray lastObject];
    NSLog(@"subStr=%@",subStr);
    //把这个字符串用/分割
    NSArray *subArray = [subStr componentsSeparatedByString:@"/"];
    //遍历数组，如果字符串等于sessionid就执行方法
    for (NSString *str in subArray) {
        if ([str isEqualToString:@"sessionid"]) {
            [self.myView setHidden:NO];
            return false;
        }else if([str isEqualToString:@"selectHeadPic"]){
            [self UploadAvatar];
            [self.webView stringByEvaluatingJavaScriptFromString:@"G_jsCallBack.selectPic_callback(base64"];
        }
        
    }
    return true;
}
//上传头像的方法
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
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        
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
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
