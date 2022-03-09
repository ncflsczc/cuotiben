//
//  AppDelegate.m
//  cuotiben
//
//  Created by 陈志超 on 2022/2/18.
//

#import "AppDelegate.h"
#import "tabbar/tanbarViewController.h"
#import "CurrentState.h"
#define bg_tablename2 @"cuotiku22"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _CurrentkemuStr = @"语文";
    NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"biaoji"),bg_sqlValue(@"biaoji")];
    NSArray* arr = [CurrentState bg_find:bg_tablename2 where:where];
    if (!arr.count) {
        CurrentState *cs = [[CurrentState alloc]init];
        cs.biaoji = @"biaoji";
        cs.isOpenYuyin = YES;
        cs.bg_tableName = bg_tablename2;
        [cs bg_saveAsync:^(BOOL isSuccess) {
//            NSLog(@"chengg");
        }];
        NSString* where1 = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"biaoji"),bg_sqlValue(@"biaoji")];
        NSArray* arr1 = [CurrentState bg_find:bg_tablename2 where:where];
    }
//    _isOpenYuyin = YES;
    if (@available(iOS 13.0, *)) {
      
        } else {
          
            self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//            self.window.rootViewController = [[tanbarViewController alloc]init];
            self.window.backgroundColor = [UIColor whiteColor];
//            [self.window makeKeyAndVisible];
            
        }
    
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if (self.window) {
        if (url) {
            NSString *fileNameStr = [url lastPathComponent];
            NSString *Doc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/localFile"] stringByAppendingPathComponent:fileNameStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:Doc atomically:YES];
            NSLog(@"文件已存到本地文件夹内");
            self.window.rootViewController.view.backgroundColor = [UIColor cyanColor];
        }
    }
    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
