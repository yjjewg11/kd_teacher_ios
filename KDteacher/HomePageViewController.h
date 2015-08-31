//
//  HomePageViewController.h
//  KDteacher
//
//  Created by WenJieKeJi on 15/8/27.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UIViewController<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIView *myView;
@property(nonatomic,strong)UIButton *homeBtn;
@property(nonatomic,strong)UIButton *mailListBtn;
@property(nonatomic,strong)UIButton *messageBtn;
@property(nonatomic,strong)UIButton *setupBtn;
@property(nonatomic,strong) UIActionSheet *myActionSheet;
@end
