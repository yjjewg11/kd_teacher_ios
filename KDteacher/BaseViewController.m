//
//  BaseViewController.m
//  kindergartenApp
//
//  Created by You on 15/7/15.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
    [MobClick beginLogPageView:cName];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
    [MobClick endLogPageView:cName];
}

- (SDRotationLoopProgressView *)loadingView
{
    if (_loadingView == nil)
    {
        _loadingView = [SDRotationLoopProgressView progressView];
    }
    return _loadingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 菊花相关
- (void)showLoadView
{
    self.loadingView.frame = CGRectMake(0, 0, 100 * KWidth_Scale, 100 * KWidth_Scale);
    
    self.loadingView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 - 64);
    
    [self.view addSubview: self.loadingView];

    [self.view bringSubviewToFront:self.loadingView];
}

- (void)hidenLoadView
{
    [self.loadingView removeFromSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
