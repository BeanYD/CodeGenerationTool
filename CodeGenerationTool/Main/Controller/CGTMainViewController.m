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
 * 目前使用数组存储，
 * TODO: 其他数据结构存储
 */
@property (nonatomic, strong) NSMutableArray<NSWindowController *> *winColList;

/**
 * 持有所有的viewController
 * 目前使用数组存储，
 * TODO: 其他数据结构存储
 */
@property (nonatomic, strong) NSMutableArray<NSViewController *> *viewColList;

@property (nonatomic, strong) NSButton *addButton;
@property (nonatomic, strong) NSButton *delButton;

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
        
        int maxCountVer = NSHeight(self.view.frame) / 32;
        CGFloat unitWidth = NSWidth(self.view.frame) / 4;
        CGFloat left = (i + 1) / maxCountVer * unitWidth + 20;
        CGFloat top = (i % maxCountVer) * (20 + 12) + 12;
        [moduleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(left);
            make.top.equalTo(self.view).offset(top);
        }];
    }
    
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.delButton];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addButton.mas_left).offset(-10);
        make.bottom.equalTo(self.view);
    }];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addModule:) name:@"AddModuleNotify" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delModule:) name:@"DelModuleNotify" object:nil];
//    [self testSort];
    
    
}

- (void)testSort {
    NSMutableArray *array = [@[@"83分56秒", @"37分58秒", @"718分43秒", @"53分46秒"] mutableCopy];
    
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = obj1;
        NSString *str2 = obj2;
        
        if ([str1 compare:str2] > 0) {
            return NSOrderedAscending;
        } else if ([str1 compare:str2] < 0) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    NSLog(@"%@", array);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Sel
- (void)addModule:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    
    // 记录当前的module数量
    NSInteger i = self.model.moduleList.count;
    NSButton *button = [NSButton buttonWithTitle:dict[@"name"] target:self action:@selector(showModuleWindow:)];
    button.tag = 100 + i;
    [self.view addSubview:button];
    int maxCountVer = NSHeight(self.view.frame) / 32;
    CGFloat unitWidth = NSWidth(self.view.frame) / 4;
    CGFloat left = i / maxCountVer * unitWidth + 20;
    CGFloat top = (i % maxCountVer) * (20 + 12) + 12;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(left);
        make.top.equalTo(self.view).offset(top);
    }];
    
    [self.model addModule:dict];
    
}

- (void)delModule:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    [self.model delModule:dict];
    NSArray *subviews = self.view.subviews;
    for (int i = 0; i < subviews.count; i++) {
        NSView *subview = subviews[i];
        if ([subview isMemberOfClass:[NSButton class]]) {
            NSButton *button = (NSButton *)subview;
            if ([button.title isEqualToString:dict[@"name"]]) {
                [button removeFromSuperview];
            }
        }
    }
}

#pragma mark - Button Click
- (void)showModuleWindow:(NSButton *)button {
    NSInteger index = button.tag - 100;
    NSString *winColName = self.model.moduleList[index][@"winCol"];
    NSWindowController *winCol = [self windowColMakingFromWindowColName:winColName];
    NSAssert(winCol, @"%@不存在，请创建", winColName);
    
    [winCol.window makeKeyAndOrderFront:nil];
    
    // 模态窗口-关闭时停止modal
//    [NSApp runModalForWindow:winCol.window];
        
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

- (void)addButtonClick:(NSButton *)button {
    NSViewController *createViewController = [[NSClassFromString(@"CGTCreateViewController") alloc] initWithFrame:NSMakeRect(0, 0, 300, 200)];
    [createViewController setValue:@"添加控制器" forKey:@"titleStr"];
    [self presentViewControllerAsSheet:createViewController];
}

- (void)delButtonClick:(NSButton *)button {
    NSViewController *vc = [[NSClassFromString(@"CGTCreateViewController") alloc] initWithFrame:NSMakeRect(0, 0, 300, 200)];
    [vc setValue:@"删除控制器" forKey:@"titleStr"];
    [self presentViewControllerAsSheet:vc];
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

- (NSButton *)addButton {
    if (!_addButton) {
        _addButton = [NSButton buttonWithImage:[NSImage imageNamed:NSImageNameAddTemplate] target:self action:@selector(addButtonClick:)];
    }
    
    return _addButton;
}

- (NSButton *)delButton {
    if (!_delButton) {
        _delButton = [NSButton buttonWithImage:[NSImage imageNamed:NSImageNameMenuMixedStateTemplate] target:self action:@selector(delButtonClick:)];
    }
    
    return _delButton;
}

@end
