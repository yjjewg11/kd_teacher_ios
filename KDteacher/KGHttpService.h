//
//  KGHttpService.h
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/15.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "xxNetworking.h"

@interface KGHttpService : NSObject
@property (strong, nonatomic) NSString * pushToken;
@property(nonatomic,strong)NSString *jssionID;
+ (KGHttpService *)sharedService;
- (void)submitPushTokenWithStatus:(NSString *)status success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild;

- (void)getNewerMainUrl:(void(^)(id newurl))success faild:(void(^)(NSString *errMessage))faild;

@end
