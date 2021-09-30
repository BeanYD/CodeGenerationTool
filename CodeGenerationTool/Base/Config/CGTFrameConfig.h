//
//  CGTFrameConfig.h
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGTFrameConfig : NSObject

+ (CGRect)getDefaultWindowFrame;

+ (CGRect)getHalfWidthDefaultWindowFrame;

+ (CGRect)getWeiQiBoardWindowFrame;

@end

NS_ASSUME_NONNULL_END
