//
//  xxNetworking.h
//  PanguDistributor
//
//  Created by GYY on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "KDConstants.h"

@interface xxNetworking : NSObject

/*!
 *  post请求
 *
 *  @param url  请求接口
 *  @param para 请求参数
 *  @param suc  成功回调
 *  @param fail 失败回调
 */
+ (void)POST:(NSString *)url
   parameter:(id)para
   bodyJson:(BOOL)bodyJson

     success:(void (^)(id ))suc
     failure:(void (^)(NSString *))fail;

/*!
 *  get请求
 *
 *  @param url  请求接口
 *  @param para 请求参数
 *  @param isNeedCache 是否需要缓存数据库
 *  @param suc  成功回调
 *  @param fail 失败回调
 */
+ (void)GET:(NSString *)url
  parameter:(NSDictionary *)para
isNeedCache:(BOOL)isCache
    success:(void (^)(id ))suc
    failure:(void (^)(NSString *))fail;

/**
  判断网络状态

 @param status 状态
 */
+(void)noticeNetWorkStatus:(void (^) (int))status;
@end
