//
//  CGTCreateWindowController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/12/5.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTCreateWindowController.h"

@interface CGTCreateWindowController ()

@property (nonatomic, strong) NSTextField *nameTextField;
@property (nonatomic, strong) NSTextField *winColTextField;
@property (nonatomic, strong) NSButton *sureButton;

@end

@implementation CGTCreateWindowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.winColTextField];
    [self.view addSubview:self.sureButton];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@100);
        make.top.equalTo(self.view).offset(20);
    }];
    
    [self.winColTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextField.mas_bottom).offset(10);
        make.width.equalTo(self.nameTextField);
        make.centerX.equalTo(self.view);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.winColTextField.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
    }];
    
}

- (void)sureButtonClick:(NSButton *)button {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.nameTextField.stringValue forKey:@"name"];
    [dict setValue:self.winColTextField.stringValue forKey:@"winCol"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddModuleNotify" object:nil userInfo:dict];
    
    [self dismissController:nil];
}

#pragma mark - Getter
- (NSTextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[NSTextField alloc] init];
    }
    
    return _nameTextField;
}

- (NSTextField *)winColTextField {
    if (!_winColTextField) {
        _winColTextField = [[NSTextField alloc] init];
    }
    
    return _winColTextField;
}

- (NSButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [NSButton buttonWithTitle:@"确定" target:self action:@selector(sureButtonClick:)];
    }
    
    return _sureButton;
}

@end
