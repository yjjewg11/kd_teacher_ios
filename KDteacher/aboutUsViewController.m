//
//  aboutUsViewController.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/1.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "aboutUsViewController.h"

@interface aboutUsViewController ()

@end

@implementation aboutUsViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftButton;

    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(60, self.view.bounds.origin.y+150, 200, 100)];
    iv.image = [UIImage imageNamed:@"logo.png"];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(80, self.view.bounds.origin.y+150+200, 160, 100)];
    imageV.image = [UIImage imageNamed:@"erweimaweizi.png"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageV];
    [self.view addSubview:iv];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
