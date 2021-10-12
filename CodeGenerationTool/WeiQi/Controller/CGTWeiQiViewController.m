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

@property (nonatomic, strong) NSButton *clearBtn;

@property (strong) CGTWeiQiBoardView *boardView;

@property (nonatomic, strong) NSButton *readSgfBtn;

@end

@implementation CGTWeiQiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.model = [CGTWeiQiModelLayer new];
    CGTWeiQiBoardView *boardView = [[CGTWeiQiBoardView alloc] initWithFrame:NSMakeRect((NSWidth(self.view.frame) - 800) / 2, (NSHeight(self.view.frame) - 800) / 2, 800, 800)];
    [boardView loadModelLayer:self.model];
    self.boardView = boardView;
    
    [self.view addSubview:boardView];
    
    [self.view addSubview:self.autoChgBtn];
    [self.view addSubview:self.currentChessBtn];
    [self.view addSubview:self.clearBtn];
    [self.view addSubview:self.readSgfBtn];
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
    
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentChessBtn.mas_right).offset(20);
        make.top.equalTo(self.currentChessBtn);
    }];
    
    [self.readSgfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clearBtn.mas_right).offset(20);
        make.top.equalTo(self.clearBtn);
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

- (void)clearButtonClick:(NSButton *)button {
    [self.boardView clearChessmans];
}

- (void)readSgfButtonClick:(NSButton *)button {
    // 弹出panel选择文件或者文件夹
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    // 是否可以创建文件夹
    panel.canCreateDirectories = NO;
    // 是否可以选择文件夹
    panel.canChooseDirectories = NO;
    // 是否可以选择文件
    panel.canChooseFiles = YES;
    // 是否支持多选
    panel.allowsMultipleSelection = YES;
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
    
        if (result == NSModalResponseOK) {
            
            NSString *path = [panel.URL path];
            
            // MARK: 目标文件的编码方式查看：terminal中输入file xxxx.sgf
            
            /* Note that in addition to the values explicitly listed below, NSStringEncoding supports encodings provided by CFString.
            See CFStringEncodingExt.h for a list of these encodings.
            See CFString.h for functions which convert between NSStringEncoding and CFStringEncoding.
            */
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSError *error = nil;
            NSString *string = [NSString stringWithContentsOfFile:path encoding:enc error:&error];
            [self.boardView loadSgfFileContent:string];
        }
        
    }];
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

- (NSButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[NSButton alloc] init];
        _clearBtn.title = @"清空棋盘";
        _clearBtn.target = self;
        _clearBtn.action = @selector(clearButtonClick:);
    }
    
    return _clearBtn;
}

- (NSButton *)readSgfBtn {
    if (!_readSgfBtn) {
        _readSgfBtn = [[NSButton alloc] init];
        _readSgfBtn.title = @"读取sgf文件";
        _readSgfBtn.target = self;
        _readSgfBtn.action = @selector(readSgfButtonClick:);
    }
    
    return _readSgfBtn;
}

@end
