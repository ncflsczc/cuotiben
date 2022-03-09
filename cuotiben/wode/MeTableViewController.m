//
//  MeTableViewController.m
//  cuotiben
//
//  Created by 陈志超 on 2022/2/28.
//
#define bg_tablename @"cuotiku"
#define bg_tablename2 @"cuotiku22"
#import "MeTableViewController.h"
#import "Timu.h"
#import "SVProgressHUD.h"
#import "CurrentState.h"
//#import "AppDelegate.h"
@interface MeTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *kaiguan;

@end

@implementation MeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)switchClicked:(id)sender {
//    [self.kaiguan setOn:!self.kaiguan.isOn];
//    dele.isOpenYuyin = self.kaiguan.isOn;
//    NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"biaoji"),bg_sqlValue(@"biaoji")];
//    NSArray* arr = [CurrentState bg_find:bg_tablename where:where];
//    CurrentState *cs = [arr lastObject];
    NSString* where6 = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"isOpenYuyin"),bg_sqlValue(@(self.kaiguan.isOn)),bg_sqlKey(@"biaoji"),bg_sqlValue(@"biaoji")];

    [CurrentState bg_update:bg_tablename2 where:where6];
    if (self.kaiguan.isOn) {

        [SVProgressHUD showWithStatus:@"自动语音播报已打开"];
    }else{
        [SVProgressHUD showWithStatus:@"自动语音播报已关闭"];
    }
    
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeGradient];
    [SVProgressHUD dismissWithDelay:1];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                     message:@"清除缓存会清除所有数据，确定要清除吗"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showWithStatus:@"数据正在删除中"];
            [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeGradient];
            [CurrentState bg_clear:bg_tablename2];
            [Timu bg_clearAsync:bg_tablename complete:^(BOOL isSuccess) {
                if(isSuccess){
                    NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
                    [waitQueue addOperationWithBlock:^{
                        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
                        // 同步到主线程
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                            [self.navigationController popViewControllerAnimated:YES];
       
                        });
                    }];

                
                }
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"Cancel Action");
        }];

        [alertController addAction:okAction];           // A
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
