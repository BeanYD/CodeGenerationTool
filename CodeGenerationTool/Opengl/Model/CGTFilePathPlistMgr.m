//
//  CGTFilePathData.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/6.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTFilePathPlistMgr.h"

@implementation CGTFilePathPlistMgr {
	NSString *_plistPath;
	NSMutableArray *_dataArray;
}

- (instancetype)init {
	if (self = [super init]) {
		[self plistData];
	}
	
	return self;
}

- (void)plistData {
	NSString *plistPath = [self getPlistPath];
	_plistPath = plistPath;
	NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
	_dataArray = [NSMutableArray arrayWithArray:dataArray];
}


- (NSMutableArray *)filePaths {
	return [_dataArray mutableCopy];
}

- (void)insertFilePath:(NSString *)filePath {
	if (filePath.length == 0) {
		return;
	}
	if ([_dataArray containsObject:filePath]) {
		return;
	}
	[_dataArray insertObject:filePath atIndex:0];
	
	if (_dataArray.count > 20) {
		[_dataArray removeObjectsInRange:NSMakeRange(20, _dataArray.count - 20)];
	}
	
	[_dataArray writeToFile:_plistPath atomically:YES];
}

#pragma mark - setter && getter
- (NSString *)getPlistPath {
	NSString *finderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSString *filePath = [NSString stringWithFormat:@"%@/CGTCachePath.plist", finderPath];
	
	NSLog(@"%@", filePath);
	return filePath;
}

@end
