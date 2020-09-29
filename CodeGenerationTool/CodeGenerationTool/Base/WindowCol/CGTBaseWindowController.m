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
	NSWindow *window = [[NSWindow alloc] initWithContentRect:[CGTFrameConfig getDefaultWindowFrame]
												   styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable
													 backing:NSBackingStoreBuffered
													   defer:YES];
	NSLog(@"default window address:%p", window);
	window.restorable = NO;
	
	// window 需要默认设置一个 frame，保证 viewController 能显示，后续的显示位置及大小由 viewController 初始化方法 -initWithFrame 进行设置
//	[window setFrame:[CGTFrameConfig getDefaultWindowFrame] display:NO];
	[window center];
	
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
