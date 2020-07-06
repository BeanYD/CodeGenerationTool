//
//  CGTMainWindowController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/4.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTMainWindowController.h"

@interface CGTMainWindowController ()

@end

@implementation CGTMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (instancetype)initWithWindow:(NSWindow *)window {
	if (self = [super initWithWindow:window]) {
		self.window.title = @"自动生成工具";
		self.contentViewController = [self vc];
	}
	
	return self;
}

- (NSViewController *)vc {
	NSViewController *vc = [[NSClassFromString(@"CGTMainViewController") alloc] init];
	return vc;
}

@end
