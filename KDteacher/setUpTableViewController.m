//
//  setUpTableViewController.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/8/31.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "setUpTableViewController.h"

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
    self.title = @"设置";
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(gotoBack)];
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
            return 4;
          case 1:
            return 2;
            case 2:
            return 2;
        default:
            return 0;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
                    case 3:
                    cell.textLabel.text = @"版本更新";
                    break;
            }
            break;
           case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"修改名字";
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
