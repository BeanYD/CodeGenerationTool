//
//  CGTIOBlueToothWindowController.m
//  CodeGenerationTool
//
//  Created by mac on 2020/10/20.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTIOBlueToothWindowController.h"
#import <IOBluetooth/IOBluetooth.h>

@interface CGTIOBlueToothWindowController () <IOBluetoothDeviceInquiryDelegate>

@property (nonatomic, strong) IOBluetoothDeviceInquiry *inquiry;

@property (nonatomic, strong) NSMutableArray *deviceArray;

@end

@implementation CGTIOBlueToothWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [self startInquiry];
}

- (IOReturn)stopInquiry {
    IOReturn ret = kIOReturnNotOpen;
    if (self.inquiry) {
        ret = [self.inquiry stop];
        self.inquiry = nil;
        
        [self.deviceArray removeAllObjects];
    }
    
    return ret;
}

- (IOReturn)startInquiry {
    IOReturn status;
    
    [self stopInquiry];
    
    self.inquiry = [IOBluetoothDeviceInquiry inquiryWithDelegate:self];
    status = [self.inquiry start];
    
    if (status == kIOReturnSuccess) {
        
    }
    
    return  status;
}

#pragma mark - IOBluetoothDeviceInquiryDelegate

- (void)deviceInquiryStarted:(IOBluetoothDeviceInquiry*)sender {
    NSLog(@"deviceInquiryStarted");
}

- (void)deviceInquiryDeviceFound:(IOBluetoothDeviceInquiry*)sender device:(IOBluetoothDevice*)device {
    NSLog(@"Found %@ device...", device.name);
    
    [self.deviceArray addObject:device];
}

- (void)deviceInquiryUpdatingDeviceNamesStarted:(IOBluetoothDeviceInquiry*)sender devicesRemaining:(uint32_t)devicesRemaining {
    NSLog(@"Refreshing %d device names...", devicesRemaining);
}

- (void)deviceInquiryDeviceNameUpdated:(IOBluetoothDeviceInquiry*)sender device:(IOBluetoothDevice*)device devicesRemaining:(uint32_t)devicesRemaining {
    NSLog(@"Refreshing %d device names...", devicesRemaining);
}

- (void)deviceInquiryComplete:(IOBluetoothDeviceInquiry*)sender error:(IOReturn)error aborted:(BOOL)aborted {
    if (aborted) {
        NSLog(@"Idle (inquiry stopped).");
    } else {
        NSLog(@"Idle (inquiry complete).");
    }
}

#pragma mark - Lazy load
- (NSMutableArray *)deviceArray {
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray array];
    }
    
    return _deviceArray;
}

@end
