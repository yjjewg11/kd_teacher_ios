//
//  pushTableViewController.m
//  KDteacher
//
//  Created by WenJieKeJi on 15/9/1.
//  Copyright (c) 2015年 liumingquan. All rights reserved.
//

#import "pushTableViewController.h"

@interface pushTableViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *pushMessage;

@end

@implementation pushTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送设置";
    [self.tableView setScrollEnabled:NO];
    [self setExtraCellLineHidden:self.tableView];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(gotoBack)];
    self.navigationItem.leftBarButtonItem = leftButton;

}
-(void)gotoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//隐藏多余的表格线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置单元格被选中的颜色
    self.pushMessage.selectedBackgroundView = [[UIView alloc] initWithFrame:self.pushMessage.frame];
    self.pushMessage.selectedBackgroundView.backgroundColor = [UIColor  clearColor];

        return self.pushMessage;
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
    
}


@end
