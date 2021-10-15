//
//  CGTChessmanPath.m
//  CodeGenerationTool
//
//  Created by mac on 2021/10/14.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTChessmanStep.h"

@implementation CGTChessmanStep

+ (CGTChessmanStep *)chessmanStepWithLocation:(NSPoint)location isWhite:(BOOL)isWhite {
    CGTChessmanStep *step = [[CGTChessmanStep alloc] init];
    step.isWhite = isWhite;
    step.location = location;
    step.preStep = nil;
    step.standardArray = [NSMutableArray array];
    step.nextSteps = [NSMutableArray array];
    
    return step;
}


@end
