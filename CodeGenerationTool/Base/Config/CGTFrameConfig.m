//
//  CGTFrameConfig.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTFrameConfig.h"

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



@end
