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

@interface CanShareVC () <UMSocialUIDelegate>

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

@end
