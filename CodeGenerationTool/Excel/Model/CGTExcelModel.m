//
//  CGTExcelModel.m
//  CodeGenerationTool
//
//  Created by mac on 2021/3/8.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTExcelModel.h"
#import "ZipArchive.h"
#import "GDataXMLNode.h"
#import "xlsxwriter.h"

@implementation CGTExcelModel

// 导出excel表格
+ (BOOL)writeExcelToPath:(NSString *)path data:(NSArray *)dataArray {
    lxw_workbook *workbook = workbook_new([path UTF8String]);
    lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
    worksheet_write_string(worksheet, 0, 0, [NSLocalizedString(@"题目类型", nil) UTF8String], NULL);
    worksheet_write_string(worksheet, 0, 1, [NSLocalizedString(@"题干", nil) UTF8String], NULL);
    worksheet_write_string(worksheet, 0, 2, [NSLocalizedString(@"答案", nil) UTF8String], NULL);
    worksheet_write_string(worksheet, 0, 3, [NSLocalizedString(@"题分", nil) UTF8String], NULL);
    for (int i = 1; i <= 8; i++) {
        NSString *itemStr = [NSString stringWithFormat:@"%@%d", NSLocalizedString(@"选项", nil), i];
        worksheet_write_string(worksheet, 0, 3 + i, [itemStr UTF8String], NULL);
    }
    
    

    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *colArray = obj;
        uint32_t lxw_row_t = (uint32_t)idx;
        [colArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *colObj = obj;
            uint32_t lxw_col_t = (uint32_t)idx;
            worksheet_write_string(worksheet, lxw_row_t, lxw_col_t, [colObj UTF8String], NULL);
            
        }];
    }];
    
    worksheet_set_column(worksheet, 0, 0, 10.5, NULL);
    worksheet_set_column(worksheet, 1, 1, 45.5, NULL);
    worksheet_set_column(worksheet, 2, 11, 7, NULL);
    worksheet_set_row(worksheet, 0, 24, NULL);
    
    workbook_close(workbook);
    
    return YES;
}

// 导入excel内容
+ (NSArray *)readSheetArrayFromPath:(NSString *)path {
    
    NSString *xlStr = [self unzipExcelWithPath:path];
    NSArray *textArray = [self readTextXMLFromPath:xlStr];
    
    NSString *workSheetStr = [xlStr stringByAppendingPathComponent:@"worksheets"];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:workSheetStr error:nil];
    NSMutableArray *sheetArray = [NSMutableArray array];
    for (int i = 0; i < files.count; i++) {
        NSString *fileName = files[i];
        NSString *sheetPath = [workSheetStr stringByAppendingPathComponent:fileName];
        NSData *data = [[NSData alloc] initWithContentsOfFile:sheetPath];
        
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
        if (!doc) {
            continue;
        }
        
        NSArray *sheetEles = [doc.rootElement elementsForName:@"sheetData"];
        if (sheetEles.count == 0) {
            continue;
        }
        
        GDataXMLElement *sheetEle = [sheetEles lastObject];
        NSArray *rowEles = [sheetEle elementsForName:@"row"];
        
        NSMutableArray *rowArray = [NSMutableArray array];
        for (int j = 0; j < rowEles.count; j++) {
            GDataXMLElement *rowEle = rowEles[j];
            
            NSArray *colEles = [rowEle elementsForName:@"c"];
            if (colEles.count == 0) {
                continue;
            }
            
            NSMutableArray *colArray = [NSMutableArray array];
            for (int k = 0; k < colEles.count; k++) {
                GDataXMLElement *colEle = colEles[k];
                NSArray *vEles = [colEle elementsForName:@"v"];
                
                NSString *value;
                if (vEles.count == 0) {
                    value = @"";
                    [colArray addObject:value];
                    continue;
                }
                GDataXMLElement *vEle = [vEles lastObject];
                if (vEle.stringValue.length == 0) {
                    value = @"";
                    [colArray addObject:value];
                    continue;
                }
                
                int index = vEle.stringValue.intValue;
                if (textArray.count > index) {
                    value = [textArray objectAtIndex:index];
                    [colArray addObject:value];
                }
            }
            
            // 倒序遍历，去除空白内容
            NSMutableArray *removeArray = [NSMutableArray array];
            for (NSInteger k = colArray.count - 1; k >= 0; k--) {
                NSString *value = colArray[k];
                if (value.length == 0) {
                    [removeArray addObject:value];
                } else {
                    break;
                }
            }
            [colArray removeObjectsInArray:removeArray];
            
            if (colArray.count > 0) {
                [rowArray addObject:colArray];
            }
        }
        
        if (rowArray.count > 0) {
            [sheetArray addObject:rowArray];
        }
    }
    
    return sheetArray;
}

+ (NSArray *)readTextXMLFromPath:(NSString *)path {
    NSString *shareStr = [path stringByAppendingPathComponent:@"sharedStrings.xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:shareStr];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
    
    if (!doc) {
        return nil;
    }
    
    NSArray *siEles = [doc.rootElement elementsForName:@"si"];
    
    NSMutableArray *textList = [NSMutableArray array];
    
    for (int i = 0; i < siEles.count; i++) {
        GDataXMLElement *siEle = siEles[i];
        NSArray *tEles = [siEle elementsForName:@"t"];
        
        if (tEles.count > 0) {
            GDataXMLElement *tEle = [tEles lastObject];
            NSString *text = tEle.stringValue;
            if (text.length == 0) {
                text = @"";
            }
            [textList addObject:text];
        }
    }
    
    return textList;
}

+ (NSString *)unzipExcelWithPath:(NSString *)path {
    // 解压zip文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *unzipPath = [docDir stringByAppendingPathComponent:@"Cont"];
    
    NSLog(@"unzip file Path:%@", unzipPath);
    
    BOOL succeed = [SSZipArchive unzipFileAtPath:path toDestination:unzipPath];
    
    if (succeed) {
        NSLog(@"解压xlsx的zip文件失败，直接返回");
        return nil;
    }
    
    NSString *xlStr = [unzipPath stringByAppendingPathComponent:@"xl"];
    
    return xlStr;
}

@end
