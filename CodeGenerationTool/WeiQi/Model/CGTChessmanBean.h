//
//  CGTChessmanModel.h
//  CodeGenerationTool
//
//  Created by mac on 2021/9/29.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGTChessmanBean : NSObject

@property (assign) BOOL isWhite;
@property (assign) NSPoint position;
@property (strong) NSView *chessmanView;

+ (CGTChessmanBean *)chessmanBeanWithPosition:(NSPoint)position isWhite:(BOOL)isWhite;

@end

NS_ASSUME_NONNULL_END
