//
//  XiugaiTableViewController.m
//  cuotiben
//
//  Created by 陈志超 on 2022/2/25.
//
#define bg_primaryKey @"bg_id"
#define bg_createTimeKey @"bg_createTime"
#define bg_updateTimeKey @"bg_updateTime"
#define bg_tablename @"cuotiku"
#import "XiugaiTableViewController.h"
#import "SVProgressHUD.h"
#import "BRStringPickerView.h"
#import "LoadDataListBaseViewController.h"
#import "BijiViewController.h"
#import "GKPhotoBrowser.h"

@interface XiugaiTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *querenbtn;

@end

@implementation XiugaiTableViewController
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.iconimg.layer.cornerRadius = 10;
    self.querenbtn.layer.maskedCorners = 10;
    
    self.iconimg.image = self.timu.Tmimage;
    [self.kemubtn setTitle:self.timu.Kemu forState:UIControlStateNormal];
    [self.dengjibtn setTitle:self.timu.Dengji forState:UIControlStateNormal];
    [self.zhuangtaibt setTitle:self.timu.zhuangtai forState:UIControlStateNormal];
//    NSLog(@"%@",timu.Dengji);
//    NSLog(@"22222");
    self.shuomingtf.text = self.timu.Shuoming;
    self.cishutf.text = [[NSString alloc]initWithFormat:@"%d",self.timu.CiShu];
}
- (void)pressAction:(UILongPressGestureRecognizer *)longPressGesture
{
    CGPoint point = [longPressGesture locationInView:self.tableView];
    NSIndexPath *currentIndexPath = [self.tableView indexPathForRowAtPoint:point];
    if (longPressGesture.state == UIGestureRecognizerStateBegan &&currentIndexPath.row==0) {//手势开始
// 可以获取我们在哪个cell上长按
        NSMutableArray *photos = [NSMutableArray new];
           GKPhoto *photo = [GKPhoto new];
            photo.image = _iconimg.image;
           [photos addObject:photo];
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
        browser.showStyle = GKPhotoBrowserShowStyleNone;
        [browser showFromVC:self];
        
        NSLog(@"%ld",currentIndexPath.section);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapGr.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapGr];
    
    //长按手势
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressAction:)];
        [self.tableView addGestureRecognizer:longpress];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.view endEditing:YES];
}
- (IBAction)deletclicked:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"确定要删除吗"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showWithStatus:@"数据正在删除中"];
        [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeGradient];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            NSLog(@"%@",self.timu.bg_createTime);
            NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"bg_createTime"),bg_sqlValue(self.timu.bg_createTime)];
            [Timu bg_delete:bg_tablename where:where];

            NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
            [waitQueue addOperationWithBlock:^{
                [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
                // 同步到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        });
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"Cancel Action");
    }];

    [alertController addAction:okAction];           // A
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
  
        
    
}

- (IBAction)btnclicked:(id)sender {
    
   
    [SVProgressHUD showWithStatus:@"数据正在修改中"];
    [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeGradient];

    NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
    [waitQueue addOperationWithBlock:^{
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
        // 同步到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* where1 = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"Tmimage"),bg_sqlValue(self.iconimg.image),bg_sqlKey(@"bg_createTime"),bg_sqlValue(self.timu.bg_createTime)];
            NSString* where2 = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"Shuoming"),bg_sqlValue(self.shuomingtf.text),bg_sqlKey(@"bg_createTime"),bg_sqlValue(self.timu.bg_createTime)];
            NSString* where3 = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"Kemu"),bg_sqlValue(self.kemubtn.titleLabel.text),bg_sqlKey(@"bg_createTime"),bg_sqlValue(self.timu.bg_createTime)];
            NSString* where4 = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"Dengji"),bg_sqlValue(self.dengjibtn.titleLabel.text),bg_sqlKey(@"bg_createTime"),bg_sqlValue(self.timu.bg_createTime)];
            NSString* where5 = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"zhuangtai"),bg_sqlValue(self.zhuangtaibt.titleLabel.text),bg_sqlKey(@"bg_createTime"),bg_sqlValue(self.timu.bg_createTime)];
            NSString* where6 = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"CiShu"),bg_sqlValue(self.cishutf.text),bg_sqlKey(@"bg_createTime"),bg_sqlValue(self.timu.bg_createTime)];

            [Timu bg_update:bg_tablename where:where1];
            [Timu bg_update:bg_tablename where:where2];
            [Timu bg_update:bg_tablename where:where3];
            [Timu bg_update:bg_tablename where:where4];
            [Timu bg_update:bg_tablename where:where5];
            [Timu bg_update:bg_tablename where:where6];


            NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
            [waitQueue addOperationWithBlock:^{
                [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
                // 同步到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];

        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSLog(@"xiugai");




    });


    dispatch_async(dispatch_get_main_queue(), ^{


        });

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 8;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==1){
        [self selectPhoto:indexPath];
    }
    if(indexPath.row>=2 && indexPath.row<5){
        BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
        stringPickerView.pickerMode = BRStringPickerComponentSingle;
        switch(indexPath.row){
            case 2:
                stringPickerView.title = @"科目";
                stringPickerView.dataSourceArr = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物",@"历史", @"地理", @"政治",@"其他"];
                break;
            case 3:
                stringPickerView.title = @"等级";
                stringPickerView.dataSourceArr = @[@"非常重要:A", @"重要:B", @"一般:C", @"不重要:D"];
                break;
            case 4:
                stringPickerView.title = @"状态";
                stringPickerView.dataSourceArr = @[@"已掌握", @"未掌握"];
                break;
            default: break;
        };
        stringPickerView.selectIndex = 2;
        stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
            NSLog(@"选择的值：%@", resultModel.value);
            switch(indexPath.row){
                case 2:
                    [self.kemubtn setTitle:resultModel.value forState:UIControlStateNormal];
                    self.kemubtn.titleLabel.tintColor = [UIColor blackColor];
                    break;
                case 3:
                    [self.dengjibtn setTitle:resultModel.value forState:UIControlStateNormal];
                    self.dengjibtn.titleLabel.tintColor = [UIColor blackColor];
                    break;
                case 4:
                    [self.zhuangtaibt setTitle:resultModel.value forState:UIControlStateNormal];
                    self.zhuangtaibt.titleLabel.tintColor = [UIColor blackColor];
                    break;
                default: break;
        };
        };
        [stringPickerView show];
    }
}
#pragma mark - navitation item action

- (void)selectPhoto:(NSIndexPath*)path{
    //创建UIImagePickerController对象，并设置代理和可编辑
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;

    //创建sheet提示框，提示选择相机还是相册
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择打开方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    //相机选项
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        //选择相机时，设置UIImagePickerController对象相关属性
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
//        imagePicker.mediaTypes =
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //跳转到UIImagePickerController控制器弹出相机
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];

    //相册选项
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        //选择相册时，设置UIImagePickerController对象相关属性
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //跳转到UIImagePickerController控制器弹出相册
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];

    //取消按钮
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    //添加各个按钮事件
    [alert addAction:camera];
    [alert addAction:photo];
    [alert addAction:cancel];

    //弹出sheet提示框
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取到的图片
    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];
    self.iconimg.image = image;
    [self.tableView reloadData];
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
