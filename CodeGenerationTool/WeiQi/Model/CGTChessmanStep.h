//
//  CGTChessmanPath.h
//  CodeGenerationTool
//
//  Created by mac on 2021/10/14.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 用类似树的数据结构记录下棋路径

@interface CGTChessmanStep : NSObject

@property (assign) BOOL isWhite;
@property (assign) NSPoint location;

// 上一步棋
@property (strong, nullable) CGTChessmanStep *preStep;

// 棋谱固定子
@property (strong) NSMutableArray *standardArray;

@property (strong) NSMutableArray<CGTChessmanStep *> *nextSteps;


@end

NS_ASSUME_NONNULL_END
