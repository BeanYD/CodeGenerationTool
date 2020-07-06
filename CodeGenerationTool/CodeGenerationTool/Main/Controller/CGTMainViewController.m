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

- (CGTMainModelLayer *)model {
	if (!_model) {
		_model = [[CGTMainModelLayer alloc] init];
	}
	
	return _model;
}

@end
