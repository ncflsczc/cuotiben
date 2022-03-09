//
//  YuYinViewController.h
//  xunfeitest
//
//  Created by 陈志超 on 2022/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ReturnBlock)(NSString*text);
@interface YuYinViewController : UIViewController
@property(nonatomic,strong)ReturnBlock returnblock;
@end

NS_ASSUME_NONNULL_END
