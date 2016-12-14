//
//  xxNetworking.m
//  PanguDistributor
//
//  Created by GYY on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "xxNetworking.h"

#import "AFNetworking.h"

//#define kNetworkNotReachability ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0)  //无网
@implementation xxNetworking

+ (void)POST:(NSString *)url parameter:(NSDictionary* )para
    bodyJson:(BOOL)bodyJson
success:(void (^)(id))suc failure:(void (^)(NSString *))fail {
    
    AFHTTPSessionManager * sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer.HTTPShouldHandleCookies = YES;
    
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;
    sessionManager.securityPolicy  = securityPolicy;
    
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置Cookie
//    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaultInstance objectForKey:kCCookieKey]];
//    for (NSHTTPCookie * cookie in cookies) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//    }
    NSString * postUrl = [NSString stringWithFormat:@"%@%@",G_baseServiceURL, url];
    
      NSLog(@"postUrl=%@",postUrl);
    
    if (  bodyJson) {
        sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [sessionManager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [sessionManager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    }
    
    NSURLSessionDataTask * task = [sessionManager POST:postUrl parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary * content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];//转换数据格式
        if (suc) {
            
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
           suc(str);
        }
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
//    NSURLSessionDataTask * task = [sessionManager POST:postUrl parameters:para progress:nil success:^(NSURLSessionDataTask *  task, id  responseObject) {
////        NSDictionary * content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];//转换数据格式
////        if (content && [content[@"code"] intValue] == 802) {
////            [NoticeCenter postNotificationName:kCUserAccessTokenLoseEffectivenessNotificationKey object:nil];
////            return ;
////        }
//        if (suc) {
//            suc(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////        [NoticeCenter postNotificationName:kCNetworkingFailedErrorNotificationKey object:error];
//    }];
    [task resume];
}

+ (void)GET:(NSString *)url parameter:(NSDictionary *)para isNeedCache:(BOOL)isCache success:(void (^)( id))suc failure:(void (^)(NSError *))fail {
    
    //如果需要缓存的数据
    if (isCache == YES){
        
        }else {
            [self getdata:url parameter:para success:^( id dic) {
                suc(dic);
            } failure:^(NSString * error) {
                fail(error);
            }];
    }

}
+ (void)getdata:(NSString *)url parameter:(id)para success:(void (^)(id))suc failure:(void (^)(NSString *))fail
{
    AFHTTPSessionManager * sessionManager = [AFHTTPSessionManager manager];
    NSString * postUrl = [NSString stringWithFormat:@"%@%@",G_baseServiceURL, url];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;
    sessionManager.securityPolicy  = securityPolicy;
    
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    // 读取Cookie
//    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaultInstance objectForKey:kCCookieKey]];
//    // 设置Cookie
//    for (NSHTTPCookie * cookie in cookies) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//    }
    // GET请求
    
    NSURLSessionDataTask * task = [sessionManager GET:postUrl parameters:para  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
      
        if (suc) {
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            suc(str);
//            suc(responseObject);
        }
 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (fail) {
//            fail(error);
//            [NoticeCenter postNotificationName:kCNetworkingFailedErrorNotificationKey object:error];
//        }

    }];
     [task resume];
}

+ (void)noticeNetWorkStatus:(void (^) (int))netStatus
{
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
        netStatus(status);
    }];
}
@end
