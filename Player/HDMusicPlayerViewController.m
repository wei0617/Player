//
//  HDMusicPlayerViewController.m
//  Player
//
//  Created by 魏宏昌 on 16/4/26.
//  Copyright © 2016年 恒大互联网中心. All rights reserved.
//

#import "HDMusicPlayerViewController.h"
@import MediaPlayer;

@interface HDMusicPlayerViewController () <MPMediaPickerControllerDelegate>
@property (nonatomic, strong) MPMusicPlayerController *myMusicPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation HDMusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)startMusicPlayer:(id)sender {
    MPMediaPickerController * mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    if (mediaPicker) {
        NSLog(@"Successfully instantiated a media picker");
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = YES;
        [self presentViewController:mediaPicker animated:YES completion:nil];
    } else {
        NSLog(@"Could not instantiate a media picker");
    }
}

- (IBAction)stopMusicPlayer:(id)sender {
    if (self.myMusicPlayer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.myMusicPlayer];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.myMusicPlayer];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMusicPlayerControllerVolumeDidChangeNotification object:self.myMusicPlayer];
        [self.myMusicPlayer stop];
    }
}

- (IBAction)getMusicDetailMessage:(id)sender {
    MPMediaItem *nowPlayItem = [self.myMusicPlayer nowPlayingItem];
    //获取当前播放的歌曲
    if (nowPlayItem){
        MPMediaItemArtwork *artwork = [nowPlayItem valueForProperty:MPMediaItemPropertyArtwork]; //获取artwork，这里是为获取专辑封面做铺垫
        NSString *songtitle = [nowPlayItem valueForProperty:MPMediaItemPropertyTitle]; //获取歌曲标题
        NSString *albumTitle = [nowPlayItem valueForProperty:MPMediaItemPropertyAlbumTitle]; //获取专辑标题
        NSString *artist = [nowPlayItem valueForProperty:MPMediaItemPropertyArtist]; //获取歌手姓名
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        songtitle = [songtitle stringByAppendingString:@"/n"];
        songtitle = [songtitle stringByAppendingString:albumTitle];
        songtitle = [songtitle stringByAppendingString:@"/n"];
        songtitle = [songtitle stringByAppendingString:artist];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setNumberOfLines:3];
        [titleLabel setHighlighted:YES];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [titleLabel setText:songtitle];
        titleLabel.numberOfLines = 0;
        self.navigationItem.titleView = titleLabel;
        //  获得的图片
        UIImage *image = [artwork imageWithSize:CGSizeMake(300, 200)];
        _imageView.image = image;
        self.view.backgroundColor = [UIColor yellowColor];
    }
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    NSLog(@"%s", __FUNCTION__);
    self.myMusicPlayer = [[MPMusicPlayerController alloc] init];
    [self.myMusicPlayer beginGeneratingPlaybackNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerStatedChanged:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.myMusicPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingItemIsChanged:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.myMusicPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeIsChanged:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:self.myMusicPlayer];
    
    [self.myMusicPlayer setQueueWithItemCollection:mediaItemCollection];
    
    [self.myMusicPlayer play];
    
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    NSLog(@"%s", __FUNCTION__);
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)musicPlayerStatedChanged:(NSNotification *)paramNotification {
    NSLog(@"%s", __FUNCTION__);
    NSNumber * stateAsObject = [paramNotification.userInfo objectForKey:@"MPMusicPlayerControllerPlaybackStateKey"];
    NSInteger state = [stateAsObject integerValue];
    switch (state) {
        case MPMusicPlaybackStateStopped:
            //  operation
            break;
            
        case MPMusicPlaybackStatePlaying:
            break;
            
        case MPMusicPlaybackStatePaused:
            break;
            
        case MPMusicPlaybackStateInterrupted:
            break;
            
        case MPMusicPlaybackStateSeekingForward:
            break;
            
        case MPMusicPlaybackStateSeekingBackward:
            break;
            
        default:
            break;
    }
}

- (void)nowPlayingItemIsChanged:(NSNotification *)paramNotification {
    NSLog(@"%s", __FUNCTION__);
    NSString *persistentID = [paramNotification.userInfo objectForKey:@"MPMusicPlayerControllerNowPlayingItemPersistentIDKey"];
    NSLog(@"Persistent ID = %@",persistentID);
}

- (void)volumeIsChanged:(NSNotification *)paramNotification {
    NSLog(@"%s", __FUNCTION__);
}

@end
