//
//  pushTableViewCell.h
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/14.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pushTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *flagTitleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *mySwitch;
@property(strong,nonatomic)NSDictionary *dic;
@end
