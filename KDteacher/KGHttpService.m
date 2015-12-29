
//
//  KGHttpService.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/15.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "KGHttpService.h"
#import "KDConstants.h"
#import "AFNetworking.h"
#import "HomePageViewController.h"

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
                           @"status":status,@"JSESSION":_jssionID
                           };
    NSString *path = URL(G_baseServiceURL, Push_Token);

    [self getServerJson:path params:dic
success:^(NSString *message) {
    
} faild:^(NSString *errMessage) {
    NSLog(@"errorMessage=%@",errMessage);
}];
}
-(void)getServerJson:(NSString *)path params:(NSDictionary *)jsonDictionary success:(void(^)(NSString *message))success faild:(void(^)(NSString *errMessage))faild {
    NSData   * jsonData       = nil;
    
    if([NSJSONSerialization isValidJSONObject:jsonDictionary])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
    }
   // NSString *path = URL(G_baseServiceURL, Push_Token);
    NSURL * url = [NSURL URLWithString:path];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    NSData *recievied = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"recievied = %@",recievied);
    NSString *str = [[NSString alloc]initWithData:recievied encoding:NSUTF8StringEncoding];
    NSLog(@"str=%@",str);
}

- (void)getNewerMainUrl:(void(^)(id newurl))success faild:(void(^)(NSString *errMessage))faild
{
    AFHTTPRequestOperationManager * mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:[NSString stringWithFormat:@"%@rest/share/getKDWebUrl.json",G_baseServiceURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        success(responseObject);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        faild(@"gg了");
    }];
}

@end
