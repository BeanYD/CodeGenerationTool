//
//  CGTFrameConfig.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTFrameConfig.h"
#import "AppDelegate.h"

@implementation CGTFrameConfig

+ (CGRect)getDefaultWindowFrame {
	CGRect screenFrame = [NSScreen mainScreen].frame;
	screenFrame.size.width = screenFrame.size.width / 2;
	screenFrame.size.height = screenFrame.size.height / 2;
	
	return screenFrame;
}

+ (CGRect)getHalfWidthDefaultWindowFrame {
	CGRect screenFrame = [NSScreen mainScreen].frame;
	screenFrame.size.width = screenFrame.size.width / 4;
	screenFrame.size.height = screenFrame.size.height / 2;
	return screenFrame;
}



/**
 * 设置view相对主window子视图的中心位置对应的original坐标
 * 调用：[_window setFrameOrigin:[CGTFrameConfig positionInSubviewsWithView:_window.contentView]];
 */

+ (NSPoint)positionInSubviewsWithView:(NSView *)view {
    AppDelegate *app = (AppDelegate *)[NSApplication sharedApplication].delegate;
    NSView *contentView = app.mainWindow.window.contentView;
    // 将contentView的坐标转换到屏幕Screen上的坐标
    CGRect pointOnScreen = [app.mainWindow.window convertRectToScreen:contentView.frame];
    CGRect targetFrame = view.frame;
    NSPoint position = NSMakePoint(pointOnScreen.origin.x + (NSWidth(view.frame) - NSWidth(targetFrame)) / 2, pointOnScreen.origin.y + (NSHeight(view.frame) - NSHeight(targetFrame)) / 2);
    
    return position;
}

@end
