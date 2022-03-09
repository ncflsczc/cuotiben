//
//  CurrentState.h
//  cuotiben
//
//  Created by 陈志超 on 2022/3/8.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
NS_ASSUME_NONNULL_BEGIN

@interface CurrentState : NSObject
@property(nonatomic,assign)BOOL isOpenYuyin;
@property(nonatomic,copy)NSString* biaoji;
@end

NS_ASSUME_NONNULL_END
