//
//  HDAudioPlayerViewController.m
//  Player
//
//  Created by 魏宏昌 on 16/4/26.
//  Copyright © 2016年 恒大互联网中心. All rights reserved.
//

#import "HDAudioPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>//  音频，需本地资源，不可以加载网络资源

@interface HDAudioPlayerViewController () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UISlider *slider;
@end

@implementation HDAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self prepareAudioPlayer];
}

- (void)setUI {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"暂停" style:UIBarButtonItemStylePlain target:self action:@selector(pause)];
    UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"停止" style:UIBarButtonItemStylePlain target:self action:@selector(stop)];
    UIBarButtonItem *buttonItem3 = [[UIBarButtonItem alloc] initWithTitle:@"播放" style:UIBarButtonItemStylePlain target:self action:@selector(play)];
    self.navigationItem.rightBarButtonItems = @[buttonItem, buttonItem2, buttonItem3];
    
    _progressView = [[UIProgressView alloc] init];
    [self.view addSubview:_progressView];
    _progressView.frame = CGRectMake(40, 200, 200, 20);
    _progressView.progressTintColor = [UIColor magentaColor];
    _progressView.trackTintColor = [UIColor greenColor];
    
    _slider = [[UISlider alloc] init];
    [self.view addSubview:_slider];
    _slider.frame = CGRectMake(40, 250, 200, 20);
    _slider.value = 0.5;
    [_slider addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)prepareAudioPlayer {
    // 通过文件路径获取URL，不能使用 [NSURL URLWithString:@""]; 强调出来是因为我们很容易用错对象
    //  在 .bundle资源束里加载资源方式：
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"playSources.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *sourcePath = [bundle pathForResource:@"陶钰玉 - 深夜地下铁" ofType:@"mp3"];
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

#pragma mark - 耳机线控事件
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

@end
