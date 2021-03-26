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
@property (nonatomic, strong) NSButton *thinButton;
@property (nonatomic, strong) NSButton *thinkerButton;
@property (nonatomic, strong) NSButton *strokeButton;
@property (nonatomic, strong) NSButton *direLineButton;
@property (nonatomic, strong) NSButton *direDashButton;
@property (nonatomic, strong) NSButton *arrowLineButton;
@property (nonatomic, strong) NSButton *rectButton;
@property (nonatomic, strong) NSButton *ellipseButton;
@property (nonatomic, strong) NSButton *textButton;
@property (nonatomic, strong) NSButton *eraserButton;
@property (nonatomic, strong) NSButton *uploadButton;
@property (nonatomic, strong) NSButton *normalButton;

@property (nonatomic, strong) CGTDrawView *drawView;

// 记录上一个选中的按钮
@property (strong) NSButton *previousButton;

@end

@implementation CGTDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view addSubview:self.drawView];
    [self.view addSubview:self.normalButton];
    [self.view addSubview:self.lineButton];
    [self.view addSubview:self.thinButton];
    [self.view addSubview:self.thinkerButton];
    [self.view addSubview:self.strokeButton];
    [self.view addSubview:self.direLineButton];
    [self.view addSubview:self.direDashButton];
    [self.view addSubview:self.arrowLineButton];
    [self.view addSubview:self.rectButton];
    [self.view addSubview:self.ellipseButton];
    [self.view addSubview:self.textButton];
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
    
    [self.thinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.lineButton.mas_bottom).offset(10);
    }];
    
    [self.thinkerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thinButton.mas_right).offset(2);
        make.top.equalTo(self.thinButton);
    }];
    
    [self.strokeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thinkerButton.mas_right).offset(2);
        make.top.equalTo(self.thinkerButton);
    }];
    
    [self.direLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.thinButton.mas_bottom).offset(10);
    }];
    
    [self.direDashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.direLineButton.mas_bottom).offset(10);
    }];
    
    [self.arrowLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.direDashButton.mas_bottom).offset(10);
    }];
    
    [self.rectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.arrowLineButton.mas_bottom).offset(10);
    }];
    
    [self.ellipseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.rectButton.mas_bottom).offset(10);
    }];
    
    [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.ellipseButton.mas_bottom).offset(10);
    }];
    
    [self.eraserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalButton);
        make.top.equalTo(self.textButton.mas_bottom).offset(10);
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
    [self updateButton:button];
}

- (void)lineButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeCurveLine;
    [self updateButton:button];
}

- (void)thinButtonClick:(NSButton *)button {
    if (self.drawView.lineWidth <= 1) {
        return;
    }
    self.drawView.lineWidth--;
}

- (void)thinkerButtonClick:(NSButton *)button {
    if (self.drawView.lineWidth >= 20) {
        return;
    }
    self.drawView.lineWidth++;
}

- (void)strokeButtonClick:(NSButton *)button {
    self.drawView.isStroke = !self.drawView.isStroke;
    
    if (self.drawView.isStroke) {
        [self.strokeButton setTitle:@"峰"];
        self.strokeButton.toolTip = @"取消笔锋";
    } else {
        [self.strokeButton setTitle:@"无"];
        self.strokeButton.toolTip = @"添加笔锋";
    }
}

- (void)direLineButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeDirectLine;
    [self updateButton:button];
}

- (void)direDashButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeDirectDash;
    [self updateButton:button];
}

- (void)arrowLineButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeArrowDirectLine;
    [self updateButton:button];
}

- (void)rectButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeRect;
    [self updateButton:button];
}

- (void)ellipseButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeEllipse;
    [self updateButton:button];
}

- (void)textButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeText;
    [self updateButton:button];
}

- (void)eraserButtonClick:(NSButton *)button {
    self.drawView.type = CGTDrawTypeEraser;
    [self updateButton:button];
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

- (void)updateButton:(NSButton *)button {
    self.previousButton.enabled = YES;
    self.previousButton = button;
    button.enabled = NO;
    
//    [self.drawView resetCursor];
}

#pragma mark - Getter

- (CGTDrawView *)drawView {
    if (!_drawView) {
        _drawView = [[CGTDrawView alloc] init];
        _drawView.lineWidth = 1.0f;
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

- (NSButton *)thinButton {
    if (!_thinButton) {
        _thinButton = [[NSButton alloc] init];
        _thinButton.title = @"-";
        _thinButton.target = self;
        _thinButton.action = @selector(thinButtonClick:);
    }
    
    return _thinButton;
}

- (NSButton *)thinkerButton {
    if (!_thinkerButton) {
        _thinkerButton = [[NSButton alloc] init];
        _thinkerButton.title = @"+";
        _thinkerButton.target = self;
        _thinkerButton.action = @selector(thinkerButtonClick:);
    }
    
    return _thinkerButton;
}

- (NSButton *)strokeButton {
    if (!_strokeButton) {
        _strokeButton = [[NSButton alloc] init];
        _strokeButton.title = @"无";
        _strokeButton.target = self;
        _strokeButton.action = @selector(strokeButtonClick:);
    }
    
    return _strokeButton;
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

- (NSButton *)arrowLineButton {
    if (!_arrowLineButton) {
        _arrowLineButton = [[NSButton alloc] init];
        _arrowLineButton.title = @"箭头线";
        _arrowLineButton.target = self;
        _arrowLineButton.action = @selector(arrowLineButtonClick:);
    }
    
    return _arrowLineButton;
}

- (NSButton *)rectButton {
    if (!_rectButton) {
        _rectButton = [[NSButton alloc] init];
        _rectButton.title = @"长方形";
        _rectButton.target = self;
        _rectButton.action = @selector((rectButtonClick:));
    }
    
    return _rectButton;
}

- (NSButton *)ellipseButton {
    if (!_ellipseButton) {
        _ellipseButton = [[NSButton alloc] init];
        _ellipseButton.title = @"椭圆";
        _ellipseButton.target = self;
        _ellipseButton.action = @selector(ellipseButtonClick:);
    }
    
    return _ellipseButton;
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

- (NSButton *)textButton {
    if (!_textButton) {
        _textButton = [[NSButton alloc] init];
        _textButton.title = @"文本";
        _textButton.target = self;
        _textButton.action = @selector(textButtonClick:);
    }
    
    return _textButton;
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
