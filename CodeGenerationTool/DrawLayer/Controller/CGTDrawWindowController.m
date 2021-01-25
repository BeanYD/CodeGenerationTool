//
//  CGTDrawWindowController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/1/25.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTDrawWindowController.h"

@interface CGTDrawWindowController ()

@end

@implementation CGTDrawWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
    if (self = [super initWithWindow:window]) {
        self.window.title = @"画图";
        self.contentViewController = [self vc];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSViewController *)vc {
    NSViewController *vc = [[NSClassFromString(@"CGTDrawViewController") alloc] initWithFrame:[CGTFrameConfig getDefaultWindowFrame]];
    return vc;
}

@end
