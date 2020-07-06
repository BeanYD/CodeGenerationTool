//
//  CGTBaseViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/4.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTBaseViewController.h"

@interface CGTBaseViewController ()



@end

@implementation CGTBaseViewController

// 不使用nib加载NSViewController时，需要在loadView中创建view，进而调用viewDidLoad
- (void)loadView {
	[NSScreen mainScreen];
	NSView *view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 800, 600)];
	self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
	
	// 用于修改NSViewcontroller.view的layer的背景色
	self.view.wantsLayer = YES;
}


- (void)dealloc {
	NSLog(@"%@ dealloc", [self class]);
}

@end
