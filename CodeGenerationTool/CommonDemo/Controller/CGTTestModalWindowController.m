//
//  CGTTestModalWindowController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/3/10.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTTestModalWindowController.h"

@interface CGTTestModalWindowController ()

@end

@implementation CGTTestModalWindowController

- (instancetype)initWithWindow:(NSWindow *)window {
    if (self = [super initWithWindow:window]) {
        self.window.title = @"测试模态";
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    
}

@end
