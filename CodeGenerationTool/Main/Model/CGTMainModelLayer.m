//
//  CGTMainModelLayer.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/6.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTMainModelLayer.h"

@interface CGTMainModelLayer () {
    NSString *_classPath;
    NSMutableDictionary *_dataDict;
}

@end

@implementation CGTMainModelLayer

- (instancetype)init {
	if (self = [super init]) {
        [self plistData];
        [self saveBaseList];
        self.moduleList = [self getAllModules];
	}
	
	return self;
}

- (void)plistData {
    NSString *path = [self getPlistPath];
    _classPath = path;
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    _dataDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
}

- (NSString *)getPlistPath1 {
    NSArray *sandBoxPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [sandBoxPath objectAtIndex:0];
    NSString *plistPath = [documentPath stringByAppendingPathComponent:@"ClassInfo.plist"];
    NSLog(@"\n------------------------------------------\nplist path:\n%@\n------------------------------------------", plistPath);
    return plistPath;
}

- (NSString *)getPlistPath {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ClassInfo" ofType:@"plist"];
    NSLog(@"\n------------------------------------------\nplist path:\n%@\n------------------------------------------", plistPath);
    return plistPath;
}

- (NSMutableArray *)getAllModules {
    return [NSMutableArray arrayWithArray:[_dataDict objectForKey:@"classInfo"]];
}

- (void)addModule:(NSDictionary *)dict {
    NSMutableArray *moduleList = [NSMutableArray arrayWithArray:[_dataDict objectForKey:@"classInfo"]];
    [moduleList addObject:dict];
    
    [_dataDict setObject:moduleList forKey:@"classInfo"];
    [_dataDict writeToFile:_classPath atomically:YES];
}

- (void)delModule:(NSDictionary *)dict {
    NSMutableArray *moduleList = [NSMutableArray arrayWithArray:[_dataDict objectForKey:@"classInfo"]];
    if (moduleList.count == 0) {
        NSLog(@"无多余的类需要删除");
        return;
    }
    
    for (int i = 0; i < moduleList.count; i++) {
        NSDictionary *module = moduleList[i];
        if ([[module valueForKey:@"winCol"] isEqualToString:[dict valueForKey:@"winCol"]]) {
            [moduleList removeObject:module];
            break;
        }
    }
    
    [_dataDict setObject:moduleList forKey:@"classInfo"];
    [_dataDict writeToFile:_classPath atomically:YES];
}

- (void)saveBaseList {
    NSArray *baseList = [self baseModuleList];
    
    NSMutableArray *moduleList = [NSMutableArray arrayWithArray:[_dataDict objectForKey:@"classInfo"]];
    if (moduleList.count != 0) {
        return;
    }
    
    [_dataDict setObject:baseList forKey:@"classInfo"];
    [_dataDict writeToFile:_classPath atomically:YES];
}

- (NSArray *)baseModuleList {
    return @[
        @{
            @"name" : @"列表",
            @"winCol" : @"CGTDDTableWindowController",
        },
        @{
            @"name" : @"网格",
            @"winCol" : @"CGTDDCollectionWindowController",
        },
        @{
            @"name" : @"opengl",
            @"winCol" : @"CGTOpenglWindowController",
        },
        @{
            @"name" : @"鼠标事件",
            @"winCol" : @"CGTMouseEventWindowController",
        },
        @{
            @"name" : @"commonDemo",
            @"winCol" : @"CGTCommonDemoWindowController",
        },
        @{
            @"name" : @"drawLayer",
            @"winCol" : @"CGTDrawWindowController",
        },
        @{
            @"name" : @"excel导入导出",
            @"winCol" : @"CGTExcelWindowController",
        },
        @{
            @"name" : @"围棋",
            @"winCol" : @"CGTWeiQiWindowController",
        },
    ];
}





@end
