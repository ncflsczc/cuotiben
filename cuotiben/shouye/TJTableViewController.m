//
//  TJTableViewController.m
//  cuotiben
//
//  Created by 陈志超 on 2022/2/23.
//
#define Width [UIScreen mainScreen].bounds.size.width
#define bg_tablename @"cuotiku"
#import "TJTableViewController.h"
#import "BRStringPickerView.h"
#import "GKPhotoBrowser.h"

#import "SVProgressHUD.h"


@interface TJTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *timubtn;
@property (weak, nonatomic) IBOutlet UIButton *kemubtn;
@property (weak, nonatomic) IBOutlet UIButton *dengjibtn;
@property (weak, nonatomic) IBOutlet UIButton *zhuangtbtn;
@property (weak, nonatomic) IBOutlet UITextField *cishu;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,assign)BOOL isImage;
@property (nonatomic,strong)UIImage *img;
@property (weak, nonatomic) IBOutlet UIButton *qdbtn;
@property (weak, nonatomic) IBOutlet UITextField *shuomingtf;

@end

@implementation TJTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isImage = NO;
    _imageView = [[UIImageView alloc]init];
    _qdbtn.layer.cornerRadius = 10;
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
- (void)pressAction:(UILongPressGestureRecognizer *)longPressGesture
{
    CGPoint point = [longPressGesture locationInView:self.tableView];
    NSIndexPath *currentIndexPath = [self.tableView indexPathForRowAtPoint:point];
    if (longPressGesture.state == UIGestureRecognizerStateBegan &&currentIndexPath.row==0) {//手势开始
// 可以获取我们在哪个cell上长按
        NSMutableArray *photos = [NSMutableArray new];
           GKPhoto *photo = [GKPhoto new];
            photo.image = _imageView.image;
           [photos addObject:photo];
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
        browser.showStyle = GKPhotoBrowserShowStyleNone;
        [browser showFromVC:self];
        
        NSLog(@"%ld",currentIndexPath.section);
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewWillDisappear:(BOOL)animated{
    _isImage = NO;
    [self.view endEditing:YES];
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.view endEditing:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
       
    if(indexPath.row==0){
        if (_isImage) {
            return (Width-40) * 9 / 16 + 20;
        }else
            return 10;
    }else if (indexPath.row==7)
        return 160;
    return 50;
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
                    [self.zhuangtbtn setTitle:resultModel.value forState:UIControlStateNormal];
                    self.zhuangtbtn.titleLabel.tintColor = [UIColor blackColor];
                    break;
                default: break;
        };
        };
        [stringPickerView show];
    }
//    else if (indexPath.row==5){
//        [self.cishu setFont:[UIFont systemFontOfSize:16]];
//    }
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
//        self.currentcellrow = path.row;
        self.isImage = YES;

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
        self.isImage = YES;

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

#pragma mark - add subviews

- (void)addSubviews {
    
    [self.view addSubview:self.imageView];
}

#pragma mark - make constraints


#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    _isImage = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取到的图片
    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];
    _imageView.image = image;
    UIView *currentview = (UIView*)[self.view viewWithTag:99];
//    currentview.backgroundColor = [UIColor redColor];

   UIImageView *imagview =[[UIImageView alloc]initWithFrame: CGRectMake(20, 10, Width-40, (Width-40) * 9 / 16)];
    imagview.image = image;
        [currentview addSubview:imagview];
    [self.timubtn setTitle:@"重新导入图片" forState:UIControlStateNormal];
    [self.tableView reloadData];
}

#pragma mark - quding


- (IBAction)quedingclicked:(id)sender {
    if(_kemubtn.titleLabel.text.length &&_dengjibtn.titleLabel.text.length&&_zhuangtbtn.titleLabel.text.length&&_shuomingtf.text.length&&_cishu.text.length){
        [SVProgressHUD showWithStatus:@"数据正在保存中"];
        [SVProgressHUD setDefaultMaskType: SVProgressHUDMaskTypeGradient];
        Timu *timu = [[Timu alloc]init];
        timu.Tmimage = _imageView.image;
        timu.Kemu = _kemubtn.titleLabel.text;
        timu.Dengji = _dengjibtn.titleLabel.text;
        timu.zhuangtai = _zhuangtbtn.titleLabel.text;
        timu.Shuoming = _shuomingtf.text;
        timu.CiShu = [_cishu.text intValue];
        timu.bg_tableName = bg_tablename;
        [timu bg_saveAsync:^(BOOL isSuccess) {
            
            
            NSOperationQueue *waitQueue = [[NSOperationQueue alloc] init];
            [waitQueue addOperationWithBlock:^{
                [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
                // 同步到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.navigationController popViewControllerAnimated:YES];

                });
            }];
        }];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"所有内容都有填写哦！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"确定按钮被点击");
            }];
            UIAlertAction *canselAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消按钮被点击");
            }];
         
            [alertController addAction:okAction];
            [alertController addAction:canselAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
    }
}


@end
