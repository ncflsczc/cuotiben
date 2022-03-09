//
//  SceneDelegate.m
//  cuotiben
//
//  Created by 陈志超 on 2022/2/18.
//

#import "SceneDelegate.h"
#import "tabbar/tanbarViewController.h"
#import <WebKit/WebKit.h>
#import "LookFileViewController.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)){
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//    UIWindowScene *windowScene = (UIWindowScene *)scene;
//            self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//             self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
//             [self.window setWindowScene:windowScene];
//             [self.window setBackgroundColor:[UIColor whiteColor]];
//    self.window.rootViewController = [[tanbarViewController alloc]init];
//             
//             [self.window makeKeyAndVisible];
//            
   
}

-(void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts API_AVAILABLE(ios(13.0)){
    
    NSEnumerator *enumerator = [URLContexts objectEnumerator];
    if (@available(iOS 13.0, *)) {
        UIOpenURLContext *context;
        while (context = [enumerator nextObject]) {

            NSLog(@"context.URL1 =====%@", context.URL);
            NSURL *url = context.URL;
            NSString *urlString = [NSString stringWithFormat:@"%@",context.URL];
             if ([urlString hasPrefix:@"file://"]) {
                if ([urlString hasSuffix:@"docx"] || [urlString hasSuffix:@"doc"] || [urlString hasSuffix:@"txt"]|| [urlString hasSuffix:@"pdf"]) {
                    
//                    LookFileViewController *lfvc = [[LookFileViewController alloc]init];
//                    [self.window.rootViewController.navigationController showViewController:lfvc sender:nil];
                    
                    NSString *fileNameStr = [url lastPathComponent];
                    NSLog(@"filename.URL =====%@", fileNameStr);
                    NSString *Doc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/localFile"] stringByAppendingPathComponent:fileNameStr];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    [data writeToFile:Doc atomically:YES];
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
//                    NSString *dirPath = [Doc stringByDeletingLastPathComponent];
                     [fileManager createFileAtPath:Doc contents:nil attributes:nil];
                    NSLog(@"dac.URL =====%@", Doc);
                    NSLog(@"文件已存到本地文件夹内");
                    
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                    });
                    
                } else {
                    NSLog(@"该文件格式无法识别");
                }
            
         }
        }

    } else {
        // Fallback on earlier versions
    }
    

}

- (void)sceneDidDisconnect:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
