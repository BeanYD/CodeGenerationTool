//
//  CGTDrawHeader.h
//  CodeGenerationTool
//
//  Created by mac on 2021/2/1.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#ifndef CGTDrawHeader_h
#define CGTDrawHeader_h

// draw类型枚举
typedef NS_ENUM(NSUInteger, CGTDrawType) {
    CGTDrawTypeNormal,
    CGTDrawTypeCurveLine,
    CGTDrawTypeDirectLine,
    CGTDrawTypeDirectDash,
    CGTDrawTypeArrowDirectLine,
    CGTDrawTypeRect,
    CGTDrawTypeEllipse,
    CGTDrawTypeText,
    CGTDrawTypeEraser,
    CGTDrawTypeImage,
};

#endif /* CGTDrawHeader_h */
