
//
//  KGHttpService.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/15.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "KGHttpService.h"
#import "KDConstants.h"
@implementation KGHttpService
+ (KGHttpService *)sharedService {
    static KGHttpService *_sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[KGHttpService alloc] init];
    });
    
    return _sharedService;
}
//提交推送token
- (void)submitPushTokenWithStatus:(NSString *)status success:(void (^)(NSString * msgStr))success faild:(void (^)(NSString * errorMsg))faild {
    
    NSDictionary * dic = @{@"device_id" : _pushToken,
                           @"device_type": @"ios",
                           @"status":status};
    NSData   * jsonData       = nil;
    
    if([NSJSONSerialization isValidJSONObject:dic])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    }
    NSString *path = URL(G_baseServiceURL, Push_Token);
    NSURL * url = [NSURL URLWithString:path];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
}


@end
