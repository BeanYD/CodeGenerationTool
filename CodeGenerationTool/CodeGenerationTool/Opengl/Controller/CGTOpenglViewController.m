//
//  CGTOpenglViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/10/2.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTOpenglViewController.h"
#import "DeviceMediaManager.h"

@interface CGTOpenglViewController ()

@property (strong, nonatomic) DeviceMediaManager *mediaManager;


@end

@implementation CGTOpenglViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark - getter

- (DeviceMediaManager *)mediaManager {
    if (!_mediaManager) {
        _mediaManager = [[DeviceMediaManager alloc] init];
    }
    
    return _mediaManager;
}

@end
