//
//  CGTMainModelLayer.h
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/6.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGTMainModelLayer : NSObject


- (NSMutableArray *)readAllFilePaths;

- (void)saveNewFilePath:(NSString *)filePath;

- (NSString *)readFirstFilePath;

@end

NS_ASSUME_NONNULL_END
