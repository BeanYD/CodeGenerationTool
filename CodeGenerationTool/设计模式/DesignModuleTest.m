//
//  DesignModuleTest.m
//  CodeGenerationTool
//
//  Created by mac on 2021/11/19.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "DesignModuleTest.h"
#import "ImageProcessJob.h"

@implementation DesignModuleTest

- (instancetype)init {
    if (self = [super init]) {
        
        [self uploadImage];
    }
    
    return self;
}

- (void)uploadImage {
    ImageProcessJob *processJob = [ImageProcessJob new];
    [processJob process];
}

@end
