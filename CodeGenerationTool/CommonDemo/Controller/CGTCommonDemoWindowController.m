//
//  CGTCommonDemoWindowController.m
//  CodeGenerationTool
//
//  Created by mac on 2020/10/23.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTCommonDemoWindowController.h"

@interface CGTCommonDemoWindowController ()



@end

@implementation CGTCommonDemoWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
    if (self = [super initWithWindow:window]) {
        window.title = @"公共组件demo";
        self.window.contentViewController = [self vc];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSViewController *)vc {
    NSViewController *vc = [[NSClassFromString(@"CGTCommonDemoViewController") alloc] initWithFrame:[CGTFrameConfig getDefaultWindowFrame]];
    return vc;
}
@end
