//
//  CGTMainViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/4.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTMainViewController.h"
#import "CGTMainModelLayer.h"

@interface CGTMainViewController ()

@property (nonatomic, strong) CGTMainModelLayer *model;

/**
 * 持有所有的windowController
 * 暂时使用数组存储，后续考虑其他数据结构存储
 */
@property (nonatomic, strong) NSMutableArray<NSWindowController *> *winColList;

/**
 * 持有所有的viewController
 * 暂时使用数组存储，后续考虑其他数据结构存储
 */
@property (nonatomic, strong) NSMutableArray<NSViewController *> *viewColList;

@end

@implementation CGTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
	
	self.view.wantsLayer = YES;
	self.view.layer.backgroundColor = [NSColor colorWithWhite:0.3 alpha:1].CGColor;

    for (int i = 0; i < self.model.moduleList.count; i++) {
        NSDictionary *moduleDict = self.model.moduleList[i];
        NSButton *moduleButton = [NSButton buttonWithTitle:moduleDict[@"name"] target:self action:@selector(showModuleWindow:)];
        moduleButton.tag = 100 + i;
        [self.view addSubview:moduleButton];
        [moduleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(40);
            make.height.equalTo(@40);
            make.top.equalTo(self.view).offset((20 + 40) * i);
        }];
    }
		
}

#pragma mark - Button Click
- (void)showModuleWindow:(NSButton *)button {
    NSInteger index = button.tag - 100;
    NSString *winColName = self.model.moduleList[index][@"winCol"];
    NSWindowController *winCol = [self windowColMakingFromWindowColName:winColName];
    NSAssert(winCol, @"%@不存在，请创建", winColName);
    
    [winCol.window makeKeyAndOrderFront:nil];
    
    for (int i = 0; i < self.winColList.count; i++) {
        NSWindowController *listWinCol = self.winColList[i];
        if ([NSStringFromClass([listWinCol class]) isEqualToString:winColName]) {
            // 存在windCol
            [listWinCol.window close];
            listWinCol = winCol;
            return;
        }
    }
    
    [self.winColList addObject:winCol];
}

#pragma mark - setter && getter

- (CGTMainModelLayer *)model {
	if (!_model) {
		_model = [[CGTMainModelLayer alloc] init];
	}
	
	return _model;
}

- (NSMutableArray<NSWindowController *> *)winColList {
    if (!_winColList) {
        _winColList = [NSMutableArray array];
    }
    
    return _winColList;
}

- (NSMutableArray<NSViewController *> *)viewColList {
    if (!_viewColList) {
        _viewColList = [NSMutableArray array];
    }
    
    return _viewColList;
}

@end
