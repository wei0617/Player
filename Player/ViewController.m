//
//  ViewController.m
//  Player
//
//  Created by 魏宏昌 on 16/3/2.
//  Copyright © 2016年 恒大互联网中心. All rights reserved.
//

#import "ViewController.h"
#import "HDAudioPlayerViewController.h"
#import "HDAVPlayerViewController.h"
#import "HDMoviePlayerViewController.h"
#import "HDMusicPlayerViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = @[@"AudioPlayer", @"MusicPlayer", @"AVPlayer", @"MoviePlayer"];
    self.tableView.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifer = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifer];
    }
    cell.textLabel.text = self.array[indexPath.row];
    cell.textLabel.textColor = [UIColor redColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            [self toAudioPlayerViewController];
        }
            break;
            
        case 1:
        {
            [self toMusicPlayerViewController];
        }
            break;
            
        case 2:
        {
            [self toAVPlayerViewController];
        }
            break;
            
        case 3:
        {
            [self toMoviePlayerController];
        }
            break;
            
        default:
            break;
    }
}

- (void)toAudioPlayerViewController {
    [self.navigationController pushViewController:[HDAudioPlayerViewController new] animated:YES];
}

- (void)toAVPlayerViewController {
    [self.navigationController pushViewController:[HDAVPlayerViewController new] animated:YES];
}

- (void)toMoviePlayerController {
    [self.navigationController pushViewController:[HDMoviePlayerViewController new] animated:YES];
}

- (void)toMusicPlayerViewController {
    [self.navigationController pushViewController:[HDMusicPlayerViewController new] animated:YES];
}
@end
