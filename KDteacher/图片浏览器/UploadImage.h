//
//  UploadImage.h
//  OnlineRepairSystem
//
//  Created by 谢诚 on 15/11/23.
//  Copyright © 2015年 zs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UploadImage : NSObject

//图片
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString  *url;
//图片名
@property (nonatomic,strong) NSString *imageName;
//图片下标
@property (nonatomic,assign) int index;

@end
