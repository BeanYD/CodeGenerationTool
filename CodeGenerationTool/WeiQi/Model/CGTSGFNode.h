//
//  CGTSGFNode.h
//  CodeGenerationTool
//
//  Created by mac on 2021/10/11.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGTSGFNode : NSObject

@property (strong) NSMutableArray<CGTSGFNode *> *subNodes;
@property (copy) NSString *nodeStr;

@end

NS_ASSUME_NONNULL_END
