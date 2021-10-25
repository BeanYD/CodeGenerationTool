//
//  GoRule.h
//  CodeGenerationTool
//
//  Created by mac on 2021/10/15.
//  Copyright © 2021 dingbinbin. All rights reserved.
//
#define MAX_STONENUM (19*19)

// 棋子颜色
typedef enum tag_stoneColor {
    GEEY = -1, // 棋盘外
    EMPTY,
    BLACK,
    WHITE
} STONECOLOR;

// 棋子坐标
typedef struct stonePoint {
    int x;
    int y;
} STONEPOINT;

// 棋子信息
typedef struct stoneInfo {
    STONECOLOR color;
    STONEPOINT location;
} STONEINFO;

/**
 * 与所下棋子同色棋子气的判断
 * params:
 * stone 当前所下子信息
 * currentStones    当前棋盘上的所有棋子
 *
 * return:
 * 如果有气，返回空数组
 * 如果无气，返回需要提取的棋子坐标
 */
extern STONEPOINT *sameColorBreatheForStone(STONEINFO stone, STONEINFO *currentStones);

/**
 *
 * 与所下棋子异色棋子气的判断
 * params:
 * stone 当前所下子信息
 * currentStones    当前棋盘上的所有棋子
 *
 * return:
 * 如果有气，返回空数组
 * 如果无气，返回需要提取的棋子坐标
 */
extern STONEPOINT *diffColorBreatheForStone(STONEINFO stone, STONEINFO *currentStones);

