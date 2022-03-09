//
//  Timu.h
//  cuotiben
//
//  Created by 陈志超 on 2022/2/24.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Timu : NSObject
@property(nonatomic,copy)NSString* Shuoming;
@property(nonatomic,copy)NSString* Kemu;
@property(nonatomic,copy)NSString* Dengji;
@property(nonatomic,copy)NSString* zhuangtai;
@property(nonatomic,assign)int CiShu;
@property(nonatomic,strong)UIImage* Tmimage;

@end

NS_ASSUME_NONNULL_END
