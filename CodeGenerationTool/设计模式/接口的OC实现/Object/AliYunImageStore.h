//
//  AliYunImageStore.h
//  CodeGenerationTool
//
//  Created by mac on 2021/11/19.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface AliYunImageStore : NSObject <ImageStore>

- (void)generateAccessToken;
@end

NS_ASSUME_NONNULL_END
