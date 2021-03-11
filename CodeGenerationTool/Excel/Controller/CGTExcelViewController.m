//
//  CGTExcelViewController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/3/5.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTExcelViewController.h"
#import "CGTExcelModel.h"

@interface CGTExcelViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSButton *importButton;
@property (nonatomic, strong) NSButton *exportButton;

@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *sheetButtons;
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
            
            NSDictionary *sheetInfo = [CGTExcelModel readSheetInfosFromPath:path];
            
            for (int i = 0; i < sheetInfo.allKeys.count; i++) {
                NSString *sheetTitle = sheetInfo.allKeys[i];
                NSButton *sheetBtn = [[NSButton alloc] init];
                sheetBtn.title = sheetTitle;
                sheetBtn.target = self;
                sheetBtn.tag = 100 + i;
                sheetBtn.action = @selector(sheetBtnClick:);
                [self.view addSubview:sheetBtn];
                [self.sheetButtons addObject:sheetBtn];
                [sheetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view).offset(100);
                    make.top.equalTo(self.importButton.mas_bottom).offset(20 * i);
                }];
                
            }
        }
        
    }];
}

- (void)exportButtonClick:(NSButton *)button {
    
}

- (void)sheetBtnClick:(NSButton *)button {
    
}

#pragma mark - NSTableViewDataSource && NSTableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.dataArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if (!cellView) {
        cellView = [[NSTableCellView alloc] init];
    }
    NSTextField *textField = [[NSTextField alloc] init];
    textField.editable = NO;
    textField.usesSingleLineMode = YES;
    textField.drawsBackground = YES;
    textField.backgroundColor = [NSColor clearColor];
    textField.textColor = [NSColor blackColor];
    textField.font = [NSFont systemFontOfSize:12.f];
    [cellView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cellView);
    }];
    
    textField.stringValue = self.dataArray[row];
    
    return cellView;
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

- (NSScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[NSScrollView alloc] init];
    }
    
    return _scrollView;
}

- (NSTableView *)tableView {
    if (!_tableView) {
        _tableView = [[NSTableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

@end
