//
//  CGTMainViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/4.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTMainViewController.h"
#import "CGTMainModelLayer.h"

@interface CGTMainViewController ()<NSComboBoxDelegate, NSComboBoxDataSource>

@property (nonatomic, strong) NSTextField *titleLabel;
@property (nonatomic, strong) NSComboBox *filePathBox;
@property (nonatomic, strong) NSButton *selectButton;

@property (nonatomic, strong) CGTMainModelLayer *model;


@property (nonatomic, strong) NSButton *updateButton;

@property (nonatomic, strong) NSButton *tableViewButton;
@property (nonatomic, strong) NSButton *collectionViewButton;
@property (nonatomic, strong) NSButton *deviceTestButton;

@property (nonatomic, strong) NSButton *openglButton;
@property (strong, nonatomic) NSButton *mouseButton;


@property (nonatomic, strong) NSWindowController *tableWindowCol;
@property (nonatomic, strong) NSWindowController *collectionWindowCol;
@property (nonatomic, strong) NSWindowController *deviceTestWindowCol;
@property (strong, nonatomic) NSWindowController *openglWindowCol;
@property (strong, nonatomic) NSWindowController *mouseEventWindowCol;

@end

@implementation CGTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
	
	self.view.wantsLayer = YES;
	self.view.layer.backgroundColor = [NSColor colorWithWhite:0.3 alpha:1].CGColor;

	[self.view addSubview:self.titleLabel];
	[self.view addSubview:self.filePathBox];
	[self.view addSubview:self.selectButton];
	[self.view addSubview:self.updateButton];
	[self.view addSubview:self.tableViewButton];
	[self.view addSubview:self.collectionViewButton];
    [self.view addSubview:self.deviceTestButton];
    [self.view addSubview:self.openglButton];
    [self.view addSubview:self.mouseButton];
	
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
	[self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.titleLabel);
		make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
	}];
	[self.tableViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.titleLabel);
		make.top.equalTo(self.updateButton.mas_bottom).offset(20);
	}];
	[self.collectionViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.tableViewButton.mas_right).offset(12);
		make.top.equalTo(self.tableViewButton);
	}];
    [self.deviceTestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.tableViewButton.mas_bottom).offset(20);
    }];
    [self.openglButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.deviceTestButton.mas_bottom).offset(20);
    }];
    [self.mouseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.openglButton.mas_bottom).offset(20);
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

//	NSString * lastDestinationFileName = [cachePath stringByAppendingPathComponent:@"iOS架构概述.key"];

//	[CGTCmdTool cmd:[NSString stringWithFormat:@"cd %@; open CodeGenerationTool.dmg", cachePath]];

//	[self downloadDmgFileFromTargetUrl:@"http://127.0.0.1:8902/" destinationFileNamePath:lastDestinationFileName WithProgress:^(CGFloat progress) {
//
//	} doneCallback:^{
//		[CGTCmdTool cmd:[NSString stringWithFormat:@"cd %@; open CodeGenerationTool.app", cachePath]];
//	} errorCallback:^(NSString *errorDomine, NSInteger errorCode) {
//
//	}];
}

//- (void)downloadDmgFileFromTargetUrl:(NSString *)targetUrl destinationFileNamePath:(NSString *)path WithProgress:(void(^)(CGFloat progress))progressCallback doneCallback:(void(^)(void))doneCallback errorCallback:(void(^)(NSString * errorDomine, NSInteger errorCode))errorCallback {
//
//	AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];;
//
//	NSURLRequest * request = [NSURLRequest requestWithURL: [NSURL URLWithString:targetUrl]];
//	NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//		NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
//		progressCallback(downloadProgress.fractionCompleted);
//	} destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//		return [NSURL fileURLWithPath:path];
//	} completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//		if (!error) {
//			if (doneCallback) {
//				doneCallback();
//			}
//		} else {
//			if (errorCallback) {
//				errorCallback(error.domain, error.code);
//			}
//		}
//	}];
//	[downTask resume];
//}

- (void)showTableView:(NSButton *)button {
	NSWindowController *windowCol = [self windowColMakingFromWindowColName:@"CGTDDTableWindowController"];
	if (windowCol == nil) {
		NSLog(@"不存在 CGTDDTableWindowController");
		return;
	}
	// 先关闭原有的window
	[self.tableWindowCol.window close];
	self.tableWindowCol = windowCol;
	[self.tableWindowCol.window makeKeyAndOrderFront:nil];
}

- (void)showCollectionView:(NSButton *)button {
	NSWindowController *windowCol = [self windowColMakingFromWindowColName:@"CGTDDCollectionWindowController"];
	if (windowCol == nil) {
		NSLog(@"不存在 CGTDDCollectionWindowController");
		return;
	}
	// 先关闭原有的window
	[self.collectionWindowCol.window close];
	self.collectionWindowCol = windowCol;
	[self.collectionWindowCol.window makeKeyAndOrderFront:nil];
}

- (void)showDeviceTestView:(NSButton *)button {
    NSWindowController *windowCol = [self windowColMakingFromWindowColName:@"CGTDeviceTestWindowController"];
    if (windowCol == nil) {
        NSLog(@"不存在 CGTDeviceTestWindowController");
        return;
    }
    [self.deviceTestWindowCol.window close];
    self.deviceTestWindowCol = windowCol;
    [self.deviceTestWindowCol.window makeKeyAndOrderFront:nil];
}

- (void)showOpenglDemo:(NSButton *)button {
    NSWindowController *windowCol = [self windowColMakingFromWindowColName:@"CGTOpenglWindowController"];
    if (windowCol == nil) {
        NSLog(@"不存在 CGTOpenglWindowController");
        return;
    }
    [self.openglWindowCol.window close];
    self.openglWindowCol = windowCol;
    [self.openglWindowCol.window makeKeyAndOrderFront:nil];
}

- (void)showMouseEventView:(NSButton *)button {
    NSWindowController *windowCol = [self windowColMakingFromWindowColName:@"CGTMouseEventWindowController"];
    if (windowCol == nil) {
        NSLog(@"不存在 CGTMouseEventWindowController");
    }
    [self.mouseEventWindowCol.window close];
    self.mouseEventWindowCol = windowCol;
    [self.mouseEventWindowCol.window makeKeyAndOrderFront:nil];
}

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

#pragma mark - setter && getter

- (NSTextField *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [NSTextField labelWithString:@"指定文件生成地址:"];
		_titleLabel.bezelStyle = NSTextFieldRoundedBezel;
		_titleLabel.bezeled = YES;
		_titleLabel.textColor = NSColorFromRGB(0xFFFFFF);
	}
	
	return _titleLabel;
}

- (NSComboBox *)filePathBox {
	if (!_filePathBox) {
		_filePathBox = [[NSComboBox alloc] init];
		_filePathBox.bezelStyle = NSTextFieldRoundedBezel;
		_filePathBox.bezeled = YES;
		_filePathBox.textColor = NSColorFromRGB(0xFFFFFF);
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
		_selectButton.contentTintColor = NSColorFromRGB(0x000000);
	}
	
	return _selectButton;
}

- (NSButton *)updateButton {
	if (!_updateButton) {
		_updateButton = [NSButton buttonWithTitle:@"更新" target:self action:@selector(update:)];
		_updateButton.contentTintColor = NSColorFromRGB(0x000000);
	}
	
	return _updateButton;
}

- (CGTMainModelLayer *)model {
	if (!_model) {
		_model = [[CGTMainModelLayer alloc] init];
	}
	
	return _model;
}

- (NSButton *)tableViewButton {
	if (!_tableViewButton) {
		_tableViewButton = [NSButton buttonWithTitle:@"列表" target:self action:@selector(showTableView:)];
	}
	
	return _tableViewButton;
}

- (NSButton *)collectionViewButton {
	if (!_collectionViewButton) {
		_collectionViewButton = [NSButton buttonWithTitle:@"网格" target:self action:@selector(showCollectionView:)];
	}
	
	return _collectionViewButton;
}

- (NSButton *)deviceTestButton {
    if (!_deviceTestButton) {
        _deviceTestButton = [NSButton buttonWithTitle:@"设备检测" target:self action:@selector(showDeviceTestView:)];
    }
    
    return _deviceTestButton;
}

- (NSButton *)openglButton {
    if (!_openglButton) {
        _openglButton = [NSButton buttonWithTitle:@"opengl" target:self action:@selector(showOpenglDemo:)];
    }
    
    return _openglButton;
}

- (NSButton *)mouseButton {
    if (!_mouseButton) {
        _mouseButton = [NSButton buttonWithTitle:@"mouseEvent" target:self action:@selector(showMouseEventView:)];
    }
    
    return _mouseButton;
}

@end
