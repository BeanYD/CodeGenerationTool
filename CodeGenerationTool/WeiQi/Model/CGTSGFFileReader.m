//
//  CGTSGFFileReader.m
//  CodeGenerationTool
//
//  Created by mac on 2021/10/11.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTSGFFileReader.h"
#import "CGTSGFNode.h"

@implementation CGTSGFFileReader

+ (CGTSGFNode *)readGameTree:(NSString *)string {
    // 传入空头对象
    CGTSGFNode *rootNode = [[CGTSGFNode alloc] init];
    int i = [self readSubGameTree:string node:rootNode index:0];
    if (i == string.length - 1) {
        NSLog(@"解析完全");
    } else {
        NSLog(@"未解析完全");
    }
    if (rootNode.subNodes.count > 0) {
        return [rootNode.subNodes firstObject];
    }
    
    return nil;
}

+ (int)readSubGameTree:(NSString *)subStr node:(CGTSGFNode *)node index:(int)index {
    NSString *firstCh = [subStr substringWithRange:NSMakeRange(index, 1)];
    if (![firstCh isEqualToString:@"("]) {
        return index;
    }

    CGTSGFNode *subNode = [[CGTSGFNode alloc] init];
    [node.subNodes addObject:subNode];
    
    int i = index + 1;
    while (i < subStr.length) {
        NSString *headerStr = [subStr substringWithRange:NSMakeRange(i, 1)];
        if ([headerStr isEqualToString:@"("]) {
            i = [self readSubGameTree:subStr node:subNode index:i];
        } else if ([headerStr isEqualToString:@")"]) {
            return i;
        } else {
            subNode.nodeStr = [subNode.nodeStr stringByAppendingString:headerStr];
        }
        i++;
    }
    
    return i;
}

+ (NSDictionary *)readBasicChessmanContent:(NSString *)content {
    
    NSArray *aBArray = [self locationsFromContent:content separateStr:@"AB"];
    NSArray *aWArray = [self locationsFromContent:content separateStr:@"AW"];
    
    return @{@"AB" : aBArray, @"AW" : aWArray};
    
}

+ (NSArray *)locationsFromContent:(NSString *)content separateStr:(NSString *)separate {
    NSArray *components = [content componentsSeparatedByString:separate];
    NSMutableArray *aArray = [NSMutableArray array];
    
    for (int i = 0; i < components.count; i++) {
        NSString *aStr = components[i];
        int j = 0;
        
        NSPoint point = NSZeroPoint;
        while (j < aStr.length) {
            
            NSString *headerStr = [aStr substringWithRange:NSMakeRange(j, 1)];
            if ([headerStr isEqualToString:@"["]) {
                if (j % 4 != 0) {
                    break;
                } else {
                    point = NSZeroPoint;
                }
            } else if ([headerStr isEqualToString:@"]"]) {
                [aArray addObject:NSStringFromPoint(point)];
            } else {
                if (j % 4 == 1) {
                    point.x = [self indexOfLetter:headerStr];
                }
                if (j % 4 == 2) {
                    point.y = [self indexOfLetter:headerStr];
                }
            }
            
            j++;
        }
    }
    
    return aArray;
}

+ (int)indexOfLetter:(NSString *)letter {
    if (letter.length > 1) {
        return 0;
    }
    
    NSArray *allLetters = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    return (int)[allLetters indexOfObject:letter] + 1;
}

@end
