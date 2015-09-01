//
//  feedBackViewController.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/1.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "feedBackViewController.h"

@interface feedBackViewController ()

@end

@implementation feedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈设置";
    //设置左边的返回按钮
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(gotoBack)];
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
-(void)submit{
    if ([self.textV.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"意见不能为空" message:@"请输入内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}
@end
