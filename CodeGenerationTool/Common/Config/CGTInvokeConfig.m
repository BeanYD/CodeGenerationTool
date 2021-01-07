//
//  CGTInvokeConfig.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTInvokeConfig.h"
#import <objc/runtime.h>

@implementation CGTInvokeConfig

// 类方法的调用，返回一个对象
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

// 实例方法的调用
+ (void)className:(NSString *)className invokeInstanceMethodName:(NSString *)methodName {
    
    SEL sel = NSSelectorFromString(methodName);
    Method method = class_getInstanceMethod(NSClassFromString(className), sel);
    IMP imp = method_getImplementation(method);
    // 执行method
    
    NSObject *obj = [[NSClassFromString(className) alloc] init];
//    (void *)imp()
}

@end
