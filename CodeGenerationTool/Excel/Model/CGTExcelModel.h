//
//  CGTExcelModel.h
//  CodeGenerationTool
//
//  Created by mac on 2021/3/8.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGTExcelModel : NSObject

+ (BOOL)writeExcelToPath:(NSString *)path data:(NSArray *)dataArray;
+ (NSDictionary *)readSheetInfosFromPath:(NSString *)path;

// 读取表格中不同sheet的名称和对应的sheet的位置
+ (NSArray *)readSheetFileInfosFromPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
