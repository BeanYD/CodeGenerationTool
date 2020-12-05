//
//  CGTMouseEventWindowController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/10/3.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTMouseEventWindowController.h"

@interface CGTMouseEventWindowController ()

@end

@implementation CGTMouseEventWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
    if (self = [super initWithWindow:window]) {
        window.title = @"鼠标事件";
        window.contentViewController = [self vc];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSViewController *)vc {
    NSViewController *vc = [[NSClassFromString(@"CGTMouseEventViewController") alloc] initWithFrame:[CGTFrameConfig getDefaultWindowFrame]];
    return vc;
}

@end
