//
//  CGTWeiQiViewController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/9/24.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTWeiQiViewController.h"
#import "CGTWeiQiBoardView.h"
#import "CGTWeiQiModelLayer.h"

@interface CGTWeiQiViewController ()

@property (nonatomic, strong) NSButton *autoChgBtn;

@property (nonatomic, strong) NSButton *currentChessBtn;

@property (strong) CGTWeiQiModelLayer *model;

@end

@implementation CGTWeiQiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.model = [CGTWeiQiModelLayer new];
    CGTWeiQiBoardView *boardView = [[CGTWeiQiBoardView alloc] initWithFrame:NSMakeRect((NSWidth(self.view.frame) - 800) / 2, (NSHeight(self.view.frame) - 800) / 2, 800, 800)];
    [boardView loadModelLayer:self.model];
    
    [self.view addSubview:boardView];
    
    [self.view addSubview:self.autoChgBtn];
    [self.view addSubview:self.currentChessBtn];
    self.currentChessBtn.hidden = YES;
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    
    [self.autoChgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-100);
        make.top.equalTo(self.view).offset(30);
    }];
    
    [self.currentChessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.autoChgBtn.mas_right).offset(20);
        make.top.equalTo(self.autoChgBtn);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
}

#pragma mark - Button Click
- (void)autoChgButtonClick:(NSButton *)button {
    if ([_autoChgBtn.title isEqualToString:@"自动切换黑白子"]) {
        _autoChgBtn.title = @"手动切换黑白子";
        _currentChessBtn.hidden = NO;
        _currentChessBtn.image = [NSImage imageNamed:@"black_chess"];
        self.model.isAuto = NO;
        self.model.isWhite = NO;
    } else {
        _autoChgBtn.title = @"自动切换黑白子";
        _currentChessBtn.hidden = YES;
        self.model.isAuto = YES;
    }
}

- (void)currentChessButtonClick:(NSButton *)button {
    if ([_currentChessBtn.image.name isEqualToString:@"black_chess"]) {
        _currentChessBtn.image = [NSImage imageNamed:@"white_chess"];
        self.model.isWhite = YES;
    } else {
        _currentChessBtn.image = [NSImage imageNamed:@"black_chess"];
        self.model.isWhite = NO;
    }
}

#pragma mark - Getter

- (NSButton *)autoChgBtn {
    if (!_autoChgBtn) {
        _autoChgBtn = [[NSButton alloc] init];
        _autoChgBtn.title = @"自动切换黑白子";
        _autoChgBtn.target = self;
        _autoChgBtn.action = @selector(autoChgButtonClick:);
    }
    
    return _autoChgBtn;
}

- (NSButton *)currentChessBtn {
    if (!_currentChessBtn) {
        _currentChessBtn = [[NSButton alloc] init];
        _currentChessBtn.image = [NSImage imageNamed:@"black_chess"];
        _currentChessBtn.target = self;
        _currentChessBtn.imageScaling = NSImageScaleAxesIndependently;
        _currentChessBtn.action = @selector(currentChessButtonClick:);

    }
    
    return _currentChessBtn;
}

@end
