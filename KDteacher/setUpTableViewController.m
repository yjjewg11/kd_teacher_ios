//
//  setUpTableViewController.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/8/31.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "setUpTableViewController.h"
#import "aboutUsViewController.h"
#import "pushTableViewController.h"
#import "feedBackViewController.h"
#import "HomePageViewController.h"
#import "KDConstants.h"
@interface setUpTableViewController ()

@end

@implementation setUpTableViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义标题
   UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
    titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
    titleLabel.textAlignment = 1;
    titleLabel.text = @"设置";  //设置标题
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = COLOR(8, 122, 203, 1);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(gotoBack)];

    self.navigationItem.leftBarButtonItem = leftButton;
    
}
-(void)gotoBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
          case 1:
            return 2;
            case 2:
            return 2;
        default:
            return 0;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"关于我们";
                    break;
                    case 1:
                    cell.textLabel.text = @"推送消息";
                    break;
                    case 2:
                    cell.textLabel.text = @"意见反馈";
                    break;
                }
            break;
           case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"修改资料";
                    break;
                    case 1:
                    cell.textLabel.text = @"修改密码";
            }
            break;
            case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"清除缓存";
                    break;
                    
                case 1:
                    cell.textLabel.text = @"注销";
                    break;
            }
            break;
    }
//设置单元格被选中的颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor  clearColor];

   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 5;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //第一个分区
    if (indexPath.section == 0) {
        //单击关于我们所响应的事件
    if (indexPath.row == 0) {
        aboutUsViewController *ab = [[aboutUsViewController alloc]initWithNibName:@"aboutUsViewController" bundle:nil];
        
        [self.navigationController pushViewController:ab animated:YES];
    }//单击推送消息所响应的事件
    else if (indexPath.row == 1){
        pushTableViewController *push = [[pushTableViewController alloc]initWithNibName:@"pushTableViewController" bundle:nil];
        [self.navigationController pushViewController:push animated:YES];
    }//单击反馈消息所显示的事件
    else if (indexPath.row == 2){
        feedBackViewController *feed = [[feedBackViewController alloc]initWithNibName:@"feedBackViewController" bundle:nil];
        [self.navigationController pushViewController:feed animated:YES];
    }
    }//第二个分区
    else if (indexPath.section == 1){
        //单击修改名字所显示的事件
        if (indexPath.row == 0) {
            //HomePageViewController *home = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"changeData" object:self userInfo:nil];
            }];
        }//单击修改密码所响应的事件
        else if (indexPath.row == 1){
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changePassword" object:self userInfo:nil];
            }];

        }
    }//第三个分区
    else if(indexPath.section==2){
        //单击清除缓存所响应的事件
        if (indexPath.row==0) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"clearBuffer" object:self userInfo:nil];
            }];

//           [[NSURLCache sharedURLCache] removeAllCachedResponses];
//            HomePageViewController *home = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
//            [self presentViewController:home animated:YES completion:^{
//                [home.myView setHidden:NO];
//                home.setupBtn.selected = NO;
//                home.homeBtn.selected = YES;
//                [home.webView stringByEvaluatingJavaScriptFromString:@"javascript:menu_dohome()"];
//            }];

        }
    //单击注销所响应的事件
    else if(indexPath.row==1){
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancellation" object:self userInfo:nil];
        }];

    }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
