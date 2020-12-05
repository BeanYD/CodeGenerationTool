//
//  CGTMainModelLayer.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/6.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTMainModelLayer.h"

@interface CGTMainModelLayer ()



@end

@implementation CGTMainModelLayer

- (instancetype)init {
	if (self = [super init]) {
        self.moduleList = [NSMutableArray arrayWithArray:[self baseModuleList]];
	}
	
	return self;
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
    ];
}

- (void)addModule:(NSDictionary *)dict {
    [self.moduleList addObject:dict];
}



@end
