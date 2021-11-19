//
//  ImageProcessJob.m
//  CodeGenerationTool
//
//  Created by mac on 2021/11/19.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "ImageProcessJob.h"
#import "PrivateImageStore.h"
#import "AliYunImageStore.h"

@implementation ImageProcessJob

- (void)process {
    id<ImageStore> imageStore = [AliYunImageStore new];
    [imageStore upload];
    
    [(AliYunImageStore *)imageStore generateAccessToken];
}

@end
