//
//  HDAVPlayerViewController.m
//  Player
//
//  Created by 魏宏昌 on 16/4/22.
//  Copyright © 2016年 恒大互联网中心. All rights reserved.
//

#import "HDAVPlayerViewController.h"
@import AVKit;//  画中画在iPad中支持，iPhone不支持
@import AVFoundation;//  音频框架，播放的是本地音频资源，不可以加载播放网络音频资源

@interface HDAVPlayerViewController () <AVPlayerViewControllerDelegate>
@property (nonatomic, strong) AVPlayer *avPlayer;//  AVKit框架
@property (nonatomic, strong) AVAudioSession *audioSession;//  AVFoundation框架
@property (nonatomic, strong) AVPlayerViewController *playerViewController;
@end

@implementation HDAVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadAVPlayer];
}

- (void)setUI {
    self.navigationItem.title = @"AVPlayer";
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithTitle:@"播放" style:UIBarButtonItemStylePlain target:self action:@selector(avPlayerStart)];
    UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"暂停" style:UIBarButtonItemStylePlain target:self action:@selector(avPlayerStop)];
    self.navigationItem.rightBarButtonItems = @[buttonItem2, buttonItem1];
}

- (void)loadAVPlayer {
    self.audioSession = [AVAudioSession sharedInstance];
    [self.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //  在 .bundle资源束里加载资源方式：
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"playSources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *sourcePath = [bundle pathForResource:@"1" ofType:@"mp4"];
    NSURL *sourceURL = [NSURL fileURLWithPath:sourcePath];
    self.avPlayer = [[AVPlayer alloc] initWithURL:sourceURL];
    //  iOS将废弃 MPMoviePlayerController，推荐使用 AVPlayerViewController
    self.playerViewController = [[AVPlayerViewController alloc] init];
    self.playerViewController.player = self.avPlayer;
    self.playerViewController.showsPlaybackControls = YES;
    self.playerViewController.delegate = self;
    self.playerViewController.allowsPictureInPicturePlayback = YES;//  画中画模式
    self.playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view addSubview:self.playerViewController.view];
    self.playerViewController.view.frame = CGRectMake(0, 80, self.view.frame.size.width, 350);
}

- (void)avPlayerStart {
    [self.playerViewController.player play];//  开始播放
}

- (void)avPlayerStop {
    [self.playerViewController.player pause];
}

#pragma mark - AVPlayerViewControllerDelegate
- (void)playerViewControllerWillStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%s", __FUNCTION__);
}

- (void)playerViewControllerDidStartPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%s", __FUNCTION__);
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

- (void)playerViewControllerWillStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%s", __FUNCTION__);
}

- (void)playerViewControllerDidStopPictureInPicture:(AVPlayerViewController *)playerViewController {
    NSLog(@"%s", __FUNCTION__);
}

- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController {
    NSLog(@"%s", __FUNCTION__);
    return true;
}

- (void)playerViewController:(AVPlayerViewController *)playerViewController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler {
    NSLog(@"%s", __FUNCTION__);
}

@end
