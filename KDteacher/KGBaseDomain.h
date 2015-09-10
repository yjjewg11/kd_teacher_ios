//
//  KGBaseDomain.h
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/9.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResMsgDomain.h"
@interface KGBaseDomain : NSObject
@property(strong, nonatomic) NSString       * uuid;
@property(strong, nonatomic) ResMsgDomain   * ResMsg;
@property(strong, nonatomic) id  data;
@end
