//
//  CGTExcelViewController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/3/5.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTExcelViewController.h"

@interface CGTExcelViewController ()

@property (nonatomic, strong) NSButton *importButton;
@property (nonatomic, strong) NSButton *exportButton;

@end

@implementation CGTExcelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view addSubview:self.importButton];
    [self.view addSubview:self.exportButton];

    
    [self layoutSubviews];
    
}

- (void)layoutSubviews {
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_centerX).offset(-20);
        make.top.equalTo(self.view).offset(20);
    }];
    
    [self.exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.importButton.mas_right).offset(20);
        make.left.equalTo(self.view.mas_centerX).offset(20);
        make.top.equalTo(self.importButton);
    }];
}

#pragma mark - Button Click
- (void)importButtonClick:(NSButton *)button {
    
}

- (void)exportButtonClick:(NSButton *)button {
    
}

#pragma mark - Setter && Getter
- (NSButton *)importButton {
    if (!_importButton) {
        _importButton = [[NSButton alloc] init];
        _importButton.title = @"导入";
        _importButton.target = self;
        _importButton.action = @selector(importButtonClick:);
    }
    
    return _importButton;
}

- (NSButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [[NSButton alloc] init];
        _exportButton.title = @"导出";
        _exportButton.target = self;
        _exportButton.action = @selector(exportButtonClick:);
    }
    
    return _exportButton;
}

@end
