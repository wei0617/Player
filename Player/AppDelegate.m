//
//  AppDelegate.m
//  Player
//
//  Created by 魏宏昌 on 16/3/2.
//  Copyright © 2016年 恒大互联网中心. All rights reserved.
//

#import "AppDelegate.h"
@import AVFoundation;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //  开启远程控制事件，耳机线控！
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self navigationBarConfig];
    BOOL is = [AppDelegate isHeadphone];
    NSLog(@"%d", is);
    return YES;
}

- (void)navigationBarConfig {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20], NSForegroundColorAttributeName: [UIColor magentaColor]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor greenColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
}

//获取设备状态，是否插入耳机，如果插入耳机，则返回“YES" BY Leisure
+ (BOOL)isHeadphone
{
    UInt32 propertySize = sizeof(CFStringRef);
    CFStringRef state = nil;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
                            ,&propertySize,&state);
    //return @"Headphone" or @"Speaker" and so on.
    //根据状态判断是否为耳机状态
    if ([(__bridge NSString *)state isEqualToString:@"Headphone"] ||[(__bridge NSString *)state isEqualToString:@"HeadsetInOut"])
    {
        return YES;
    }
    else {
        return NO;
    }
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
