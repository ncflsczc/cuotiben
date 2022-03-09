//
//  LoadDataListBaseViewController.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//
#define Width [UIScreen mainScreen].bounds.size.width
#define bg_createTimeKey @"bg_createTime"
#define bg_updateTimeKey @"bg_updateTime"
#define bg_tablename @"cuotiku"

#import "LoadDataListBaseViewController.h"
#import "CzcBJViewController.h"
#import "MJRefresh.h"
#import "Timu.h"
#import "BijiTableViewCell.h"
#import "TJTableViewController.h"
#import "XiugaiTableViewController.h"
#import "GKPhotoBrowser.h"

@interface LoadDataListBaseViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isDataLoaded;
@property (nonatomic,assign)BOOL isload;
@property (nonatomic,copy)NSString *TJORXGStr;
@property (nonatomic,strong)NSIndexPath *path;

@end

@implementation LoadDataListBaseViewController

- (void)dealloc
{
    self.didScrollCallback = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isload = NO;
    self.path = [[NSIndexPath alloc]init];
    _TJORXGStr = [[NSString alloc]init];
    //长按手势
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressAction:)];
        [self.tableView addGestureRecognizer:longpress];

    self.dataSource = [NSMutableArray array];
    NSLog(@"%@",self.title);
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView registerNib:
    [UINib nibWithNibName:@"bijitabviewcell" bundle:nil] forCellReuseIdentifier:@"bijitabviewcell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kongcell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _isload = NO;
    _TJORXGStr = @"";
    [self headerRefresh];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self headerRefresh];
}
- (void)pressAction:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan &&self.dataSource.count) {//手势开始
        CGPoint point = [longPressGesture locationInView:self.tableView];
        NSIndexPath *currentIndexPath = [self.tableView indexPathForRowAtPoint:point]; // 可以获取我们在哪个cell上长按
        NSMutableArray *photos = [NSMutableArray new];
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           GKPhoto *photo = [GKPhoto new];
         Timu *timu = [[Timu alloc]init];
         timu = (Timu*)self.dataSource[idx];
            photo.image = timu.Tmimage;
           [photos addObject:photo];
        }];

        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:currentIndexPath.row];
        browser.showStyle = GKPhotoBrowserShowStyleNone;

        [browser showFromVC:self];
        
        NSLog(@"%ld",currentIndexPath.section);
    }
}

- (void)headerRefresh {
    [self.tableView.mj_header beginRefreshing];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.dataSource removeAllObjects];
        NSString *typestr = [[NSString alloc] init];
        if ([self.selectsort isEqualToString:@"按科目排序"]) {
            typestr = @"Kemu";
        }else if([self.selectsort isEqualToString:@"按时间排序"]) {

            typestr = bg_createTimeKey;
        }else if([self.selectsort isEqualToString:@"按等级排序"]) {
            typestr = @"Dengji";
        }else{
            typestr = @"zhuangtai";
        }
        [self GetData:typestr vlaue:self.title];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - 数据库操作
-(void)GetData:(NSString*)key vlaue:(NSString*)value{
    NSArray *arr = [[NSArray alloc]init];
    NSString* where = [[NSString alloc]init];
    NSString *str1 = [[NSString alloc]init];
    if([key isEqualToString:bg_createTimeKey]){
        arr = [Timu bg_find:bg_tablename limit:0 orderBy:key desc:YES];
    }else{
        
            if ([value isEqualToString:@"非常重要"]) {
                str1 = @"非常重要:A";
            }else if([value isEqualToString:@"重要"]) {
                str1 = @"重要:B";
            }else if([value isEqualToString:@"一般"]) {
                str1 = @"一般:C";
            }else if([value isEqualToString:@"不重要"]){
                str1 = @"不重要:D";
            }else{
                str1 = value;
            }
        
        where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(key),bg_sqlValue(str1)];
        arr = [Timu bg_find:bg_tablename where:where];
    }
    
    self.dataSource = [NSMutableArray arrayWithArray:arr];
    if (arr.count==0) {
        _isload = YES;
    }
}

- (void)loadDataForFirst {
    //第一次才加载，后续触发的不处理
    if (!self.isDataLoaded) {
        [self headerRefresh];
        self.isDataLoaded = YES;
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.didScrollCallback ?: self.didScrollCallback(scrollView);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource.count==0&&_isload) {
        return 1;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0 &&self.dataSource.count==0&&_isload) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kongcell" forIndexPath:indexPath];
        cell.textLabel.text = @"您还没有导入该类型题目，请添加！";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
//    BijiTableViewCell *bijicell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    BijiTableViewCell *bijicell = [tableView dequeueReusableCellWithIdentifier:@"bijitabviewcell"];
    Timu *timu = [[Timu alloc]init];
    timu = (Timu*)self.dataSource[indexPath.row];
    if ([timu.Dengji isEqualToString:@"非常重要:A"]) {
        bijicell.dengjiimg.image = [UIImage imageNamed:@"A"];
    }else if([timu.Dengji isEqualToString:@"重要:B"]) {
        bijicell.dengjiimg.image = [UIImage imageNamed:@"B"];
    }else if ([timu.Dengji isEqualToString:@"一般:C"]) {
        bijicell.dengjiimg.image = [UIImage imageNamed:@"C"];
    }else{
        bijicell.dengjiimg.image = [UIImage imageNamed:@"D"];
    }
    NSString *kemustring = [NSString new];
    if ([timu.Kemu isEqualToString:@"语文"]) {
        kemustring = @"语";
    }else if ([timu.Kemu isEqualToString:@"数学"]) {
        kemustring = @"数";
    }else if ([timu.Kemu isEqualToString:@"英语"]) {
        kemustring = @"英";
    }
    else if ([timu.Kemu isEqualToString:@"物理"]) {
        kemustring = @"物理";
    }
    else if ([timu.Kemu isEqualToString:@"化学"]) {
        kemustring = @"化学";
    }
    else if ([timu.Kemu isEqualToString:@"生物"]) {
        kemustring = @"生物";
    }
    else if ([timu.Kemu isEqualToString:@"政治"]) {
        kemustring = @"政治";
    }
    else if ([timu.Kemu isEqualToString:@"历史"]) {
        kemustring = @"历史";
    }
    else if ([timu.Kemu isEqualToString:@"地理"]) {
        kemustring = @"地理";
    }
    else if ([timu.Kemu isEqualToString:@"其它"]) {
        kemustring = @"其";
    }
    bijicell.kemulab.text = kemustring;
    bijicell.timuimg.image = timu.Tmimage;
    bijicell.shuominglab.text = [NSString stringWithFormat:@"%@,%@,已做错%d次。  %@",timu.Shuoming,timu.zhuangtai,timu.CiShu,timu.bg_createTime];
    return bijicell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0 &&self.dataSource.count==0&&_isload){
        return 50;
    }else
        return 260 ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataSource.count==0)
        return ;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    XiugaiTableViewController *xgvc = [storyboard instantiateViewControllerWithIdentifier:@"xiugaibiji"];
    Timu *timu = [[Timu alloc]init];
    timu = (Timu*)self.dataSource[indexPath.row];
    xgvc.timu = timu;
    
//    [self.navigationController pushViewController:xgvc animated:YES];
    [self.navigationController showViewController:xgvc sender:nil];

    
}
#pragma mark - JXCategoryListCollectionContentViewDelegate

- (UIView *)listView {
    return self.view;
}

//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([_TJORXGStr isEqualToString:@"xiugai"]) {
//        TJTableViewController *tj = segue.destinationViewController;
//            Timu *timu = [[Timu alloc]init];
//            timu = (Timu*)self.dataSource[self.path.row];
//            tj.xiugaitimu = timu;
//    }
//
//
//    [super prepareForSegue:segue sender:sender];
//}
@end
