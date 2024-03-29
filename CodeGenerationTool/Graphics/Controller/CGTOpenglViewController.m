//
//  CGTOpenglViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/10/2.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTOpenglViewController.h"
#import "CGTFileModelLayer.h"

@interface CGTOpenglViewController ()<NSComboBoxDelegate, NSComboBoxDataSource>

@property (nonatomic, strong) CGTFileModelLayer *model;

@property (nonatomic, strong) NSTextField *titleLabel;
@property (nonatomic, strong) NSComboBox *filePathBox;
@property (nonatomic, strong) NSButton *selectButton;

@end

@implementation CGTOpenglViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.filePathBox];
    [self.view addSubview:self.selectButton];
    
    [self layoutSubViews];
}

- (void)layoutSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.view).offset(40);
    }];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.right.equalTo(self.view).offset(-40);
    }];
    [self.filePathBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.top.equalTo(self.titleLabel);
        make.right.equalTo(self.selectButton.mas_left);
    }];
    
}

#pragma mark - button action
- (void)selectPath:(NSButton *)button {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canCreateDirectories = YES;
    panel.canChooseFiles = NO;
    panel.canChooseDirectories = YES;
    panel.allowsMultipleSelection = NO;
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            if (panel.URLs.count > 0) {
                self.filePathBox.stringValue = [panel.URLs[0] relativePath];
                [self.model saveNewFilePath:self.filePathBox.stringValue];
            }
            
        }
    }];
}

- (void)update:(NSButton *)button {
    NSString * libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString * cachePath = [libraryDir stringByAppendingPathComponent:@"Caches"];
    NSString * lastDestinationFileName = [cachePath stringByAppendingPathComponent:@"CodeGenerationTool.app"];
    [CGTCmdTool cmd:[NSString stringWithFormat:@"cd %@; open CodeGenerationTool.app", cachePath]];

//    NSString * lastDestinationFileName = [cachePath stringByAppendingPathComponent:@"iOS架构概述.key"];

//    [CGTCmdTool cmd:[NSString stringWithFormat:@"cd %@; open CodeGenerationTool.dmg", cachePath]];

//    [self downloadDmgFileFromTargetUrl:@"http://127.0.0.1:8902/" destinationFileNamePath:lastDestinationFileName WithProgress:^(CGFloat progress) {
//
//    } doneCallback:^{
//        [CGTCmdTool cmd:[NSString stringWithFormat:@"cd %@; open CodeGenerationTool.app", cachePath]];
//    } errorCallback:^(NSString *errorDomine, NSInteger errorCode) {
//
//    }];
}

//- (void)downloadDmgFileFromTargetUrl:(NSString *)targetUrl destinationFileNamePath:(NSString *)path WithProgress:(void(^)(CGFloat progress))progressCallback doneCallback:(void(^)(void))doneCallback errorCallback:(void(^)(NSString * errorDomine, NSInteger errorCode))errorCallback {
//
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];;
//
//    NSURLRequest * request = [NSURLRequest requestWithURL: [NSURL URLWithString:targetUrl]];
//    NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
//        progressCallback(downloadProgress.fractionCompleted);
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        return [NSURL fileURLWithPath:path];
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        if (!error) {
//            if (doneCallback) {
//                doneCallback();
//            }
//        } else {
//            if (errorCallback) {
//                errorCallback(error.domain, error.code);
//            }
//        }
//    }];
//    [downTask resume];
//}

#pragma mark - NSComboBoxDataSource
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
    return [self.model readAllFilePaths].count;
}
- (nullable id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index {
    NSString *filePath = [self.model readAllFilePaths][index];
    return filePath;
}

#pragma mark - NSComboBoxDelegate
- (void)comboBoxWillPopUp:(NSNotification *)notification {
    
}
- (void)comboBoxWillDismiss:(NSNotification *)notification {
    
}
- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    
}
- (void)comboBoxSelectionIsChanging:(NSNotification *)notification {
    
}

#pragma mark - getter

- (CGTFileModelLayer *)model {
    if (!_model) {
        _model = [[CGTFileModelLayer alloc] init];
    }
    
    return _model;
}

- (NSTextField *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [NSTextField labelWithString:@"指定文件生成地址:"];
        _titleLabel.bezelStyle = NSTextFieldRoundedBezel;
        _titleLabel.bezeled = YES;
        _titleLabel.textColor = NSColorFromRGB(0x0);
    }
    
    return _titleLabel;
}

- (NSComboBox *)filePathBox {
    if (!_filePathBox) {
        _filePathBox = [[NSComboBox alloc] init];
        _filePathBox.bezelStyle = NSTextFieldRoundedBezel;
        _filePathBox.bezeled = YES;
        _filePathBox.textColor = NSColorFromRGB(0x0);
        _filePathBox.usesDataSource = YES;
        _filePathBox.delegate = self;
        _filePathBox.dataSource = self;
        _filePathBox.stringValue = [self.model readFirstFilePath];
    }
    
    return _filePathBox;
}

- (NSButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [NSButton buttonWithTitle:@"选择目录" target:self action:@selector(selectPath:)];
        _selectButton.contentTintColor = NSColorFromRGB(0x0);
    }
    
    return _selectButton;
}

@end
