//
//  CGTDeviceTestWindowController.m
//  CodeGenerationTool
//
//  Created by mac on 2020/10/14.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTDeviceTestWindowController.h"

@interface CGTDeviceTestWindowController ()

@end

@implementation CGTDeviceTestWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
    if (self = [super initWithWindow:window]) {
        window.title = @"设备检测";
        self.contentViewController = [self vc];
//        [window setIsZoomed:NO];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSViewController *)vc {
    NSViewController *vc = [[NSClassFromString(@"CGTDeviceTestViewController") alloc] initWithFrame:[CGTFrameConfig getDefaultWindowFrame]];
    return vc;
}

@end
