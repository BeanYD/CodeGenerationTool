//
//  CGTCmdTool.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/21.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTCmdTool.h"

@implementation CGTCmdTool


+ (NSString *)cmd:(NSString *)cmd {
	// 初始化并设置shell路径

	NSTask *task = [[NSTask alloc] init];
	// -c用来执行string-commands（命令字符串），也就说不管后面的字符串里是什么都会被当做shellcode来执行
	[task setLaunchPath: @"/bin/bash"];

	NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
	// 新建输出管道作为Task的输出
	[task setArguments: arguments];

	NSPipe *pipe = [NSPipe pipe];
	
	// 开始task
	[task setStandardOutput: pipe];
	NSFileHandle *file = [pipe fileHandleForReading];
	// 获取运行结果
	[task launch];
	
	NSData *data = [file readDataToEndOfFile];
	return [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];

}


@end
