//
//  CGTWeiQiWindowController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/9/24.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTWeiQiWindowController.h"

@interface CGTWeiQiWindowController ()

@end

@implementation CGTWeiQiWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
    if (self = [super initWithWindow:window]) {
        self.window.title = @"围棋";
        self.contentViewController = [self vc];
        
        // 隐藏zoom按钮
        [self.window standardWindowButton:NSWindowZoomButton].hidden = YES;
        
        // MARK: 代码设置窗口无法resize，NSWindowStyleMaskResizable按位取反后&，去除NSWindowStyleMaskResizable标志位
        [window setStyleMask:[window styleMask] & ~NSWindowStyleMaskResizable];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSViewController *)vc {
    NSViewController *vc = [[NSClassFromString(@"CGTWeiQiViewController") alloc] initWithFrame:[CGTFrameConfig getWeiQiBoardWindowFrame]];
    return vc;
}

@end
