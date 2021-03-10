//
//  CGTCommonDemoViewController.m
//  CodeGenerationTool
//
//  Created by mac on 2020/10/23.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTCommonDemoViewController.h"
#import "CGTProcessRateTextField.h"
#import "CGTProcessRateView.h"

@interface CGTCommonDemoViewController ()

@property (strong) CGTProcessRateView *rateView;

@property (strong) NSWindowController *testWindow;

@end

@implementation CGTCommonDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    CGTProcessRateTextField *tf = [[CGTProcessRateTextField alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    
    [self.view addSubview:tf];
    
    
    CGTProcessRateView *view = [[CGTProcessRateView alloc] initWithFrame:CGRectMake(200, 100, 50, 50)];
    
    [self.view addSubview:view];
    
    self.rateView = view;
    
    
    NSButton *button = [NSButton buttonWithTitle:@"111" target:self action:@selector(updateProcess:)];
    button.frame = CGRectMake(300, 100, 30, 30);
    [self.view addSubview:button];
}

- (void)updateProcess:(NSButton *)button {
    [self.rateView updateProcess:30.];
    
    
    self.testWindow = [self windowColMakingFromWindowColName:@"CGTTestModalWindowController"];
    [NSApp runModalForWindow:self.testWindow.window];

}

@end
