//
//  CGTMainWindowController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/4.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTMainWindowController.h"
#import "CGTTitleBarViewController.h"
#import "CGTCommonTitleView.h"
#import "NSWindowController+TitleBar.h"

@interface CGTMainWindowController ()

@end

@implementation CGTMainWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
	if (self = [super initWithWindow:window]) {
		window.title = @"skd项目";
		self.contentViewController = [self vc];
	}
	
	return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    // 重新设置titleBar，先通过xib实现，后续进行无xib探究
    CGTCommonTitleView *titleView = [[CGTCommonTitleView alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(self.window.frame), 30)];
    [titleView setTitleLabelText:@"自动生成工具"];
    [titleView setAutoresizingMask:NSViewWidthSizable|NSViewMinYMargin|NSViewMaxXMargin];
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.titlebarAppearsTransparent = YES;
    CGTTitleBarViewController *titleBar = [[CGTTitleBarViewController alloc] init];
    [titleBar.view setWantsLayer:YES];
    [titleBar.view.layer setBackgroundColor:[NSColor colorWithRed:51.0/256 green:53.0/256 blue:60.0/256 alpha:1.0].CGColor];
    [self.window addTitlebarAccessoryViewController:titleBar];
    NSView *themeView = [self.window.contentView superview];
    NSView* v = themeView.subviews[1].subviews[0];
    [v setWantsLayer:YES];
    [v.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    [v addSubview:titleView positioned:NSWindowBelow relativeTo:nil];
    
#pragma mark - 2020-10-21 更新 上述代码可废弃
    // TODO: 已在NSWindowController+TitleBar中封装，直接调用该分类中的方法即可，后续修改


    
}

- (NSViewController *)vc {
	NSViewController *vc = [[NSClassFromString(@"CGTMainViewController") alloc] initWithFrame:[CGTFrameConfig getDefaultWindowFrame]];
	return vc;
}

@end
