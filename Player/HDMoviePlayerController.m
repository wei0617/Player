//
//  HDMoviePlayerController.m
//  Player
//
//  Created by 魏宏昌 on 16/4/22.
//  Copyright © 2016年 恒大互联网中心. All rights reserved.
//

#import "HDMoviePlayerController.h"

@implementation HDMoviePlayerController

//  横屏显示
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
