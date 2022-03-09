//
//  XiugaiTableViewController.h
//  cuotiben
//
//  Created by 陈志超 on 2022/2/25.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "Timu.h"
NS_ASSUME_NONNULL_BEGIN

@interface XiugaiTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *iconimg;
@property (weak, nonatomic) IBOutlet UIButton *kemubtn;
@property (weak, nonatomic) IBOutlet UIButton *dengjibtn;
@property (weak, nonatomic) IBOutlet UIButton *zhuangtaibt;
@property (weak, nonatomic) IBOutlet UITextField *shuomingtf;

@property (weak, nonatomic) IBOutlet UITextField *cishutf;
@property (strong, nonatomic) Timu*timu;

@end

NS_ASSUME_NONNULL_END
