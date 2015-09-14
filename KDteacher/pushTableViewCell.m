

//
//  pushTableViewCell.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/14.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "pushTableViewCell.h"
#import "UMessage.h"
@implementation pushTableViewCell

#define NewMessageKey @"newMessage"
#define VoiceKey @"voice"
#define ShakeKey @"shake"

- (void)awakeFromNib {
    [_mySwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    _dic = @{@"新消息":NewMessageKey,@"声音":VoiceKey,@"震动":ShakeKey};
}

#pragma mark - 开关点击
- (void)switchChange:(UISwitch *)sender{
    
       
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:[_dic objectForKey:_flagTitleLabel.text]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

@end
