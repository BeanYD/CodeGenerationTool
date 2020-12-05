//
//  CGTOpenglWindowController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/10/2.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTOpenglWindowController.h"

@interface CGTOpenglWindowController ()

@end

@implementation CGTOpenglWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
    if (self = [super initWithWindow:window]) {
        window.title = @"opengl使用";
        window.contentViewController = [self vc];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSViewController *)vc {
    NSViewController *vc = [[NSClassFromString(@"CGTOpenglViewController") alloc] initWithFrame:[CGTFrameConfig getDefaultWindowFrame]];
    return vc;
}
@end
