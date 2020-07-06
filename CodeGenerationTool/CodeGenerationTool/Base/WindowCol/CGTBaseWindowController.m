//
//  CGTBaseWindowController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/4.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTBaseWindowController.h"

@interface CGTBaseWindowController ()


@end

@implementation CGTBaseWindowController

+ (instancetype)defaultWindowCol {
	// NSRectFromCGRect(CGRectMake(100, 100, 800, 600)) content的size跟随内部NSViewController.view的frame变动
	NSWindow *window = [[NSWindow alloc] initWithContentRect:NSRectFromCGRect(CGRectMake(100, 100, 0, 0))
												   styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable
													 backing:NSBackingStoreBuffered
													   defer:YES];
	NSLog(@"default window address:%p", window);
	CGTBaseWindowController *baseWindowCol = [[[self class] alloc] initWithWindow:window];
	return baseWindowCol;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)dealloc {
	NSLog(@"%@ dealloc", [self class]);
}

@end
