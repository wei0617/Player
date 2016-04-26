//
//  HDMoviePlayerViewController.m
//  Player
//
//  Created by 魏宏昌 on 16/4/22.
//  Copyright © 2016年 恒大互联网中心. All rights reserved.
//

#import "HDMoviePlayerViewController.h"
#import "HDMoviePlayerController.h"
@import MediaPlayer;

@interface HDMoviePlayerViewController ()
//  MPMoviePlayerController已经废弃，推荐开发者使用AVKit框架中的AVPlayerViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
#pragma clang diagnostic pop

// 据我发现，音视频播放器对象 MPMoviePlayerController的对象要写成实例变量（成员变量）才能实现正常播放。在viewDidLoad方法里创建一个局部的对象不能正常播放，是一块黑板
// 但自定义的继承于 MPMoviePlayerViewController的对象可以是局部的，而且它还可以强制性横屏播放
@property (nonatomic, strong) HDMoviePlayerController *myMoviePlayer;//  HDMoviePlayerController : MPMoviePlayerViewController，而非 MPMoviePlayerController，两者有区别用时又很容易混
@end

@implementation HDMoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MoviePlayer";
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithTitle:@"播放1" style:UIBarButtonItemStylePlain target:self action:@selector(moviePlayerStart)];
    self.navigationItem.rightBarButtonItem = buttonItem1;
    UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"播放2" style:UIBarButtonItemStylePlain target:self action:@selector(moviePlayerStart2)];
    self.navigationItem.rightBarButtonItems = @[buttonItem2, buttonItem1];
}

- (void)moviePlayerStart {
    NSURL *sourceURL = [self commonMethod];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.myMoviePlayer = [[HDMoviePlayerController alloc] initWithContentURL:sourceURL];
    [self presentMoviePlayerViewControllerAnimated:self.myMoviePlayer];
#pragma clang diagnostic pop
}

- (NSURL *)commonMethod {
    //  在 .bundle资源束里加载资源方式：
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"playSources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *sourcePath = [bundle pathForResource:@"1" ofType:@"mp4"];
    NSURL *sourceURL = [NSURL fileURLWithPath:sourcePath];
    return sourceURL;
}

- (void)moviePlayerStart2 {
    //  MPMoviePlayerController 与AVAudioPlayer有点类似，前者播放视频，后者播放音频，不过也有很大不同，MPMoviePlayerController 可以直接通过远程URL初始化，而AVAudioPlayer则不可以。
    //  格式支持：MOV、MP4、M4V、与3GP等格式，还支持多种音频格式。
    
    NSURL *sourceURL = [self commonMethod];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:sourceURL];
    [self.view addSubview:self.moviePlayerController.view];
    self.moviePlayerController.view.frame = CGRectMake(0, 80, self.view.frame.size.width, 350);
    [self.moviePlayerController prepareToPlay];
    self.moviePlayerController.shouldAutoplay = YES;
    self.moviePlayerController.controlStyle = MPMovieControlStyleDefault;
    self.moviePlayerController.repeatMode = MPMovieRepeatModeNone;
    [self.moviePlayerController play];
    
    //[self.moviePlayerController setFullscreen:YES];
    
    self.moviePlayerController.repeatMode = MPMovieRepeatModeNone;
    //    MPMovieControlModeDefault            显示播放/暂停、音量和时间控制
    //    MPMovieControlModeVolumeOnly         只显示音量控制
    //    MPMovieControlModeHidden             没有控制器
    
    //    MPMovieScallingModeNone            不做任何缩放
    //    MPMovieScallingModeAspectFit       适应屏幕大小，保持宽高比
    //    MPMovieScallingModeAspectFill      适应屏幕大小，保持宽高比，可裁剪
    //    MPMovieScallingModeFill            充满屏幕，不保持宽高比
    
    self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
#pragma clang diagnostic pop
    
    //    MPMoviePlayerContentPreloadDidFinishNotification
    //    当电影播放器结束对内容的预加载后发出。因为内容可以在仅加载了一部分的情况下播放，所以这个通知可能在已经播放后才发出。
    //    MPMoviePlayerScallingModeDidChangedNotification
    //    当用户改变了电影的缩放模式后发出。用户可以点触缩放图标，在全屏播放和窗口播放之间切换。
    //    MPMoviePlayerPlaybackDidFinishNotification
    //    当电影播放完毕或者用户按下了Done按钮后发出。
    
    //   MPMoviePlayerController* moviewPlayerNew = [[MPMoviePlayerController  alloc]initWithContentURL:url];
    //    moviewPlayerNew.view.frame = CGRectMake(0, 20, 300, 200);
    //    [self.view addSubview:moviewPlayerNew.view];
    //    [moviewPlayerNew play];
}

@end
