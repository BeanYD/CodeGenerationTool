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
        
    self.pressedDict = [NSMutableDictionary dictionary];
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

- (NSRect)getChessViewRectWithChessmanLocation:(NSPoint)location {
    CGFloat cellWidth = (self.boardWidth - self.spaceWidth * 2) / (self.lineNum - 1);
    NSPoint point = [self getPointWithChessmanLocation:location];
    
    return NSMakeRect(point.x, point.y, cellWidth, cellWidth);
}

- (NSPoint)getPointWithChessmanLocation:(NSPoint)location {
    CGFloat cellWidth = (self.boardWidth - self.spaceWidth * 2) / (self.lineNum - 1);
    CGFloat startX = self.startPoint.x;
    CGFloat startY = self.startPoint.y;
    
    CGFloat pointX = (location.x - 1) * cellWidth - cellWidth / 2 + startX;
    CGFloat pointY = (18 + 1 - location.y) * cellWidth - cellWidth / 2 + startY;
    
    return NSMakePoint(pointX, pointY);
}

// 左上角原点返回坐标
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
    if (self.pressedDict.count == 0) {
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
    
    CGTChessmanBean *topBean = [self.pressedDict valueForKey:NSStringFromPoint(topPoint)];
    CGTChessmanBean *bottomBean = [self.pressedDict valueForKey:NSStringFromPoint(bottomPoint)];
    CGTChessmanBean *leftBean = [self.pressedDict valueForKey:NSStringFromPoint(leftPoint)];
    CGTChessmanBean *rightBean = [self.pressedDict valueForKey:NSStringFromPoint(rightPoint)];
    if (topBean && topBean.isWhite != chessman.isWhite) {
        containCount++;
    }
    if (bottomBean && bottomBean.isWhite != chessman.isWhite) {
        containCount++;
    }
    if (leftBean && leftBean.isWhite != chessman.isWhite) {
        containCount++;
    }
    if (rightBean && rightBean.isWhite != chessman.isWhite) {
        containCount++;
    }

    if (containCount == maxCount) {
        return NO;
    }
    
    return YES;
}


// 落子异色子是否有气
- (NSMutableArray *)areaDifferentColorBreacheWithChessman:(CGTChessmanBean *)chessman {
    CGPoint point = chessman.position;
    
    NSMutableArray *removeArray = [NSMutableArray array];
    
    // 上下左右寻找异色
    if (point.y - 1 > 0) {
        CGTChessmanBean *topBean = [self.pressedDict valueForKey:NSStringFromPoint(NSMakePoint(point.x, point.y - 1))];
        if (topBean && topBean.isWhite != chessman.isWhite) {
            [removeArray addObjectsFromArray:[self sameColorBreatheWithChessman:topBean]];
        }
    }
    
    if (point.y + 1 <= 19) {
        CGTChessmanBean *bottomBean = [self.pressedDict valueForKey:NSStringFromPoint(NSMakePoint(point.x, point.y + 1))];
        if (bottomBean && bottomBean.isWhite != chessman.isWhite) {
            [removeArray addObjectsFromArray:[self sameColorBreatheWithChessman:bottomBean]];
        }
    }
    
    if (point.x - 1 > 0) {
        CGTChessmanBean *leftBean = [self.pressedDict valueForKey:NSStringFromPoint(NSMakePoint(point.x - 1, point.y))];
        if (leftBean && leftBean.isWhite != chessman.isWhite) {
            [removeArray addObjectsFromArray:[self sameColorBreatheWithChessman:leftBean]];
        }
    }
    
    if (point.x + 1 <= 19) {
        CGTChessmanBean *rightBean = [self.pressedDict valueForKey:NSStringFromPoint(NSMakePoint(point.x + 1, point.y))];
        if (rightBean && rightBean.isWhite != chessman.isWhite) {
            [removeArray addObjectsFromArray:[self sameColorBreatheWithChessman:rightBean]];
        }
    }
    
    return removeArray;
}

// 落子同色子是否有气
- (NSMutableArray *)sameColorBreatheWithChessman:(CGTChessmanBean *)chessman {
    
    CGPoint point = chessman.position;
    // 四个方向，直到遇到空子或者不同颜色的子
    
    // 记录x轴、y轴同色子
    NSMutableArray *visitedXs = [NSMutableArray array];
    NSMutableArray *visitedYs = [NSMutableArray array];
    [visitedXs addObject:@(point.x)];
    [visitedYs addObject:@(point.y)];
    
    // 左侧遍历，找边缘
    int leftX = point.x;
    while (leftX > 0) {
        int tmpX = leftX - 1;
        NSPoint newPoint = NSMakePoint(tmpX, point.y);
        CGTChessmanBean *leftBean = [self.pressedDict valueForKey:NSStringFromPoint(newPoint)];
        if (leftBean) {
            if (leftBean.isWhite == chessman.isWhite) {
                leftX = tmpX;
                [visitedXs addObject:@(tmpX)];
            } else {
                // 不同色，路堵死了！退出遍历
                break;
            }
        } else {
            // 存在气，直接返回YES
            return [@[] mutableCopy];
        }
    }
    // 右侧遍历，找边缘
    int rightX = point.x;
    while (rightX <= 19) {
        int tmpX = rightX + 1;
        NSPoint newPoint = NSMakePoint(tmpX, point.y);
        CGTChessmanBean *rightBean = [self.pressedDict valueForKey:NSStringFromPoint(newPoint)];
        if (rightBean) {
            if (rightBean.isWhite == chessman.isWhite) {
                rightX = tmpX;
                [visitedXs addObject:@(tmpX)];
            } else {
                // 不同色，路堵死了！退出遍历
                break;
            }
        } else {
            // 存在气，直接返回YES
            return [@[] mutableCopy];
        }
    }
    // 向上遍历，找边缘
    int topY = point.y;
    while (topY > 0) {
        int tmpY = topY - 1;
        NSPoint newPoint = NSMakePoint(point.x, tmpY);
        CGTChessmanBean *topBean = [self.pressedDict valueForKey:NSStringFromPoint(newPoint)];
        if (topBean) {
            if (topBean.isWhite == chessman.isWhite) {
                topY = tmpY;
                [visitedYs addObject:@(tmpY)];
            } else {
                break;
            }
        } else {
            // 存在气，直接返回YES
            return [@[] mutableCopy];
        }
    }
    // 向下遍历，找边缘
    int bottomY = point.y;
    while (topY <= 19) {
        int tmpY = bottomY + 1;
        NSPoint newPoint = NSMakePoint(point.x, tmpY);
        CGTChessmanBean *bottomBean = [self.pressedDict valueForKey:NSStringFromPoint(newPoint)];
        if (bottomBean) {
            if (bottomBean.isWhite == chessman.isWhite) {
                bottomY = tmpY;
                [visitedYs addObject:@(tmpY)];
            } else {
                break;
            }
        } else {
            // 存在气，直接返回YES
            return [@[] mutableCopy];
        }
    }
    
//    // y轴数据排序
//    [visitedYs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        int y1 = [obj1 intValue];
//        int y2 = [obj2 intValue];
//        if (y1 > y2) {
//            return NSOrderedDescending;
//        } else if (y1 < y2) {
//            return NSOrderedAscending;
//        } else {
//            return NSOrderedSame;
//        }
//    }];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    // visitedXs 内容:pointX, pointX--, pointX++;
    // visitedYs 内容:pointY, pointY--, pointY++;
    
    // 根据x,y方向的同色数据，遍历
    for (int i = 0; i < visitedXs.count; i++) {
        int x = [visitedXs[i] intValue];
        
        BOOL isTopBorder = NO;
        for (int j = 0; j < visitedYs.count; j++) {
            int y = [visitedYs[j] intValue];
            if (isTopBorder && y < [visitedYs[0] intValue]) {
                continue;
            }
            
            CGTChessmanBean *bean = [self.pressedDict valueForKey:NSStringFromPoint(NSMakePoint(x, y))];
            if (!bean) {
                return [@[] mutableCopy];
            } else {
                if (bean.isWhite != chessman.isWhite) {
                    // 遇到边缘的异色子
                    if (y < [visitedYs[0] intValue]) {
                        isTopBorder = YES;
                    } else {
                        break;
                    }
                } else {
                    [tmpArray addObject:bean];
                }
            }
        }
    }
    
    return tmpArray;
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
