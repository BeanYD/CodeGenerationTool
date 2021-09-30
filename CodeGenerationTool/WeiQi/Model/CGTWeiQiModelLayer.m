//
//  CGTWeiQiModelLayer.m
//  CodeGenerationTool
//
//  Created by mac on 2021/9/26.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTWeiQiModelLayer.h"
#import "CGTChessmanBean.h"

@implementation CGTWeiQiModelLayer

- (instancetype)init {
    if (self = [super init]) {
        [self defaultSettings];
    }
    
    return self;
}

- (void)defaultSettings {
    self.lineNum = 19;
    self.lineWidth = 2.f;
    self.boardWidth = 800;
    self.boardColor = [NSColor orangeColor];
    self.lineColor = [NSColor blackColor];
    self.starColor = [NSColor blackColor];
    self.hVTextColor = [NSColor blackColor];
    self.spaceWidth = self.boardWidth / (self.lineNum + 1);
    self.startPoint = NSMakePoint(self.spaceWidth, self.spaceWidth);
    self.step = 0;
    self.isAuto = YES;
    self.isWhite = NO;
    
    self.pressedArray = [NSMutableArray array];
}

- (void)setSpaceWidth:(int)spaceWidth {
    if (spaceWidth < self.boardWidth / (self.lineNum + 1)) {
        spaceWidth = self.boardWidth / (self.lineNum + 1);
    }
    
    _spaceWidth = spaceWidth;
}

- (NSArray *)chessmansInBoard {
    // 19条线，18格
    CGFloat cellWidth = (self.boardWidth - self.spaceWidth * 2) / (self.lineNum - 1);
    
    NSMutableArray *chessmans = [NSMutableArray array];
    
    for (int i = 0; i < self.lineNum; i++) {
        for (int j = 0; j < self.lineNum; j++) {
//            NSMutableDictionary *chessmanDic = [NSMutableDictionary dictionary];
//            NSPoint point = NSMakePoint(i + 1, j + 1);
//            NSString *pointStr = NSStringFromPoint(point);
//            [chessmanDic setValue:pointStr forKey:@"point"];
            NSRect chessRect = NSMakeRect(self.startPoint.x + self.spaceWidth - cellWidth / 2 + cellWidth * i, self.startPoint.y + self.spaceWidth - cellWidth / 2 + cellWidth * j, cellWidth, cellWidth);
            [chessmans addObject:NSStringFromRect(chessRect)];
        }
    }
    
    return chessmans;
}

- (NSRect)getChessmanRectWithPoint:(NSPoint)point {
    CGFloat cellWidth = (self.boardWidth - self.spaceWidth * 2) / (self.lineNum - 1);
    CGFloat startX = self.startPoint.x;
    CGFloat startY = self.startPoint.y;
    
    CGFloat x = ((int)(point.x - startX + cellWidth / 2) / (int)cellWidth) * cellWidth;
    CGFloat y = ((int)(point.y - startY + cellWidth / 2) / (int)cellWidth) * cellWidth;
    NSRect chessRect = NSMakeRect(x - cellWidth / 2 + startX, y - cellWidth / 2 + startY, cellWidth, cellWidth);
    
    return chessRect;
}

- (NSPoint)getChessmanLocationWithPoint:(NSPoint)point {
    CGFloat cellWidth = (self.boardWidth - self.spaceWidth * 2) / (self.lineNum - 1);
    CGFloat startX = self.startPoint.x;
    CGFloat startY = self.startPoint.y;

    int i = ((int)(point.x - startX + cellWidth / 2) / (int)cellWidth) + 1;
    int j = 18 - ((int)(point.y - startY + cellWidth / 2) / (int)cellWidth) + 1;
    
    return NSMakePoint(i, j);
}

// 判断单个棋子没有气，无法落子。
// TODO: 添加劫的判断
- (BOOL)enablePressWithChessman:(CGTChessmanBean *)chessman {
    if (self.pressedArray.count == 0) {
        return YES;
    }
    
    CGPoint topPoint = NSMakePoint(chessman.position.x, chessman.position.y - 1);
    CGPoint bottomPoint = NSMakePoint(chessman.position.x, chessman.position.y + 1);
    CGPoint leftPoint = NSMakePoint(chessman.position.x - 1, chessman.position.y);
    CGPoint rightPoint = NSMakePoint(chessman.position.x + 1, chessman.position.y);
    
    int containCount = 0;
    int maxCount = 4;
    
    if (topPoint.y <= 0) {
        maxCount--;
    }
    
    if (bottomPoint.y > 19) {
        maxCount--;
    }
    
    if (leftPoint.x <= 0) {
        maxCount--;
    }
    
    if (rightPoint.x > 19) {
        maxCount--;
    }
    
    for (int i = 0; i < self.pressedArray.count; i++) {
        CGTChessmanBean *bean = self.pressedArray[i];
        if (CGPointEqualToPoint(bean.position, topPoint) ||
            CGPointEqualToPoint(bean.position, bottomPoint) ||
            CGPointEqualToPoint(bean.position, leftPoint) ||
            CGPointEqualToPoint(bean.position, rightPoint)) {
            containCount++;
        }
    }

    if (containCount == maxCount) {
        return NO;
    }
    
    return YES;
}

// 是否有气
- (BOOL)hasBreatheWithChessman:(CGTChessmanBean *)chessman {
    
    
    return YES;
}

#pragma mark - Class Method
+ (NSArray *)getStarsFrom19x19 {
    return @[NSStringFromPoint(NSMakePoint(4, 4)),
             NSStringFromPoint(NSMakePoint(10, 4)),
             NSStringFromPoint(NSMakePoint(16, 4)),
             NSStringFromPoint(NSMakePoint(4, 10)),
             NSStringFromPoint(NSMakePoint(10, 10)),
             NSStringFromPoint(NSMakePoint(16, 10)),
             NSStringFromPoint(NSMakePoint(4, 16)),
             NSStringFromPoint(NSMakePoint(10, 16)),
             NSStringFromPoint(NSMakePoint(16, 16))];
}

+ (NSString *)getEnglishCharacterIn19WithNum:(int)i {
    switch (i) {
        case 1:
            return @"A";
        case 2:
            return @"B";
        case 3:
            return @"C";
        case 4:
            return @"D";
        case 5:
            return @"E";
        case 6:
            return @"F";
        case 7:
            return @"G";
        case 8:
            return @"H";
        case 9:
            return @"I";
        case 10:
            return @"J";
        case 11:
            return @"K";
        case 12:
            return @"L";
        case 13:
            return @"M";
        case 14:
            return @"N";
        case 15:
            return @"O";
        case 16:
            return @"P";
        case 17:
            return @"Q";
        case 18:
            return @"R";
        case 19:
            return @"S";
        default:
            NSLog(@"超出最大棋盘数");
            return @"";
    }
}

+ (NSString *)getChineseCharacterIn19WithNum:(int)i {
    switch (i) {
        case 1:
            return @"一";
        case 2:
            return @"二";
        case 3:
            return @"三";
        case 4:
            return @"四";
        case 5:
            return @"五";
        case 6:
            return @"六";
        case 7:
            return @"七";
        case 8:
            return @"八";
        case 9:
            return @"九";
        case 10:
            return @"十";
        case 11:
            return @"十一";
        case 12:
            return @"十二";
        case 13:
            return @"十三";
        case 14:
            return @"十四";
        case 15:
            return @"十五";
        case 16:
            return @"十六";
        case 17:
            return @"十七";
        case 18:
            return @"十八";
        case 19:
            return @"十九";
        default:
            NSLog(@"超出最大棋盘数");
            return @"";
    }
}

@end
