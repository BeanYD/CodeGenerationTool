//
//  CGTMainModelLayer.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/6.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTMainModelLayer.h"
#import "CGTFilePathPlistMgr.h"

@interface CGTMainModelLayer ()

@property (nonatomic, strong) CGTFilePathPlistMgr *mgr;

@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation CGTMainModelLayer

- (instancetype)init {
	if (self = [super init]) {
		
	}
	
	return self;
}

- (NSString *)readFirstFilePath {
	NSMutableArray *array = [self readAllFilePaths];
	if (array.count > 0) {
		return [array firstObject];
	}
	
	return @"";
}

- (NSMutableArray *)readAllFilePaths {
	__block NSMutableArray *array;
	dispatch_sync(self.concurrentQueue, ^{
		array = [self.mgr filePaths];
	});
	
	return array;
}

- (void)saveNewFilePath:(NSString *)filePath {
	dispatch_barrier_sync(self.concurrentQueue, ^{
		[self.mgr insertFilePath:filePath];
	});
}

#pragma mark - setter && getter
- (CGTFilePathPlistMgr *)mgr {
	if (!_mgr) {
		_mgr = [[CGTFilePathPlistMgr alloc] init];
	}
	
	return _mgr;
}

- (dispatch_queue_t)concurrentQueue {
	if (!_concurrentQueue) {
		_concurrentQueue = dispatch_queue_create("com.file-path-plist-concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
	}
	
	return _concurrentQueue;
}

@end
