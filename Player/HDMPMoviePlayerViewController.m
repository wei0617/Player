//
//  HDMPMoviePlayerViewController.m
//  Player
//
//  Created by 魏宏昌 on 16/3/2.
//  Copyright © 2016年 恒大互联网中心. All rights reserved.
//

#import "HDMPMoviePlayerViewController.h"

@implementation HDMPMoviePlayerViewController
//  横屏显示
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
@end
