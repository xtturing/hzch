//
//  AppDelegate.m
//  hzch
//
//  Created by xtturing on 15/9/6.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#define kClientID @"17VawA9qKb4w14Ch"
@interface AppDelegate ()
@property (strong, nonatomic) ViewController *viewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSError *error = nil;
    BOOL valid = [AGSRuntimeEnvironment setClientID:kClientID error:&error];
    if (!valid) {
        NSLog(@"setClientID failed: %@", error.localizedDescription);
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // 1.显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    // 2.主界面
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // initstance root_Vc
    ViewController *root_Vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    // set to rootViewController
    [[self window] setRootViewController:root_Vc];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
