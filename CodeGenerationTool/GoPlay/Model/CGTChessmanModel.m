//
//  CGTChessmanModel.m
//  CodeGenerationTool
//
//  Created by mac on 2021/9/29.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTChessmanBean.h"

@implementation CGTChessmanBean

+ (CGTChessmanBean *)chessmanModelWithPosition:(NSPoint)position isWhite:(BOOL)isWhite {
    CGTChessmanBean *model = [[CGTChessmanBean alloc] init];
    model.position = position;
    model.isWhite = isWhite;
    
    return model;
}

@end
