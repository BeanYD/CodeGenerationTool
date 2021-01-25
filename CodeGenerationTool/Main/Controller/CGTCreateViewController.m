//
//  CGTCreateWindowController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/12/5.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTCreateViewController.h"

@interface CGTCreateViewController ()

@property (nonatomic, strong) NSTextField *remindTextField;
@property (nonatomic, strong) NSTextField *nameTextField;
@property (nonatomic, strong) NSTextField *winColTextField;
@property (nonatomic, strong) NSButton *sureButton;
@property (nonatomic, strong) NSButton *cancelButton;

@end

@implementation CGTCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view addSubview:self.remindTextField];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.winColTextField];
    [self.view addSubview:self.sureButton];
    [self.view addSubview:self.cancelButton];
    
    [self.remindTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@100);
        make.top.equalTo(self.view).offset(20);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@100);
        make.top.equalTo(self.remindTextField.mas_bottom).offset(20);
    }];
    
    [self.winColTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextField.mas_bottom).offset(10);
        make.width.equalTo(self.nameTextField);
        make.centerX.equalTo(self.view);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.winColTextField.mas_bottom).offset(15);
        make.centerX.equalTo(self.view).offset(-30);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.winColTextField.mas_bottom).offset(15);
        make.centerX.equalTo(self.view).offset(30);
    }];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    
    self.remindTextField.stringValue = _titleStr;
}

- (void)sureButtonClick:(NSButton *)button {
    
    if ([self.titleStr isEqualToString:@"添加控制器"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.nameTextField.stringValue forKey:@"name"];
        [dict setValue:self.winColTextField.stringValue forKey:@"winCol"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddModuleNotify" object:nil userInfo:dict];
    } else if ([self.titleStr isEqualToString:@"删除控制器"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.nameTextField.stringValue forKey:@"name"];
        [dict setValue:self.winColTextField.stringValue forKey:@"winCol"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DelModuleNotify" object:nil userInfo:dict];
    }
    
    [self dismissController:nil];
}

- (void)cancelButtonClick:(NSButton *)button {
    [self dismissController:nil];
}

#pragma mark - Getter

- (NSTextField *)remindTextField {
    if (!_remindTextField) {
        _remindTextField = [[NSTextField alloc] init];
        _remindTextField.font = [NSFont systemFontOfSize:16.];
        _remindTextField.editable = NO;
        _remindTextField.bordered = NO;
        _remindTextField.drawsBackground = YES;
        _remindTextField.backgroundColor = [NSColor clearColor];
        _remindTextField.alignment = NSTextAlignmentCenter;
    }
    
    return _remindTextField;
}

- (NSTextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[NSTextField alloc] init];
        _nameTextField.placeholderString = @"col标题";
    }
    
    return _nameTextField;
}

- (NSTextField *)winColTextField {
    if (!_winColTextField) {
        _winColTextField = [[NSTextField alloc] init];
        _winColTextField.placeholderString = @"col类名";
    }
    
    return _winColTextField;
}

- (NSButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [NSButton buttonWithTitle:@"确定" target:self action:@selector(sureButtonClick:)];
    }
    
    return _sureButton;
}

- (NSButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [NSButton buttonWithTitle:@"取消" target:self action:@selector(cancelButtonClick:)];
    }
    
    return _cancelButton;
}

@end
