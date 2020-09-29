//
//  CGTDDCollectionWindowController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTDDCollectionWindowController.h"

@interface CGTDDCollectionWindowController ()

@end

@implementation CGTDDCollectionWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
	if (self = [super initWithWindow:window]) {
		window.title = @"网格视图";
		window.contentViewController = [self vc];
	}
	
	return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSViewController *)vc {
	NSViewController *vc = [[NSClassFromString(@"CGTDDCollectionViewController") alloc] initWithFrame:[CGTFrameConfig getDefaultWindowFrame]];
	
	return vc;
}

@end
