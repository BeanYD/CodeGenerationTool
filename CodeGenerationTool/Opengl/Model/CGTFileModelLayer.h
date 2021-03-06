//
//  CGTFileModelLayer.h
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/12/5.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGTFileModelLayer : NSObject

- (NSMutableArray *)readAllFilePaths;

- (void)saveNewFilePath:(NSString *)filePath;

- (NSString *)readFirstFilePath;

@end

NS_ASSUME_NONNULL_END
