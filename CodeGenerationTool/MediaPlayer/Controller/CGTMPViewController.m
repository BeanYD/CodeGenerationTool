//
//  CGTMPViewController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/10/29.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTMPViewController.h"
#import <AVKit/AVPlayerView.h>

@interface CGTMPViewController ()

@property (strong) AVPlayerView *playerView;

@end

@implementation CGTMPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    NSString *urlstring = @"http://192.168.0.172/111.mp4";
    
//    NSString *pathStr = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *filePath = [NSString stringWithFormat:@"%@/1635234527775850.mp4", pathStr];
    NSURL *url = [NSURL URLWithString:urlstring];
    
    self.playerView = [[AVPlayerView alloc] initWithFrame:NSMakeRect(CGRectGetWidth(self.view.frame) / 4, CGRectGetHeight(self.view.frame) / 4, CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2)];
    [self.view addSubview:self.playerView];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
    AVPlayer *avplayer = [[AVPlayer alloc] initWithPlayerItem:item];
    
    self.playerView.player = avplayer;
    [self.playerView.player play];
    
    
    
}

@end
