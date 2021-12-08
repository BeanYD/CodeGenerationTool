//
//  CGTPlayerView.m
//  CodeGenerationTool
//
//  Created by mac on 2021/11/29.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTPlayerView.h"
#import <AVKit/AVPlayerView.h>

@interface CGTPlayerView ()

@property (strong) AVPlayerView *playerView;

@end

@implementation CGTPlayerView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        NSString *urlstring = @"http://192.168.0.172/111.mp4";
        
        NSURL *url = [NSURL URLWithString:urlstring];
        
        self.playerView = [[AVPlayerView alloc] initWithFrame:NSMakeRect(CGRectGetWidth(self.frame) / 4, CGRectGetHeight(self.frame) / 4, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2)];
        [self addSubview:self.playerView];
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
        AVPlayer *avplayer = [[AVPlayer alloc] initWithPlayerItem:item];
        
        self.playerView.player = avplayer;

    }
    
    return self;
}

- (void)startPlayer {
    [self.playerView.player play];
}

- (void)stopPlayer {
    [self.playerView.player pause];
}

@end
