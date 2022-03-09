//
//  LookFileViewController.m
//  cuotiben
//
//  Created by 陈志超 on 2022/3/8.
//

#import "LookFileViewController.h"
#import <QuickLook/QuickLook.h>
@interface LookFileViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@end

@implementation LookFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self quickLook];
}
- (void)quickLook{

//    NSString *file = [[NSBundle mainBundle] pathForResource:@"第一部分.pdf" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:file];
//    if ([QLPreviewController canPreviewItem:url]) {
//        QLPreviewController *qlpreVc = [[QLPreviewController alloc] init];
//        qlpreVc.delegate = self;
//        qlpreVc.dataSource = self;
//        [self presentViewController:qlpreVc animated:YES completion:nil];
//    }
}
#pragma mark - QLPreviewControllerDataSource 代理方法
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = @"";
    NSString *testPath = [path stringByAppendingPathComponent:@"/var/mobile/Containers/Data/Application/03CDE359-0AE0-4C05-A5EE-C321BC2FCA52/Documents/localFile/附件9：WER普及赛规则.pdf"];//在传入的路径下创建test.c文件
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
    return  [NSURL URLWithString:testPath];
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
