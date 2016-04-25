//
//  PhotoVC.m
//  Tenement
//
//  Created by CxDtreeg on 15/3/2.
//  Copyright (c) 2015年 funi. All rights reserved.
//

#import "PhotoVC.h"


@interface PhotoVC ()<UIActionSheetDelegate,FuniImageBrowseViewDelegate>

@end

@implementation PhotoVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imgMArray = [[NSMutableArray alloc] init];
        _attachemnMArray = [[NSMutableArray alloc] init];
        _curentPage = 0;
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_myBlock) {
        NSMutableArray * imgArray = [[NSMutableArray alloc] init];
        for (KGAttachment * model in _attachemnMArray) {
            [imgArray addObject:model.image];
        }
        _myBlock(imgArray);
    }
}

#pragma mark - AppInfoViewNavViewDelegate
- (void)funViewClicked{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"要删除这张照片吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){//确定是0
        [_attachemnMArray removeObjectAtIndex:_curentPage];
        if (_attachemnMArray.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self initContentView];
        _curentPage = 0;
        
        self.title = [NSString stringWithFormat:@"1/%ld", (long)_attachemnMArray.count];
    }
}

#pragma mark - FuniImageBrowseViewDelegate
- (void)singleTapEvent:(KGAttachment *)attachment{

    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

- (void)browseIndex:(NSInteger)index attach:(KGAttachment *)attach{
    _curentPage = index;
    self.title = [NSString stringWithFormat:@"%ld/%ld",(long)(index + 1), (long)_attachemnMArray.count];
}

/**
 *  初始化装载image的对象数组
 */
- (void)initAttachemnMArray{
    for (int i = 0; i < _imgMArray.count; ++ i) {
        KGAttachment * attachemnt = [[KGAttachment alloc] init];
        if([_imgMArray[i] isKindOfClass:[UIImage class]]) {
            attachemnt.image = _imgMArray[i];
        } else {
            attachemnt.imageUrl = _imgMArray[i];
        }
        
        [_attachemnMArray addObject:attachemnt];
    }
}

/**
 *  初始化图片浏览视图
 */
- (void)initContentView{
    _imgBrowseView = [[KGImageBrowseView alloc] initImageBrowse:CGRectMake(0, 64, APPWINDOWWIDTH, APPWINDOWHEIGHT - 64) attach:_attachemnMArray size:@"12" isPageing:YES];
    _imgBrowseView._delegate = self;
    _imgBrowseView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_imgBrowseView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    
    if(_isShowDel) {
        UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(funViewClicked)];
        rightBarItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    
    if(_isShowSave) {
        UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(savePhotoToLocal)];
        rightBarItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    
    self.title = [NSString stringWithFormat:@"1/%ld", (long)_imgMArray.count];
    
    [self initAttachemnMArray];
    [self initContentView];
    [_imgBrowseView resetTableViewCellIndex:_curentPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)savePhotoToLocal {

    UIImageWriteToSavedPhotosAlbum([_imgBrowseView getCurrentImage], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
