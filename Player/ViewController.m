//
//  ViewController.m
//  Player
//
//  Created by 魏宏昌 on 16/3/2.
//  Copyright © 2016年 恒大互联网中心. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>//  音频，需本地资源，不可以加载网络资源
#import <MediaPlayer/MediaPlayer.h>//  视频+音频，可以加载网络资源（使用[NSURL URLWithString:@""]）
#import "HDMPMoviePlayerViewController.h"
#import <AVKit/AVKit.h>

//  gitHub下载：https://github.com/wei0617/Player.git

@interface ViewController () <AVAudioPlayerDelegate, AVPlayerViewControllerDelegate>
// 据我发现，音视频播放器对象 MPMoviePlayerController的对象要写成实例变量（成员变量）才能实现正常播放。在viewDidLoad方法里创建一个局部的对象不能正常播放，是一块黑板
// 但自定义的继承于 MPMoviePlayerViewController的对象可以是局部的，而且它还可以强制性横屏播放
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
//  HDMPMoviePlayerViewController继承于 MPMoviePlayerViewController而非 MPMoviePlayerController，否则播放不出
@property (nonatomic, strong) HDMPMoviePlayerViewController *player;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) AVPlayerViewController *playerViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButtonOperation];
    [self setupOtherUI];
    [self startAudioPlayer];
    [self startMPMoviePlayerController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.audioPlayer play];
    [self.moviePlayerController play];
}

- (void)startAVPlayer {
    //  画中画在iPad中支持，iPhone不支持，iOS将废弃 MPMoviePlayerController，推荐使用 AVPlayerViewController
    //  需要导入<AVKit/AVKit.h>系统框架
    [self userAVPlayer];
}

- (void)userAVPlayer {
    self.audioSession = [AVAudioSession sharedInstance];
    [self.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSURL *sourceURL = [NSURL fileURLWithPath:sourcePath];
    self.avPlayer = [AVPlayer playerWithURL:sourceURL];
    self.playerViewController = [[AVPlayerViewController alloc] init];
    self.playerViewController.player = self.avPlayer;
    self.playerViewController.showsPlaybackControls = YES;
    self.playerViewController.delegate = self;//  设置代理
    self.playerViewController.allowsPictureInPicturePlayback = YES;//  画中画模式
    self.playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerViewController.view.frame = self.view.frame;
    [self.view addSubview:self.playerViewController.view];
    [self.playerViewController.player play];//  开始播放
}

- (void)startPlay {
    [self.moviePlayerController stop];
    [self.audioPlayer stop];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSURL *sourceURL = [NSURL fileURLWithPath:sourcePath];
    self.player = [[HDMPMoviePlayerViewController alloc] initWithContentURL:sourceURL];
    //视频播放器有自己的模态弹出事件  若果使用它自己的  不需要写明play 方法
    //[self presentMoviePlayerViewControllerAnimated:moviewPlayerViewController];
    // 自定义的视频播放器 可以强制横屏
    [self presentMoviePlayerViewControllerAnimated:self.player];
    
    // 系统的 可以模态弹出的视频播放器
//    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:sourceURL];
//    [self presentViewController:moviePlayerViewController animated:YES completion:nil];
}

- (void)startMPMoviePlayerController {
    //  MPMoviePlayerController 与AVAudioPlayer有点类似，前者播放视频，后者播放音频，不过也有很大不同，MPMoviePlayerController 可以直接通过远程URL初始化，而AVAudioPlayer则不可以。
    //  格式支持：MOV、MP4、M4V、与3GP等格式，还支持多种音频格式。
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSURL *sourceURL = [NSURL fileURLWithPath:sourcePath];
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:sourceURL];
    [self.view addSubview:self.moviePlayerController.view];
    [self.moviePlayerController prepareToPlay];
    self.moviePlayerController.view.frame = CGRectMake(100, 250, 200, 200);
    self.moviePlayerController.shouldAutoplay = YES;
    self.moviePlayerController.controlStyle = MPMovieControlStyleDefault;
//    self.moviePlayerController.repeatMode = MPMovieRepeatModeNone;
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
    
    //    MPMoviePlayerContentPreloadDidFinishNotification
    //    当电影播放器结束对内容的预加载后发出。因为内容可以在仅加载了一部分的情况下播放，所以这个通知可能在已经播放后才发出。
    //    MPMoviePlayerScallingModeDidChangedNotification
    //    当用户改变了电影的缩放模式后发出。用户可以点触缩放图标，在全屏播放和窗口播放之间切换。
    //    MPMoviePlayerPlaybackDidFinishNotification
    //    当电影播放完毕或者用户按下了Done按钮后发出。
    
    //   MPMoviePlayerController* moviewPlayerNew = [[MPMoviePlayerController  alloc]initWithContentURL:url];
    //    moviewPlayerNew.view.frame = CGRectMake(0, 20, 300, 200);
    //
    //    [self.view addSubview:moviewPlayerNew.view];
    //    [moviewPlayerNew play];
}

- (void)setupOtherUI {
    _progressView = [[UIProgressView alloc] init];
    [self.view addSubview:_progressView];
    _progressView.frame = CGRectMake(40, 100, 200, 20);
    _progressView.progressTintColor = [UIColor magentaColor];
    _progressView.trackTintColor = [UIColor greenColor];
    
    _slider = [[UISlider alloc] init];
    [self.view addSubview:_slider];
    _slider.frame = CGRectMake(20, 50, 200, 20);
    _slider.value = 0.5;
    [_slider addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)createButtonOperation {
    //初始化三个button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(100, 100, 60, 40)];
    [button setTitle:@"Play" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(100, 150, 60, 40)];
    [button1 setTitle:@"pause" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:CGRectMake(100, 200, 60, 40)];
    [button2 setTitle:@"stop" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button4 setFrame:CGRectMake(100, 100, 260, 40)];
    [button4 setTitle:@"自定义的MPMoviePlayController播放视频" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button5 setFrame:CGRectMake(100, 60, 260, 40)];
    [button5 setTitle:@"startAVPlayer" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(startAVPlayer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
    
}

- (void)pause {
    [self.audioPlayer pause];
    [_timer invalidate];
    _timer = nil;
}

- (void)play {
    [self.audioPlayer play];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeOn) userInfo:nil repeats:YES];
}

- (void)stop {
    [self.audioPlayer stop];
    [_timer invalidate];
    _timer = nil;
    _progressView.progress = 0;
    self.audioPlayer.currentTime = 0;
}

- (void)stepperValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.audioPlayer.volume = slider.value;
}

- (void)timeOn {
    _progressView.progress = self.audioPlayer.currentTime/self.audioPlayer.duration*1.0;
}

//  真机调试，模拟器不支持线控
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"点按一下，播放/暂停");
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"连续点按二下，下一首");
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"连续点按三下，上一首");
                break;
                
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                NSLog(@"连续点按两下不放，开始快退");
                break;
                
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                NSLog(@"松开，结束快退");
                break;
                
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                NSLog(@"点按一下不放，开始快进");
                break;
                
            case UIEventSubtypeRemoteControlEndSeekingForward:
                NSLog(@"松开，结束快进");
                break;
                
            default:
                break;
        }
    }
    NSLog(@"%s", __FUNCTION__);
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"开始摇一摇动作");
    }
    NSLog(@"%s", __FUNCTION__);
}

//  motionEnded和motionCancelled一般情况不会被调用
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventTypeMotion) {
        NSLog(@"结束摇一摇动作");
    }
    NSLog(@"%s", __FUNCTION__);
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"%s", __FUNCTION__);
    if (motion == UIEventTypeMotion) {
        NSLog(@"摇一摇被取消掉了，来电话等情况被取消了");
    }
}

- (void)startAudioPlayer {
    // 通过文件路径获取URL，不能使用 [NSURL URLWithString:@""]; 拿出来是因为我们很容易用错对象
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"陶钰玉 - 深夜地下铁" ofType:@"mp3"];
    NSURL *sourceURL = [NSURL fileURLWithPath:sourcePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:sourceURL error:nil];
    //  enableRate要在调用prepareToPlay之前设置
    self.audioPlayer.enableRate = YES;
    //  设置播放速率，1.0 为正常播放速度，默认速度
    //  设置enableRate为YES时才生效
    self.audioPlayer.rate = 1.0;
    [self.audioPlayer prepareToPlay];
    //  -1为无限循环播放，0为播放一次，1为播放2次，依次类推
    self.audioPlayer.numberOfLoops = -1;
    //  volume取值为0-1
    self.audioPlayer.volume = 0.8;
    //  pan值-1.0为left（设为此时可能播放不出音频），0.0为center，1.0为right
    self.audioPlayer.pan = 0.0;
    //  duration播放时长，只读属性
    NSLog(@"%.2f--%f", self.audioPlayer.duration, self.audioPlayer.deviceCurrentTime);
    NSLog(@"%@", self.audioPlayer.settings);
    
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeOn) userInfo:nil repeats:YES];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"%@", error);
}

//  当audioPlayer自然成功播放完后调用，中间暂停或打断不会调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"%s", __FUNCTION__);
}

//  打断的回调
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"%s", __FUNCTION__);
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    NSLog(@"%s", __FUNCTION__);
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    NSLog(@"%s", __FUNCTION__);
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
    NSLog(@"%s", __FUNCTION__);
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
