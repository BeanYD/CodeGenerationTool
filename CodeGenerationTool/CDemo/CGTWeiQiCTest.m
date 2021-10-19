//
//  CGTWeiQiCTest.m
//  CodeGenerationTool
//
//  Created by mac on 2021/10/18.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTWeiQiCTest.h"
#import "GoRule.h"

@implementation CGTWeiQiCTest


- (void)testDemo {
    
    
    STONEINFO info1 = {BLACK, {6, 3}};
    STONEINFO info2 = {BLACK, {7, 3}};
    STONEINFO info3 = {BLACK, {5, 4}};
    STONEINFO info4 = {BLACK, {8, 4}};
    STONEINFO info5 = {BLACK, {5, 5}};
    STONEINFO info6 = {BLACK, {7, 5}};
    STONEINFO info7 = {BLACK, {6, 6}};
    STONEINFO info8 = {WHITE, {6, 4}};
    STONEINFO info9 = {WHITE, {7, 4}};



    STONEINFO currentStones[MAX_STONENUM] = {{EMPTY, {0, 0}}};
    currentStones[0] = info1;
    currentStones[1] = info2;
    currentStones[2] = info3;
    currentStones[3] = info4;
    currentStones[4] = info5;
    currentStones[5] = info6;
    currentStones[6] = info7;
    currentStones[7] = info8;
    currentStones[8] = info9;

    STONEINFO newStone = {WHITE, {6, 5}};
    STONEPOINT *coverSet = sameColorBreatheForStone(newStone, currentStones);

    int i = 0;
    while (coverSet[i].x != 0) {
        STONEPOINT point = coverSet[i];
        printf("%d, %d\n", point.x, point.y);

//        int j = 0;
//        while (currentStones[j].location.x != 0) {
//            STONEINFO stone = currentStones[j];
//
//        }

        i++;
    }
    
    
    STONEINFO info11 = {BLACK, {3, 1}};
    STONEINFO info12 = {BLACK, {2, 2}};
    STONEINFO info13 = {BLACK, {1, 3}};
    STONEINFO info14 = {BLACK, {2, 4}};
    STONEINFO info15 = {BLACK, {3, 5}};
    STONEINFO info16 = {BLACK, {4, 4}};
    STONEINFO info17 = {BLACK, {5, 3}};
    STONEINFO info18 = {BLACK, {4, 2}};
    STONEINFO info19 = {WHITE, {3, 2}};
    STONEINFO info20 = {WHITE, {2, 3}};
    STONEINFO info21 = {WHITE, {3, 4}};
    STONEINFO info22 = {WHITE, {4, 3}};

    STONEINFO currentStones1[MAX_STONENUM] = {{EMPTY, {0, 0}}};
    currentStones1[0] = info11;
    currentStones1[1] = info12;
    currentStones1[2] = info13;
    currentStones1[3] = info14;
    currentStones1[4] = info15;
    currentStones1[5] = info16;
    currentStones1[6] = info17;
    currentStones1[7] = info18;
    currentStones1[8] = info19;
    currentStones1[9] = info20;
    currentStones1[10] = info21;
    currentStones1[11] = info22;
    
    
    STONEINFO newStone1 = {BLACK, {3, 3}};
    STONEPOINT *coverSet1 = diffColorBreatheForStone(newStone1, currentStones1);
    
    int i1 = 0;
    while (coverSet1[i1].x != 0) {
        STONEPOINT point1 = coverSet1[i1];
        printf("%d, %d\n", point1.x, point1.y);

//        int j = 0;
//        while (currentStones[j].location.x != 0) {
//            STONEINFO stone = currentStones[j];
//
//        }
        
        i1++;
    }
}

@end
