//
//  CGTDrawViewController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/1/25.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTDrawViewController.h"
#import "CGTDrawView.h"

@interface CGTDrawViewController ()

@property (nonatomic, strong) NSButton *lineButton;
@property (nonatomic, strong) NSButton *direLineButton;
@property (nonatomic, strong) NSButton *direDashButton;

@property (nonatomic, strong) CGTDrawView *drawView;

@end

@implementation CGTDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view addSubview:self.drawView];
    [self.view addSubview:self.lineButton];
    [self.view addSubview:self.direLineButton];
    [self.view addSubview:self.direDashButton];
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [self.lineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(20);
    }];
    
    [self.direLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineButton);
        make.top.equalTo(self.lineButton.mas_bottom).offset(10);
    }];
    
    [self.direDashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineButton);
        make.top.equalTo(self.direLineButton.mas_bottom).offset(10);
    }];
    
    [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(100);
        make.top.equalTo(self.view).offset(10);
        make.right.bottom.equalTo(self.view).offset(-10);
    }];
}

#pragma mark - Button Click
- (void)lineButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeLine;
}

- (void)direLineButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeDirectLine;
}

- (void)direDashButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeDirectDash;
}

#pragma mark - Getter

- (CGTDrawView *)drawView {
    if (!_drawView) {
        _drawView = [[CGTDrawView alloc] init];
    }
    
    return _drawView;
}

- (NSButton *)lineButton {
    if (!_lineButton) {
        _lineButton = [[NSButton alloc] init];
        _lineButton.title = @"连续线条";
        _lineButton.target = self;
        _lineButton.action = @selector(lineButtonClick:);
    }
    
    return _lineButton;
}

- (NSButton *)direLineButton {
    if (!_direLineButton) {
        _direLineButton = [[NSButton alloc] init];
        _direLineButton.title = @"直线";
        _direLineButton.target = self;
        _direLineButton.action = @selector(direLineButtonClick:);
    }
    
    return _direLineButton;
}

- (NSButton *)direDashButton {
    if (!_direDashButton) {
        _direDashButton = [[NSButton alloc] init];
        _direDashButton.title = @"虚线";
        _direDashButton.target = self;
        _direDashButton.action = @selector(direDashButtonClick:);
    }
    
    return _direDashButton;
}

@end
