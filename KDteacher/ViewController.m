//
//  ViewController.m
//  KDteacher
//
//  Created by liumingquan on 15/8/13.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
//设置隐藏状态栏
- (BOOL)prefersStatusBarHidden

{
    
    return YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect buonds=self.view.frame;
//    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    webView = [[UIWebView alloc] initWithFrame:buonds];

    [webView setScalesPageToFit:YES];
    [webView setNeedsDisplayInRect:buonds];
    NSString *url=@"http://www.wenjienet.com/px-rest/kd/index.html";
   // url=@"http://www.baidu.com";
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
