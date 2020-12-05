//
//  NSWindowController+TitleBar.m
//  Training
//
//  Created by mac on 2020/10/16.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import "NSWindowController+TitleBar.h"
#import "CommonTitleBarViewController.h"
#import "CommonTitleView.h"

@implementation NSWindowController (TitleBar)

- (void)resetTitleBarWithTitle:(NSString *)titleString {
    self.window.backgroundColor = [NSColor colorWithRed:56.0/256 green:59.0/256 blue:66.0/256 alpha:1.0];
    CommonTitleView *titleView = [[CommonTitleView alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(self.window.frame), 30)];
    [titleView setTitleLabelString:titleString];
    [titleView setAutoresizingMask:NSViewWidthSizable|NSViewMinYMargin|NSViewMaxXMargin];
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.titlebarAppearsTransparent = YES;
    CommonTitleBarViewController *titleBar = [[CommonTitleBarViewController alloc] init];
    [titleBar.view setWantsLayer:YES];
    [titleBar.view.layer setBackgroundColor:[NSColor colorWithRed:51.0/256 green:53.0/256 blue:60.0/256 alpha:1.0].CGColor];
    [self.window addTitlebarAccessoryViewController:titleBar];
    NSView *themeView = [self.window.contentView superview];
    NSView* v = themeView.subviews[1].subviews[0];
    [v setWantsLayer:YES];
    [v.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    [v addSubview:titleView positioned:NSWindowBelow relativeTo:nil];
    [self.window makeKeyAndOrderFront:self];
}

@end
