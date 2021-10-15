//
//  GoRule.m
//  CodeGenerationTool
//
//  Created by mac on 2021/10/15.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#include <string.h>
#include "GoRule.h"

extern int sameColorBreathe(STONEINFO stone, STONEPOINT *coverSet, STONEINFO *currentStones) {
    
    STONEPOINT point = stone.location;
    if (point.x > 1) {
        STONEPOINT left = {point.x - 1, point.y};
        int i = 0;
        for (; i < sizeof(currentStones); i++) {
            STONEINFO info = currentStones[i];
            if (info.location.x == stone.location.x && info.location.y == stone.location.y) {
                if (info.color == stone.color) {
                    
                }
            }
        }
        
        if (i == sizeof(currentStones)) {
            // 有气
            return 1;
        }
    }
    
    
    
    return 1;
}

extern STONEPOINT *sameColorBreatheForStone(STONEINFO stone, STONEINFO *currentStones) {
    STONEPOINT point = stone.location;
    
    static STONEPOINT coverSet[MAX_STONENUM];
    
    coverSet[0] = point;
    
    int res = sameColorBreathe(stone, coverSet, currentStones);
    
    if (res) {
        memset(coverSet, 0, sizeof(coverSet));
    }
    
    return coverSet;
}


extern STONEPOINT *diffColorBreatheForStone(STONEINFO stone, STONEINFO *currentStones) {
    
    return NULL;
}
