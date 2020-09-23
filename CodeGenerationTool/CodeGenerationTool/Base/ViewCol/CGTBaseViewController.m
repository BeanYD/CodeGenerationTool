//
//  CGTBaseViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/4.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTBaseViewController.h"

@interface CGTBaseViewController () {
	CGRect _frame;
}


@end

@implementation CGTBaseViewController

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super init]) {
		_frame = frame;
	}
	
	return self;
}

// 不使用nib加载NSViewController时，需要在loadView中创建view，进而调用viewDidLoad
- (void)loadView {
	NSView *view = [[NSView alloc] initWithFrame:_frame];
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
