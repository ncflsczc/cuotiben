//
//  LangDuViewController.h
//  xunfeitest
//
//  Created by 陈志超 on 2022/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LangDuViewController : UIViewController
@property(nonatomic,copy)NSString*text;
-(void)readtext:(NSString *)text;
-(void)stopread;
@end

NS_ASSUME_NONNULL_END
