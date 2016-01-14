//
//  feedBackViewController.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/1.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "feedBackViewController.h"
#import "UMFeedback.h"

@interface feedBackViewController ()

@end

@implementation feedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
    titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
    titleLabel.textAlignment = 1;
    titleLabel.text = @"意见反馈";  //设置标题
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = COLOR(8, 122, 203, 1);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(gotoBack)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    //设置右边的提交按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightButton;
    //设置视图的背景色
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 320, 80)];
    label.text = @"请提出您的意见，让我们为您更好的服务!";
    label.font = [UIFont fontWithName:nil size:15];
    label.textAlignment = 1;
    self.textV = [[UITextView alloc]initWithFrame:CGRectMake(10, 120, 300, 200)];
    self.textV.text = nil;
    self.textV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
    [self.view addSubview:self.textV];
}
-(void)gotoBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)submit
{
    if ([self.textV.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"意见不能为空" message:@"请输入内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        NSDictionary *dictionary = @{@"content":self.textV.text};
       [[UMFeedback sharedInstance] post:dictionary completion:^(NSError *error) {
           if (error==nil) {
               NSLog(@"提交成功");
               [self dismissViewControllerAnimated:YES completion:nil];
           }
        }];
    }
    
}
@end
