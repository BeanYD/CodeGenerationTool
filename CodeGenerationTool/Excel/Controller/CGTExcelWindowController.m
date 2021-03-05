//
//  CGTExcelWindowController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/3/5.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTExcelWindowController.h"

@interface CGTExcelWindowController ()

@end

@implementation CGTExcelWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
    if (self = [super initWithWindow:window]) {
        self.window.title = @"excel解析/导出";
        self.window.contentViewController = [self vc];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSViewController *)vc {
    NSViewController *vc = [[NSClassFromString(@"CGTExcelViewController") alloc] initWithFrame:[CGTFrameConfig getDefaultWindowFrame]];
    return vc;
}

@end
