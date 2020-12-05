//
//  CGTDDCollectionViewItem.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/10/3.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTDDCollectionViewItem.h"

@interface CGTDDCollectionViewItem ()

@property (strong, nonatomic) NSTextField *nameTextField;

@end

@implementation CGTDDCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view addSubview:self.nameTextField];
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.top.left.equalTo(@20);
    }];
}

- (void)loadName:(NSString *)name {
    self.nameTextField.stringValue = name;
}

#pragma mark lazy load

- (NSTextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[NSTextField alloc] init];
    }
    
    return _nameTextField;
}

@end
