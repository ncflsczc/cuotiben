//
//  FileViewController.m
//  cuotiben
//
//  Created by 陈志超 on 2022/3/3.
//
#define Width [UIScreen mainScreen].bounds.size.width
#import "BijiViewController.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "LoadDataListCollectionListViewController.h"
#import "BRStringPickerView.h"
#import "FileViewController.h"
#import "FileTableViewController.h"
#import <QuickLook/QuickLook.h>

@interface FileViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate,UIDocumentBrowserViewControllerDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (weak, nonatomic) IBOutlet UIView *midview;
@property (weak, nonatomic) IBOutlet UIView *topview;
@property (nonatomic,strong)UIDocumentInteractionController * document;
@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self quickLook];
    //本地文件的绝对路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"第一部分.pdf" ofType:nil];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"/var/mobile/Containers/Data/Application/E42EBA80-DDDB-4FA3-B472-B694EFFD7559/Documents/localFile/附件7：无人机编程赛规则-1.pdf"]];
    
         NSURL *url = [NSURL fileURLWithPath:@"/var/mobile/Containers/Data/Application/CA470137-95ED-4DCE-80FF-35E0D1A5A4F9/Documents/localFile/附件7：无人机编程赛规则-2.pdf"];
         
         UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:url];
         interactionController.delegate = self;
         
         //预览有其他软件打开按钮
         [interactionController presentPreviewAnimated:NO];
         
         CGRect navRect = self.navigationController.navigationBar.frame;
         navRect.size =CGSizeMake(1500.0f,40.0f);
         
         //直接显示包含预览的菜单项
//         [interactionController presentOpenInMenuFromRect:navRect inView:self.view animated:YES];

    
//file:///private/var/mobile/Containers/Data/Application/BE530490-2FE3-4512-AE3B-DA6ED566CE0A/tmp/com.ncfls.czc.cuotiben-Inbox/%E9%99%84%E4%BB%B69%EF%BC%9AWER%E6%99%AE%E5%8F%8A%E8%B5%9B%E8%A7%84%E5%88%99.pdf
    
//    /var/mobile/Containers/Data/Application/BE530490-2FE3-4512-AE3B-DA6ED566CE0A/Documents/localFile/附件9：WER普及赛规则.pdf
//    WKWebView *webview = [[WKWebView alloc]initWithFrame:self.view.bounds];
//        NSURL *url1 = [NSURL fileURLWithPath:@"www.baidu.com"];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url1];
//        [webview loadRequest:request];
//    [self.view addSubview:webview];
    
    self.titles = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物", @"政治", @"历史", @"地理", @"其他"];
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    [self.midview addSubview:self.listContainerView];
    self.categoryView = [[JXCategoryTitleView alloc] init];
    //优化关联listContainer，以后后续比如defaultSelectedIndex等属性，才能同步给listContainer
    self.categoryView.listContainer = self.listContainerView;
    self.categoryView.titles = _titles;
    self.categoryView.delegate = self;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    self.categoryView.indicators = @[lineView];
    [self.topview addSubview:self.categoryView];

    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [self.categoryView reloadData];
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.categoryView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    self.listContainerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-50);
}
#pragma mark - JXCategoryListContainerViewDataSource

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    FileTableViewController *listVC = [[FileTableViewController alloc] init];
    listVC.title = self.titles[index];

    return listVC;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

- (void)quickLook{

    NSString *file = [[NSBundle mainBundle] pathForResource:@"第一部分.pdf" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:file];
    if ([QLPreviewController canPreviewItem:url]) {
        QLPreviewController *qlpreVc = [[QLPreviewController alloc] init];
        qlpreVc.delegate = self;
        qlpreVc.dataSource = self;
        [self presentViewController:qlpreVc animated:YES completion:nil];
    }
}
#pragma mark - QLPreviewControllerDataSource 代理方法
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = @"";
    NSString *testPath = [path stringByAppendingPathComponent:@"/var/mobile/Containers/Data/Application/03CDE359-0AE0-4C05-A5EE-C321BC2FCA52/Documents/localFile/1.pdf"];//在传入的路径下创建test.c文件
//    [fileManager createFileAtPath:testPath contents:nil attributes:nil];
//通过data创建数据
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"/var/mobile/Containers/Data/Application/03CDE359-0AE0-4C05-A5EE-C321BC2FCA52/Documents/localFile/附件9：WER普及赛规则.pdf"]];
    [fileManager createFileAtPath:testPath contents:data attributes:nil];
    NSArray *documentsPathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [documentsPathArr lastObject];
    NSLog(@"%@",documentsPath);
    NSString *Doc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/localFile"] stringByAppendingPathComponent:@"附件9：WER普及赛规则.pdf"];
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"第一部分.pdf" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:@"/var/mobile/Containers/Data/Application/03CDE359-0AE0-4C05-A5EE-C321BC2FCA52/Documents/localFile/附件9：WER普及赛规则.pdf"];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"/var/mobile/Containers/Data/Application/03CDE359-0AE0-4C05-A5EE-C321BC2FCA52/Documents/localFile/附件9：WER普及赛规则.pdf"]];
//    NSURL *url2 = [NSURL ]
    NSData * data1 = [NSData dataWithContentsOfFile:testPath];
    NSString * content = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    return  url;
}

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}
-(UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return self.view;
}
-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{
    return  self.view.frame;
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
