//
//  HomeViewController.m
//  cuotiben
//
//  Created by 陈志超 on 2022/2/18.
//
#define Width [UIScreen mainScreen].bounds.size.width
#define bg_createTimeKey @"bg_createTime"
#define bg_updateTimeKey @"bg_updateTime"
#define bg_tablename @"cuotiku"
#define bg_tablename2 @"cuotiku22"

#import "HomeViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "SCPieChart.h"
#import "SCChart.h"
#import "Timu.h"
#import "GKPhotoBrowser.h"
#import "YuYinViewController.h"
#import "LangDuViewController.h"
#import "TJTableViewController.h"
#import "AppDelegate.h"
#import "CurrentState.h"
@interface HomeViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
{
    SCPieChart *chartView;
    NewPagedFlowView *pageFlowView;
    UILabel *label;
    LangDuViewController *ldvc;
}
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@end

@implementation HomeViewController

-(void)containtChinese:(NSString*)text{
    if (ldvc) {
        ldvc = nil;
    }
    ldvc = [[LangDuViewController alloc]init];
    NSArray *titlearr = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物",@"历史", @"地理", @"政治"];
    
    if ([text containsString:@"总错题数"]) {
        NSMutableArray *kemuNums = [[NSMutableArray alloc]init];
        for (int i = 0; i<titlearr.count; i++) {
            if ([self GetData:titlearr[i]].count) {
                [kemuNums addObject:[self GetData:titlearr[i]]];
            }
        }
        NSString *kemunumstr = [[NSString alloc]init];
        for (int i=0; i<kemuNums.count; i++) {
            NSArray *keArr = kemuNums[i];
            Timu *keT = [keArr firstObject];
            kemunumstr = [kemunumstr stringByAppendingFormat:@"%@%ld个",keT.Kemu,keArr.count];
        }
        NSArray *arr = [[NSArray alloc]init];
        arr = [Timu bg_find:bg_tablename limit:0 orderBy:bg_createTimeKey desc:YES];
        [ldvc readtext:[NSString stringWithFormat:@"错题库中共有%ld个题目,其中%@",arr.count,kemunumstr]];
    }else if([text containsString:@"添加笔记"]){
        [ldvc readtext:@"已为您找到添加笔记的页面"];
        TJTableViewController *tj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tjbj"];
        
        [self.navigationController showViewController:tj sender:nil];
    }else if ([text containsString:@"笔记"]&&[text containsString:@"看"]){

        AppDelegate *appd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        for (NSString*titletext in titlearr) {
            if ([text containsString:titletext]) {
                appd.CurrentkemuStr = titletext;
                [ldvc readtext:[NSString stringWithFormat:@"已为您找到%@笔记的页面",titletext]];
                break;
            }
        }
        self.tabBarController.selectedIndex = 1;
    }
    else{
        [ldvc readtext:@"抱歉，我没听懂您的意思。"];
    }
}
-(void)viewWillAppear:(BOOL)animated{
//    [self containtChinese:@"总错题数"];
    [super viewWillAppear:animated];
    [self GetData];
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    NSString* where4 = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"biaoji"),bg_sqlValue(@"biaoji")];
    NSArray* arr4 = [CurrentState bg_find:bg_tablename2 where:where4];
    if (!arr4.count) {
        CurrentState *cs = [[CurrentState alloc]init];
        cs.biaoji = @"biaoji";
        cs.isOpenYuyin = YES;
        cs.bg_tableName = bg_tablename2;
        [cs bg_saveAsync:^(BOOL isSuccess) {
//            NSLog(@"chengg");
        }];
        
    }
    
    NSArray *totalarr = [Timu bg_findAll:bg_tablename];
    if (totalarr.count) {
        [self setupchartview];
    }else{
        chartView.hidden = YES;
        [chartView removeFromSuperview];
        if (ldvc) {
            ldvc = nil;
        }
        
        NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"biaoji"),bg_sqlValue(@"biaoji")];
        NSArray* arr = [CurrentState bg_find:bg_tablename2 where:where];
        CurrentState *cs = [arr lastObject];
        if (cs.isOpenYuyin) {
            ldvc = [[LangDuViewController alloc]init];
            [ldvc readtext:@"亲，错题本中还没有笔记，可以点击右上角语音按钮和我说添加笔记,如果不喜欢小播请在我的页面中关闭"];
        }
    }
    [self setupUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    for (int index = 1; index <= 3; index++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"moren%d",index]];
//        [self.imageArray addObject:image];
//    }
    // Do any additional setup after loading the view, typically from a nib.

//    [self setupchartview];
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (ldvc) {
        [ldvc stopread];
    }
//    chartView = nil;
//    pageFlowView = nil;
//    label = nil;
//    [label removeFromSuperview];
}
- (void)setupUI {
    if(pageFlowView){
        [pageFlowView removeFromSuperview];
        pageFlowView = nil;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self GetData];
    pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 70, Width, Width * 9 / 16)];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.isCarousel = NO;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    pageFlowView.isOpenAutoScroll = YES;
    pageFlowView.isCarousel = YES;
    pageFlowView.autoTime = 2;
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 32, Width, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    [pageFlowView reloadData];
    
    [self.view addSubview:pageFlowView];
    
   

}
#pragma mark - 语音操作

- (IBAction)yuyinClicked:(id)sender {
    YuYinViewController *vc = [[YuYinViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    vc.returnblock = ^(NSString * _Nonnull text) {
        NSLog(@"%@",text);
        [weakSelf containtChinese:text];
    };
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

#pragma mark - 数据库操作
-(void)GetData{
    [self.imageArray removeAllObjects];
    NSArray *arr = [[NSArray alloc]init];
    arr = [Timu bg_find:bg_tablename limit:0 orderBy:bg_createTimeKey desc:YES];
    if (arr.count) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //最多展示前9张
            if(idx<9)
                [self.imageArray addObject:((Timu*)arr[idx]).Tmimage];
        }];
    }else{
        [self.imageArray addObjectsFromArray:@[[UIImage imageNamed:@"moren1"],[UIImage imageNamed:@"moren2"],[UIImage imageNamed:@"moren3"]]];
    }
    
}
-(NSArray*)GetData:(NSString*)value{
    NSArray *arr = [[NSArray alloc]init];
    NSString* where = [[NSString alloc]init];
    where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"Kemu"),bg_sqlValue(value)];
    arr = [Timu bg_find:bg_tablename where:where];
    return arr;
}

-(void)setupchartview{
    //label
    if(label){
        [label removeFromSuperview];
        label = nil;
    }
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, Width * 9 / 16+50, Width, 100)];
        
        [label setText:@"各科目错题占比"];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:[UIFont systemFontOfSize:20]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:label];
        //饼图
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    NSArray *totalarr = [Timu bg_findAll:bg_tablename];
    NSArray *arr = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物",@"历史", @"地理", @"政治"];
    NSMutableArray *cuA = [[NSMutableArray alloc]init];

    [_itemsArray removeAllObjects];
    for (int i=0; i<arr.count; i++) {
        float tA = (float)totalarr.count;
        float curA = (float)[self GetData:arr[i]].count;
        if ([self GetData:arr[i]].count) {
            [[self GetData:arr[i]]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Timu *timu = (Timu*)[self GetData:arr[i]][idx];
                if ([timu.Kemu isEqualToString:@"语文"]) {
                    [cuA addObject:[SCPieChartDataItem dataItemWithValue:curA/tA*100 color:SCRed description:timu.Kemu]];
                }else if ([timu.Kemu isEqualToString:@"数学"]) {
                    [cuA addObject:[SCPieChartDataItem dataItemWithValue:curA/tA*100 color:SCGreen description:timu.Kemu]];
                }else if ([timu.Kemu isEqualToString:@"英语"]) {
                    [cuA addObject:[SCPieChartDataItem dataItemWithValue:curA/tA*100 color:SCBlue description:timu.Kemu]];
                }else if ([timu.Kemu isEqualToString:@"物理"]) {
                    [cuA addObject:[SCPieChartDataItem dataItemWithValue:curA/tA*100 color:SCYellow description:timu.Kemu]];
                }else if ([timu.Kemu isEqualToString:@"化学"]) {
                    [cuA addObject:[SCPieChartDataItem dataItemWithValue:curA/tA*100 color:SCPinkGrey description:timu.Kemu]];
                }else if ([timu.Kemu isEqualToString:@"生物"]) {
                    [cuA addObject:[SCPieChartDataItem dataItemWithValue:curA/tA*100 color:SCFreshGreen description:timu.Kemu]];
                }else if ([timu.Kemu isEqualToString:@"历史"]) {
                    [cuA addObject:[SCPieChartDataItem dataItemWithValue:curA/tA*100 color:SCMauve description:timu.Kemu]];
                }else if ([timu.Kemu isEqualToString:@"政治"]) {
                    [cuA addObject:[SCPieChartDataItem dataItemWithValue:curA/tA*100 color:SCBrown description:timu.Kemu]];
                }else if ([timu.Kemu isEqualToString:@"地理"]) {
                    [cuA addObject:[SCPieChartDataItem dataItemWithValue:curA/tA*100 color:SCDarkBlue description:timu.Kemu]];
                }
            }];
        }
    }
    if (!totalarr.count){
//        [cuA addObject:[SCPieChartDataItem dataItemWithValue:0 color:SCRed description:@"100%无题。亲，去添加题目吧"]];
//        [cuA addObject:nil];
    }
    _itemsArray = [NSMutableArray arrayWithArray:cuA];

    
        chartView = [[SCPieChart alloc] initWithFrame:CGRectMake((Width-250)/2, Width * 9 / 16+150, 250.0, 250.0) items:_itemsArray];
    chartView.hidden = NO;
        chartView.descriptionTextColor = [UIColor whiteColor];
        chartView.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:15.0];
        [chartView strokeChart];

        [self.view addSubview: chartView];

}
#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(Width - 60, (Width - 60) * 9 / 16);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
        NSMutableArray *photos = [NSMutableArray new];
        [self.imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GKPhoto *photo = [GKPhoto new];
                 photo.image = self.imageArray[idx];
                [photos addObject:photo];
            }];
               
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
        browser.showStyle = GKPhotoBrowserShowStyleNone;
        [browser showFromVC:self];
            
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
//    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
    
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}


#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
-(NSMutableArray *)itemsArray{
    if (_itemsArray == nil) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}


/*#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
