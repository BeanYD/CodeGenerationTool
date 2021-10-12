//
//  CGTSGFFileReader.h
//  CodeGenerationTool
//
//  Created by mac on 2021/10/11.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CGTSGFNode;

@interface CGTSGFFileReader : NSObject



+ (CGTSGFNode *)readGameTree:(NSString *)string;
+ (NSDictionary *)readBasicChessmanContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
