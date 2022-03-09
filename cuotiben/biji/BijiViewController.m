//
//  BijiViewController.m
//  cuotiben
//
//  Created by 陈志超 on 2022/2/18.
//
#define Width [UIScreen mainScreen].bounds.size.width
#import "BijiViewController.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "LoadDataListCollectionListViewController.h"
#import "BRStringPickerView.h"
#import "LoadDataListBaseViewController.h"
#import "AppDelegate.h"
//#import "JXCategoryListContainerView.h"

@interface BijiViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topview;
@property (weak, nonatomic) IBOutlet UIView *midview;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, copy) NSString *selectSort;

@end

@implementation BijiViewController

- (void)viewDidLoad {
    AppDelegate *appd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appd.CurrentkemuStr = self.title;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectSort = @"按科目排序";
//    self.path = [[NSIndexPath alloc]init];
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    [self.midview addSubview:self.listContainerView];

    self.titles = [self getRandomTitles];
    self.categoryView = [[JXCategoryTitleView alloc] init];
    //优化关联listContainer，以后后续比如defaultSelectedIndex等属性，才能同步给listContainer
    self.categoryView.listContainer = self.listContainerView;
    self.categoryView.titles = [self getRandomTitles];
    self.categoryView.delegate = self;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    self.categoryView.indicators = @[lineView];
    [self.topview addSubview:self.categoryView];
//    AppDelegate *appd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *titarr = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物", @"政治", @"历史", @"地理", @"其他"];
    for(int i=0;i<titarr.count;i++) {
        if ([appd.CurrentkemuStr isEqualToString:titarr[i]]) {
            self.selectSort = @"按科目排序";
            self.categoryView.defaultSelectedIndex = i;
        }
    }
}
- (NSArray <NSString *> *)getRandomTitles {
    
    NSMutableArray *ctitles = [[NSMutableArray alloc]init];
    if ([self.selectSort isEqualToString:@"按科目排序"]) {
        ctitles = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物", @"政治", @"历史", @"地理", @"其他"].mutableCopy;
    }else if ([self.selectSort isEqualToString:@"按时间排序"]) {
        ctitles = @[@"时间"].mutableCopy;
    }else if ([self.selectSort isEqualToString:@"按等级排序"]) {
        ctitles = @[@"非常重要", @"重要", @"一般", @"不重要"].mutableCopy;
    }else if ([self.selectSort isEqualToString:@"按状态排序"]) {
        ctitles = @[@"已掌握", @"未掌握"].mutableCopy;
    }

    return ctitles;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *appd = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *titarr = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物", @"政治", @"历史", @"地理", @"其他"];
    for(int i=0;i<titarr.count;i++) {
        if ([appd.CurrentkemuStr isEqualToString:titarr[i]]) {
            self.selectSort = @"按科目排序";
            self.categoryView.defaultSelectedIndex = i;
        }
    }
//    [self reloadData];
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.categoryView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    self.listContainerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.midview.bounds.size.height);
}

/**
 重载数据源：比如从服务器获取新的数据、否则用户对分类进行了排序等
 */
- (void)reloadData {
    self.titles = [self getRandomTitles];

    //重载之后默认回到0，你也可以指定一个index
//    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titles = self.titles;
    [self.categoryView reloadData];
}

#pragma mark - JXCategoryListContainerViewDataSource

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    LoadDataListBaseViewController *listVC = [[LoadDataListBaseViewController alloc] init];
    listVC.title = self.titles[index];
    listVC.selectsort = self.selectSort;
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

- (IBAction)gengduoClicked:(id)sender {
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    stringPickerView.title = @"科目";
    stringPickerView.dataSourceArr = @[@"按科目排序", @"按时间排序", @"按等级排序", @"按状态排序"];
    stringPickerView.selectIndex = 1;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        NSLog(@"选择的值：%@", resultModel.value);
        self.selectSort = resultModel.value;
        [self reloadData];
    };
    [stringPickerView show];
    
}



@end
