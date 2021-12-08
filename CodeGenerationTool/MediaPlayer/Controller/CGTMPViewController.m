//
//  CGTMPViewController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/10/29.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTMPViewController.h"
#import "CGTPlayerView.h"


@interface CGTMPViewController ()


@end

@implementation CGTMPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    CGTPlayerView *playerView = [[CGTPlayerView alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];

    [self.view addSubview:playerView];
    
    [playerView startPlayer];
}

@end
