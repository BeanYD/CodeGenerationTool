//
//  CGTSGFNode.m
//  CodeGenerationTool
//
//  Created by mac on 2021/10/11.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTSGFNode.h"

@implementation CGTSGFNode

- (instancetype)init {
    if (self = [super init]) {
        self.subNodes = [NSMutableArray array];
        self.nodeStr = @"";
    }
    
    return self;
}

@end
