//
//  CGTChessmanPath.h
//  CodeGenerationTool
//
//  Created by mac on 2021/10/14.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGTChessmanStep : NSObject

@property (assign) BOOL isWhite;
@property (assign) NSPoint location;

@property (strong) NSMutableArray<CGTChessmanStep *> *nextSteps;


@end

NS_ASSUME_NONNULL_END
