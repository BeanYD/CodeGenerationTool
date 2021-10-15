//
//  GoRule.h
//  CodeGenerationTool
//
//  Created by mac on 2021/10/15.
//  Copyright © 2021 dingbinbin. All rights reserved.
//
#define MAX_STONENUM (19*19)



typedef enum tag_stoneColor {
    GEEY = -1, // 棋盘外
    EMPTY,
    BLACK,
    WHITE
} STONECOLOR;

typedef struct stonePoint {
    int x;
    int y;
} STONEPOINT;

typedef struct stoneInfo {
    STONECOLOR color;
    STONEPOINT location;
} STONEINFO;

extern STONEPOINT *sameColorBreatheForStone(STONEINFO stone, STONEINFO *currentStones);
extern STONEPOINT *diffColorBreatheForStone(STONEINFO stone, STONEINFO *currentStones);

