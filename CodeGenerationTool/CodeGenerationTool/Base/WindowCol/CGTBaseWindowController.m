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
	// NSRectFromCGRect(CGRectZero) content的size跟随内部NSViewController.view的frame变动，可以直接在window上设置zero，不需要关注
	NSWindow *window = [[NSWindow alloc] initWithContentRect:NSRectFromCGRect(CGRectZero)
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
