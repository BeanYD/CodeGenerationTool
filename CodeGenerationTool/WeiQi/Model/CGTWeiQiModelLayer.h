//
//  CGTWeiQiModelLayer.h
//  CodeGenerationTool
//
//  Created by mac on 2021/9/26.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CGTChessmanBean;

@interface CGTWeiQiModelLayer : NSObject

#pragma mark - 初始化内容
// 围棋棋盘大小，最大19*19，lineNum <= 19;
@property (assign) int lineNum;

// 网格线条宽度
@property (assign) int lineWidth;

// 棋盘宽高，正方形
@property (assign) CGFloat boardWidth;

// 棋盘颜色
@property (strong) NSColor *boardColor;

// 网格颜色
@property (strong) NSColor *lineColor;

// 天元和星的颜色
@property (strong) NSColor *starColor;

// 行列提示文字颜色
@property (strong) NSColor *hVTextColor;

// 棋盘空白边缘宽度
@property (nonatomic, assign) int spaceWidth;

// 起始位置
@property (assign) NSPoint startPoint;

// 记录已下棋子位置
@property (strong) NSMutableDictionary *pressedDict;

// 记录下棋顺序
@property (strong) NSMutableArray *pressArray;

// 记录棋谱固定棋子
@property (strong) NSDictionary *basicDict;

@property (assign) BOOL isAuto;
@property (assign) BOOL isWhite;

#pragma mark - 记步数
@property (assign) int step;

- (NSArray *)chessmansInBoard;
- (NSRect)getChessmanRectWithPoint:(NSPoint)point;

- (NSRect)getChessViewRectWithChessmanLocation:(NSPoint)location;

// 获取棋子的位置信息{i , j}
- (NSPoint)getChessmanLocationWithPoint:(NSPoint)point;
- (NSPoint)getPointWithChessmanLocation:(NSPoint)location;

// 坐标系原点位置不同的转化
- (NSPoint)getOrignLTPointFromOrignLBPoint:(NSPoint)lBPoint;
- (NSPoint)getOrignLBPointFromOrignLTPoint:(NSPoint)lTPoint;

- (BOOL)enablePressWithChessman:(CGTChessmanBean *)chessman;

// 是否有气
- (NSMutableArray *)areaDifferentColorBreacheWithChessman:(CGTChessmanBean *)chessman;
- (NSMutableArray *)sameColorBreatheWithChessman:(CGTChessmanBean *)chessman;

// 获取天元和星的位置
+ (NSArray *)getStarsFrom19x19;

+ (NSString *)getEnglishCharacterIn19WithNum:(int)i;

+ (NSString *)getChineseCharacterIn19WithNum:(int)i;





@end

NS_ASSUME_NONNULL_END
