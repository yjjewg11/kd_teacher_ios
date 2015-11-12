//
//  CanShareVC.m
//  KDteacher
//
//  Created by Mac on 15/11/11.
//  Copyright © 2015年 liumingquan. All rights reserved.
//

#import "CanShareVC.h"
#import "UMSocial.h"

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
    
    [UIView setAnimationsEnabled:NO];
    
    self.titleLbl.text = self.mainTitle;
 
    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.httpcontent]];
    
    [self.webView loadRequest:req];
}

- (IBAction)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (IBAction)load:(id)sender
{
    if (self.sharecontent == nil)
    {
        self.sharecontent = @"http://www.wenjienet.com/";
    }
    
    //微博
    [UMSocialData defaultData].extConfig.sinaData.urlResource.resourceType = UMSocialUrlResourceTypeImage;
    [UMSocialData defaultData].extConfig.sinaData.shareText = self.httpcontent;
    //微信
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.httpcontent;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.httpcontent;
    //qq
    [UMSocialData defaultData].extConfig.qqData.urlResource.resourceType = UMSocialUrlResourceTypeImage;
    [UMSocialData defaultData].extConfig.qqData.url = self.httpcontent;
//    [UMSocialData defaultData].extConfig.qqData.shareText = self.httpcontent;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55cc8dece0f55a2379004ba7"
                                      shareText:self.sharecontent
                                     shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgUrl]]]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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

@end
