//
//  CGTInvokeConfig.h
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGTInvokeConfig : NSObject

+ (id)className:(NSString *)className invokeMethodName:(NSString *)methodName;

@end

NS_ASSUME_NONNULL_END
