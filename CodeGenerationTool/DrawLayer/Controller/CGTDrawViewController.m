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
@property (nonatomic, strong) NSButton *eraserButton;
@property (nonatomic, strong) NSButton *uploadButton;
@property (nonatomic, strong) NSButton *normalButton;

@property (nonatomic, strong) CGTDrawView *drawView;

@end

@implementation CGTDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view addSubview:self.drawView];
    [self.view addSubview:self.normalButton];
    [self.view addSubview:self.lineButton];
    [self.view addSubview:self.direLineButton];
    [self.view addSubview:self.direDashButton];
    [self.view addSubview:self.eraserButton];
    [self.view addSubview:self.uploadButton];
    
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [self.normalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(20);
    }];
    
    [self.lineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.normalButton.mas_bottom).offset(10);
    }];
    
    [self.direLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.lineButton.mas_bottom).offset(10);
    }];
    
    [self.direDashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.direLineButton.mas_bottom).offset(10);
    }];
    
    [self.eraserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.direDashButton.mas_bottom).offset(10);
    }];
    
    [self.uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.eraserButton.mas_bottom).offset(10);
    }];
    
    [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(100);
        make.top.equalTo(self.view).offset(10);
        make.right.bottom.equalTo(self.view).offset(-10);
    }];
}

#pragma mark - Button Click
- (void)normalButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeNormal;
}

- (void)lineButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeLine;
}

- (void)direLineButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeDirectLine;
}

- (void)direDashButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeDirectDash;
}

- (void)eraserButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeEraser;
}

- (void)uploadButtonClick:(NSButton *)button {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canCreateDirectories = YES;
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = NO;
    panel.allowsMultipleSelection = NO;
    panel.allowedFileTypes = [NSArray arrayWithObjects:@"jpg", @"png", @"jpeg", nil];
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSString *path = [panel.URL path];
            NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
            NSImage *image = [[NSImage alloc] initWithData:data];
            
            self.drawView.type = CGTDrawTypeImage;
            [self.drawView loadImage:image];
            
        }
    }];
}

#pragma mark - Getter

- (CGTDrawView *)drawView {
    if (!_drawView) {
        _drawView = [[CGTDrawView alloc] init];
    }
    
    return _drawView;
}

- (NSButton *)normalButton {
    if (!_normalButton) {
        _normalButton = [[NSButton alloc] init];
        _normalButton.title = @"取消标注";
        _normalButton.target = self;
        _normalButton.action = @selector(normalButtonClick:);
    }
    
    return _normalButton;
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

- (NSButton *)eraserButton {
    if (!_eraserButton) {
        _eraserButton = [[NSButton alloc] init];
        _eraserButton.title = @"橡皮擦";
        _eraserButton.target = self;
        _eraserButton.action = @selector(eraserButtonClick:);
    }
    
    return _eraserButton;
}

- (NSButton *)uploadButton {
    if (!_uploadButton) {
        _uploadButton = [[NSButton alloc] init];
        _uploadButton.title = @"上传图片";
        _uploadButton.target = self;
        _uploadButton.action = @selector(uploadButtonClick:);
    }
    
    return _uploadButton;
}

@end
