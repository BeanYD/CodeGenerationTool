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

@interface CGTDeviceTestViewController ()

@property (nonatomic, strong) NSButton *startButton;
@property (nonatomic, strong) NSButton *stopButton;

@end

@implementation CGTDeviceTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
//    [self testMirophone];
    
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-40);
    }];
    
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(40);
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

@end


