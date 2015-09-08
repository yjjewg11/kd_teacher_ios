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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
    titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
    titleLabel.textAlignment = 1;
    titleLabel.text = @"关于我们";  //设置标题
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = COLOR(8, 122, 203, 1);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    
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
