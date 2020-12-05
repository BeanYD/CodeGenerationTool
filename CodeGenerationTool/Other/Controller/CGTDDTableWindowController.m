//
//  CGTDDTableWindowController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTDDTableWindowController.h"

@interface CGTDDTableWindowController ()

@end

@implementation CGTDDTableWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
	if (self = [super initWithWindow:window]) {
		window.title = @"列表视图";
		self.contentViewController = [self vc];
	}
	
	return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSViewController *)vc {
	NSViewController *vc = [[NSClassFromString(@"CGTDDTableViewController") alloc] initWithFrame:[CGTFrameConfig getDefaultWindowFrame]];
	return vc;
}

@end
