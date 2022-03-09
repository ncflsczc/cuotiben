//
//  LoadDataListCollectionListViewController.h
//  JXCategoryView
//
//  Created by jiaxin on 2019/2/26.
//  Copyright © 2019 jiaxin. All rights reserved.
///Users/chenzhichao/Desktop/cuotiben/cuotiben.xcodeproj

#import "LoadDataListBaseViewController.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoadDataListCollectionListViewController : LoadDataListBaseViewController <JXCategoryListContentViewDelegate>
@property (nonatomic,copy)NSString *selectsort;
@end

NS_ASSUME_NONNULL_END
