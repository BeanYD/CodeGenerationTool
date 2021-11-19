//
//  ImageStore.h
//  CodeGenerationTool
//
//  Created by mac on 2021/11/19.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImageStore <NSObject>

@optional
- (void)rename;

@required
- (void)upload;

@end

NS_ASSUME_NONNULL_END
