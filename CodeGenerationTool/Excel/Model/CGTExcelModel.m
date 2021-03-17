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
+ (NSDictionary *)readSheetInfosFromPath:(NSString *)path {
    
    NSString *xlStr = [self unzipExcelWithPath:path];
    NSArray *textArray = [self readTextXMLFromPath:xlStr];
    NSArray *sheetInfos = [self readSheetFileInfosFromXlPath:xlStr];
    
    NSString *workSheetStr = [xlStr stringByAppendingPathComponent:@"worksheets"];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:workSheetStr error:nil];
    NSMutableDictionary *sheetInfo = [NSMutableDictionary dictionary];
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
                
                /**
                 * 存在部分纯数字的内容不需要再sharedString.xml中查找内容
                 *         <c r="B2" t="s" s="7"><v>19</v></c>
                 *         存在 t="s" 需要到表中查找
                 *         <c r="C2" s="8"><v>5</v></c>
                 *         不存在 t="s" 直接获取内容即可
                 */
                
                NSArray *attrs = colEle.attributes;
                BOOL isIndex = NO;
                int attrIndex = 0;
                while (attrIndex < attrs.count) {
                    GDataXMLNode *node = attrs[attrIndex];
                    if ([node.name isEqualToString:@"t"]) {
                        isIndex = YES;
                        break;
                    }
                    attrIndex++;
                }
                
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
                
                if (isIndex) {
                    int index = vEle.stringValue.intValue;
                    // 如果index存在于textarray中
                    if (textArray.count > index) {
                        value = [textArray objectAtIndex:index];
                        [colArray addObject:value];
                    }
                } else {
                    [colArray addObject:vEle.stringValue];
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
            if (i < sheetInfos.count) {
                NSDictionary *fileInfo = sheetInfos[i];
                fileName = [fileInfo valueForKey:@"sheetName"];
            }
            
            [sheetInfo setValue:rowArray forKey:fileName];
        }
    }
    
    NSString *removePath = [xlStr stringByDeletingLastPathComponent];
    
    [[NSFileManager defaultManager] removeItemAtPath:removePath error:nil];
    
    return sheetInfo;
}

+ (NSArray *)readTextXMLFromPath:(NSString *)path {
    NSString *shareStr = [path stringByAppendingPathComponent:@"sharedStrings.xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:shareStr];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
    
    if (!doc) {
        return nil;
    }
    /**
     * excel的文本xml根据格式存在各种标签
     * 目前遇到的是单元格下有多个字体的时候会分标签
     * <si>
     *      <t>如果某细胞兴奋期周期的绝对不应期为2ms，理论上每秒内所能产生和传导的动作电位数最多不超过（   ）</t>
     * </si>
     * <si>
     *      <r><rPr><sz val="10"/><color indexed="8"/><rFont val="Calibri"/></rPr><t>5</t></r>
     *      <r><rPr><sz val="10"/><color indexed="8"/><rFont val="宋体"/></rPr><t>次</t></r>
     * </si>
     */
    NSArray *siEles = [doc.rootElement elementsForName:@"si"];
    
    NSMutableArray *textList = [NSMutableArray array];
    
    for (int i = 0; i < siEles.count; i++) {
        GDataXMLElement *siEle = siEles[i];
        
        // 先尝试查找r标签，不存在，则寻找t标签
        NSArray *rEles = [siEle elementsForName:@"r"];
        if (rEles.count == 0) {
            NSArray *tEles = [siEle elementsForName:@"t"];
            if (tEles.count > 0) {
                GDataXMLElement *tEle = [tEles lastObject];
                NSString *text = tEle.stringValue;
                if (text.length == 0) {
                    text = @"";
                }
                [textList addObject:text];
            }
        } else {
            NSString *text = @"";
            for (int k = 0; k < rEles.count; k++) {
                GDataXMLElement *rEle = rEles[k];
                NSArray *tEles = [rEle elementsForName:@"t"];
                if (tEles.count > 0) {
                    GDataXMLElement *tEle = [tEles lastObject];
                    text = [text stringByAppendingString:tEle.stringValue];
                }
            }
            text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (text.length == 0) {
                text = @"";
            }
            [textList addObject:text];
        }
    }
    
    return textList;
}

+ (NSArray *)readSheetFileInfosFromPath:(NSString *)path {
    NSString *xlStr = [self unzipExcelWithPath:path];
    return  [self readSheetFileInfosFromXlPath:xlStr];
}

+ (NSArray *)readSheetFileInfosFromXlPath:(NSString *)xlPath {
    NSString *workBookStr = [xlPath stringByAppendingPathComponent:@"workbook.xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:workBookStr];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
    if (!doc) {
        return nil;
    }
    
    NSArray *sheetsEles = [doc.rootElement elementsForName:@"sheets"];
    
    NSMutableArray *sheetInfos = [NSMutableArray array];
    
    if (sheetsEles.count == 0) {
        return nil;
    }
    
    GDataXMLElement *sheetsEle = [sheetsEles lastObject];
    NSArray *sheetEles = [sheetsEle elementsForName:@"sheet"];
    
    
    for (int i = 0; i < sheetEles.count; i++) {
        GDataXMLElement *sheetEle = sheetEles[i];
        NSArray *attrs = sheetEle.attributes;
        NSMutableDictionary *fileInfo = [NSMutableDictionary dictionary];
        for (int j = 0; j < attrs.count; j++) {
            GDataXMLNode *node = attrs[j];
            if ([node.name isEqualToString:@"name"]) {
                [fileInfo setValue:node.stringValue forKey:@"sheetName"];
            }
            if ([node.name isEqualToString:@"sheetId"]) {
                [fileInfo setValue:node.stringValue forKey:@"sheetIndex"];
            }
        }
        [sheetInfos addObject:fileInfo];
    }
    
    return sheetInfos;
}

+ (NSString *)unzipExcelWithPath:(NSString *)path {
    // 解压zip文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *unzipPath = [docDir stringByAppendingPathComponent:@"Cont"];
    
    NSLog(@"unzip file Path:%@", unzipPath);
    
    BOOL succeed = [SSZipArchive unzipFileAtPath:path toDestination:unzipPath];
    
    if (!succeed) {
        NSLog(@"解压xlsx的zip文件失败，直接返回");
        return nil;
    }
    
    NSString *xlStr = [unzipPath stringByAppendingPathComponent:@"xl"];
    
    return xlStr;
}

@end
