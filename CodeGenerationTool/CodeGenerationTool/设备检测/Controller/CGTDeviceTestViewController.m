//
//  CGTDeviceTestViewController.m
//  CodeGenerationTool
//
//  Created by mac on 2020/10/14.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTDeviceTestViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlugin.h"
#import "AudioVoicePlugin.h"
#import "DeviceMediaManager.h"

@interface CGTDeviceTestViewController () 

// 录制摄像头内容
@property (nonatomic, strong) NSButton *startButton;
@property (nonatomic, strong) NSButton *stopButton;

// 蓝牙搜索设备的两种
@property (nonatomic, strong) NSButton *IOBButton;
@property (nonatomic, strong) NSButton *CBTButton;

// 展示摄像头
@property (nonatomic, strong) NSView *videoView;
@property (nonatomic, strong) NSImageView *imageView;


// window controller
@property (nonatomic, strong) NSWindowController *IOBWindowCol;
@property (nonatomic, strong) NSWindowController *CBTWindowCol;

// video
@property (nonatomic, strong) DeviceMediaManager *mediaMgr;
@property (nonatomic, strong) NSButton *startVideoButton;
@property (nonatomic, strong) NSButton *stopVideoButton;

@end

@implementation CGTDeviceTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
//    [self testMirophone];
    
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
    [self.view addSubview:self.IOBButton];
    [self.view addSubview:self.CBTButton];
    
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.startVideoButton];
    [self.view addSubview:self.stopVideoButton];
    
    [self.videoView addSubview:self.imageView];
    
    [self layoutSubviews];
    
}

- (void)layoutSubviews {
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(100);
    }];
    
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startButton.mas_right).offset(20);
        make.top.equalTo(self.startButton);
    }];
    
    [self.IOBButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startButton);
        make.top.equalTo(self.startButton.mas_bottom).offset(20);
    }];
    
    [self.CBTButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.IOBButton.mas_right).offset(20);
        make.top.equalTo(self.IOBButton);
    }];
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IOBButton.mas_bottom).offset(100);
        make.left.equalTo(self.startButton);
        make.height.equalTo(@320);
        make.width.equalTo(@240);
    }];
    
    [self.startVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoView).offset(10);
        make.left.equalTo(self.videoView.mas_right).offset(10);
    }];
    
    [self.stopVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startVideoButton.mas_bottom).offset(10);
        make.left.equalTo(self.videoView.mas_right).offset(10);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoView);
    }];
}

- (void)authorMicphoneWithResult:(void (^)(AVAuthorizationStatus status))result  API_AVAILABLE(macos(10.14)){
    if (@available(macOS 10.14, *)) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (authStatus) {
            case AVAuthorizationStatusAuthorized:
                // 获取成功
                NSLog(@"获取用户权限成功");
                result(AVAuthorizationStatusAuthorized);
                break;
            case AVAuthorizationStatusNotDetermined:
                //目前用户未允许
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (!granted) {
                        NSLog(@"用户拒绝");
                    } else {
                        NSLog(@"用户允许");
                        
                        result(AVAuthorizationStatusAuthorized);
                    }
                }];
                break;
        }
    } else {
        
    }
}

#pragma mark - button click
- (void)startRecording:(NSButton *)button {
    if (@available(macOS 10.14, *)) {
        [self authorMicphoneWithResult:^(AVAuthorizationStatus status) {
            if (status == AVAuthorizationStatusAuthorized) {
//                [[AudioPlugin sharedInstance] audioPluginStartRecord];
                
                // TODO: 输入设备的当前音量获取
//                float volume = GetDefaultOutputDeviceVolume();
//                NSLog(@"%f", volume);
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)stopRecording:(NSButton *)button {
//    [[AudioPlugin sharedInstance] audioPluginStopRecord];

}

- (void)searchIOB:(NSButton *)button {
    NSWindowController *windowCol = [[NSClassFromString(@"CGTIOBlueToothWindowController") alloc] initWithWindowNibName:@"CGTIOBlueToothWindowController"];
    self.IOBWindowCol = windowCol;
    [self.IOBWindowCol.window makeKeyAndOrderFront:nil];
}

- (void)searchCBT:(NSButton *)button {
    NSWindowController *windowCol = [[NSClassFromString(@"CGTCoreBlueToothWindowController") alloc] initWithWindowNibName:@"CGTCoreBlueToothWindowController"];
    self.CBTWindowCol = windowCol;
    [self.CBTWindowCol.window makeKeyAndOrderFront:nil];
}

- (void)startVideo:(NSButton *)button {
    [self.mediaMgr startAvSession];
    
    __weak typeof(self) weakSelf = self;
    self.mediaMgr.imgCompletion = ^(NSImage * _Nonnull image) {
        weakSelf.imageView.image = image;
    };
}

- (void)stopVideo:(NSButton *)button {
    [self.mediaMgr stopAvSession];
}

#pragma mark - lazy load

- (NSButton *)startButton {
    if (!_startButton) {
        _startButton = [NSButton buttonWithTitle:@"开始测试" target:self action:@selector(startRecording:)];
    }
    
    return _startButton;
}

- (NSButton *)stopButton {
    if (!_stopButton) {
        _stopButton = [NSButton buttonWithTitle:@"停止测试" target:self action:@selector(stopRecording:)];
    }
    
    return _stopButton;
}

- (NSButton *)IOBButton {
    if (!_IOBButton) {
        _IOBButton = [NSButton buttonWithTitle:@"IO蓝牙设备搜索" target:self action:@selector(searchIOB:)];
    }
    
    return _IOBButton;
}

- (NSButton *)CBTButton {
    if (!_CBTButton) {
        _CBTButton = [NSButton buttonWithTitle:@"CB蓝牙设备搜索" target:self action:@selector(searchCBT:)];
    }
    
    return _CBTButton;
}

- (NSView *)videoView {
    if (!_videoView) {
        _videoView = [[NSView alloc] init];
    }
    
    return _videoView;
}

- (NSButton *)startVideoButton {
    if (!_startVideoButton) {
        _startVideoButton = [NSButton buttonWithTitle:@"开启摄像头" target:self action:@selector(startVideo:)];
    }
    
    return _startVideoButton;
}

- (NSButton *)stopVideoButton {
    if (!_stopVideoButton) {
        _stopVideoButton = [NSButton buttonWithTitle:@"关闭摄像头" target:self action:@selector(stopVideo:)];
    }
    
    return _stopButton;
}

- (DeviceMediaManager *)mediaMgr {
    if (!_mediaMgr) {
        _mediaMgr = [[DeviceMediaManager alloc] init];
    }
    
    return _mediaMgr;
}

- (NSImageView *)imageView {
    if (!_imageView) {
        _imageView = [[NSImageView alloc] init];
    }
    
    return _imageView;
}

@end


