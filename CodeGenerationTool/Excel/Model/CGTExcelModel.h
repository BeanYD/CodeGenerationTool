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

+ (NSDictionary *)readSheetInfosFromPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
