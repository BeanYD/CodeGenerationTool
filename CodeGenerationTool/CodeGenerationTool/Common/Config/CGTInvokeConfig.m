//
//  CGTInvokeConfig.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTInvokeConfig.h"

@implementation CGTInvokeConfig

+ (id)className:(NSString *)className invokeMethodName:(NSString *)methodName {
	Class class = NSClassFromString(className);
	SEL sel = NSSelectorFromString(methodName);
	id res = nil;
	if ([class respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		res = [class performSelector:sel];
#pragma clang diagnostic pop
	}
	return res;
}

@end
