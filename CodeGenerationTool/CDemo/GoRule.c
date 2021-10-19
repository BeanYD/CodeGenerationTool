//
//  GoRule.m
//  CodeGenerationTool
//
//  Created by mac on 2021/10/15.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#include <string.h>
#include <stdbool.h>
#include "GoRule.h"

extern bool p_sameColorBreathe(STONEINFO stone, STONEPOINT *coverSet, STONEINFO *currentStones) {
    
    STONEPOINT point = stone.location;
    if (point.x > 1) {
        STONEPOINT left = {point.x - 1, point.y};
        int i = 0;
        bool exit = false;
        while (currentStones[i].location.x != 0) {
            STONEINFO currentStone = currentStones[i];
            if (currentStone.location.x == left.x && currentStone.location.y == left.y) {
                
                // 已经有棋子存在
                exit = true;
                
                if (currentStone.color == stone.color) {
                    int j = 0;
                    bool exitSet = false;
                    while (coverSet[j].x != 0) {
                        STONEPOINT position = coverSet[j];
                        if (position.x == left.x && position.y == left.y) {
                            // 已被保存在已遍历的列表中
                            exitSet = true;
                        }
                        j++;
                    }
                    if (!exitSet) {
                        if (j < MAX_STONENUM) {
                            coverSet[j] = left;
                            if (p_sameColorBreathe(currentStone, coverSet, currentStones)) {
                                return true;
                            }
                        }
                    }
                }
                break;
            }
            i++;
        }
        
        if (!exit) {
            // 不存在直接返回有气
            return true;
        }
    }
    
    if (point.x < 19) {
        STONEPOINT right = {point.x + 1, point.y};
        int i = 0;
        bool exit = false;
        while (currentStones[i].location.x != 0) {
            STONEINFO currentStone = currentStones[i];
            if (currentStone.location.x == right.x && currentStone.location.y == right.y) {
                
                exit = true;
                if (currentStone.color == stone.color) {
                    int j = 0;
                    bool exitSet = false;
                    while (coverSet[j].x != 0) {
                        STONEPOINT position = coverSet[j];
                        if (position.x == right.x && position.y == right.y) {
                            exitSet = true;
                        }
                        j++;
                    }
                    if (!exitSet) {
                        if (j < MAX_STONENUM) {
                            coverSet[j] = right;
                            if (p_sameColorBreathe(currentStone, coverSet, currentStones)) {
                                return true;
                            }
                        }
                    }
                }
                break;
            }
            i++;
        }
        
        if (!exit) {
            // 不存在直接返回有气
            return true;
        }
    }
    
    if (point.y > 1) {
        STONEPOINT top = {point.x, point.y - 1};
        int i = 0;
        bool exit = false;
        while (currentStones[i].location.x != 0) {
            STONEINFO currentStone = currentStones[i];
            if (currentStone.location.x == top.x && currentStone.location.y == top.y) {
                
                exit = true;
                if (currentStone.color == stone.color) {
                    int j = 0;
                    bool exitSet = false;
                    while (coverSet[j].x != 0) {
                        STONEPOINT position = coverSet[j];
                        if (position.x == top.x && position.y == top.y) {
                            exitSet = true;
                        }
                        j++;
                    }
                    if (!exitSet) {
                        if (j < MAX_STONENUM) {
                            coverSet[j] = top;
                            if (p_sameColorBreathe(currentStone, coverSet, currentStones)) {
                                return true;
                            }
                        }
                    }
                }
                break;
            }
            i++;
        }
        
        if (!exit) {
            // 不存在直接返回有气
            return true;
        }
    }
    
    if (point.y < 19) {
        STONEPOINT bottom = {point.x, point.y + 1};
        int i = 0;
        bool exit = false;
        while (currentStones[i].location.x != 0) {
            STONEINFO currentStone = currentStones[i];
            if (currentStone.location.x == bottom.x && currentStone.location.y == bottom.y) {
                
                exit = true;
                if (currentStone.color == stone.color) {
                    int j = 0;
                    bool exitSet = false;
                    while (coverSet[j].x != 0) {
                        STONEPOINT position = coverSet[j];
                        if (position.x == bottom.x && position.y == bottom.y) {
                            exitSet = true;
                        }
                        j++;
                    }
                    if (!exitSet) {
                        if (j < MAX_STONENUM) {
                            coverSet[j] = bottom;
                            if (p_sameColorBreathe(currentStone, coverSet, currentStones)) {
                                return true;
                            }
                        }
                    }
                }
                break;
            }
            i++;
        }
        
        if (!exit) {
            // 不存在直接返回有气
            return true;
        }
    }
    
    return false;
}

extern STONEPOINT *p_sameColorBreatheForStone(STONEINFO stone, STONEINFO *currentStones) {
    STONEPOINT point = stone.location;
    
    static STONEPOINT coverSet[MAX_STONENUM] = {{0, 0}};
    coverSet[0] = point;
    
    bool res = p_sameColorBreathe(stone, coverSet, currentStones);
    
    if (res) {
        memset(coverSet, 0, MAX_STONENUM);
    }
    
    return coverSet;
}

extern STONEPOINT *sameColorBreatheForStone(STONEINFO stone, STONEINFO *currentStones) {
    // 将棋子信息加入到currentStones
    int i = 0;
    while (currentStones[i].location.x != 0) {
        i++;
    }
    currentStones[i] = stone;
    
    return p_sameColorBreatheForStone(stone, currentStones);
}

extern STONEPOINT *diffColorBreatheForStone(STONEINFO stone, STONEINFO *currentStones) {
    
    STONEPOINT point = stone.location;
    
    // 将棋子信息加入到currentStones，再添加规则判断
    int i = 0;
    while (currentStones[i].location.x != 0) {
        i++;
    }
    currentStones[i] = stone;
    
    static STONEPOINT allCovers[MAX_STONENUM] = {{0, 0}};
    int iCoverNum = 0;
    
    if (point.y - 1 > 0) {
        int i = 0;
        while (currentStones[i].location.x != 0) {
            STONEINFO currentStone = currentStones[i];
            if (currentStone.location.x == point.x && currentStone.location.y == point.y - 1 && currentStone.color != stone.color) {
                STONEPOINT *coverSet = p_sameColorBreatheForStone(currentStone, currentStones);
                
                int j = 0;
                while (coverSet[j].x != 0) {
                    allCovers[iCoverNum + j].x = coverSet[j].x;
                    allCovers[iCoverNum + j].y = coverSet[j].y;
                    j++;
                }
                
                iCoverNum += j;
                
                break;
            }
            i++;
        }
    }
    
    if (point.y + 1 < 19) {
        int i = 0;
        while (currentStones[i].location.x != 0) {
            STONEINFO currentStone = currentStones[i];
            if (currentStone.location.x == point.x && currentStone.location.y == point.y + 1 && currentStone.color != stone.color) {
                STONEPOINT *coverSet = p_sameColorBreatheForStone(currentStone, currentStones);
                
                int j = 0;
                while (coverSet[j].x != 0) {
                    allCovers[iCoverNum + j].x = coverSet[j].x;
                    allCovers[iCoverNum + j].y = coverSet[j].y;
                    j++;
                }
                
                iCoverNum += j;
                
                break;
            }
            i++;
        }
    }
    
    if (point.x - 1 > 1) {
        int i = 0;
        while (currentStones[i].location.x != 0) {
            STONEINFO currentStone = currentStones[i];
            if (currentStone.location.x == point.x - 1 && currentStone.location.y == point.y && currentStone.color != stone.color) {
                STONEPOINT *coverSet = p_sameColorBreatheForStone(currentStone, currentStones);
                
                int j = 0;
                while (coverSet[j].x != 0) {
                    allCovers[iCoverNum + j].x = coverSet[j].x;
                    allCovers[iCoverNum + j].y = coverSet[j].y;
                    j++;
                }
                
                iCoverNum += j;
                
                break;
            }
            i++;
        }
    }
        
    if (point.x + 1 < 19) {
        int i = 0;
        while (currentStones[i].location.x != 0) {
            STONEINFO currentStone = currentStones[i];
            if (currentStone.location.x == point.x + 1 && currentStone.location.y == point.y && currentStone.color != stone.color) {
                STONEPOINT *coverSet = p_sameColorBreatheForStone(currentStone, currentStones);
                
                int j = 0;
                while (coverSet[j].x != 0) {
                    allCovers[iCoverNum + j].x = coverSet[j].x;
                    allCovers[iCoverNum + j].y = coverSet[j].y;
                    j++;
                }
                
                iCoverNum += j;
                
                break;
            }
            i++;
        }
    }
    
    
    return allCovers;
}
