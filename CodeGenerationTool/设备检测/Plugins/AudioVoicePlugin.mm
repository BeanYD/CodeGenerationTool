//
//  AudioVoicePlugin.m
//  CodeGenerationTool
//
//  Created by mac on 2020/10/15.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "AudioVoicePlugin.h"
#include <iostream>
#include <vector>
 
#include <CoreAudio/CoreAudio.h>
#include <AudioToolbox/AudioServices.h>
 
// 获取默认设备的device_id
// 输入设备：input true
// 输出设备：input false
AudioDeviceID GetDefaultDeviceID(bool input){
    AudioDeviceID device_id;
    AudioObjectPropertySelector selector = input ? kAudioHardwarePropertyDefaultInputDevice
                                                 : kAudioHardwarePropertyDefaultOutputDevice;
    UInt32 propsize = sizeof(AudioDeviceID);
    
    AudioObjectPropertyAddress address = {
        selector,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster};
    
    OSStatus status = AudioObjectGetPropertyData(kAudioObjectSystemObject, &address, 0, nullptr,
                               &propsize, &device_id);
    if(status != kAudioHardwareNoError){
        std::cout << "get default device id error" << std::endl;
        return 0;
    }
    return device_id;
}
 
// 获取默认设备的音量
float GetDefaultOutputDeviceVolume(void){
    auto device_id = GetDefaultDeviceID(true);
    AudioObjectPropertyAddress virtualMasterVolumeAddress = {
        kAudioHardwareServiceDeviceProperty_VirtualMasterVolume,
        kAudioDevicePropertyScopeOutput,
        kAudioObjectPropertyElementMaster
    };
    float volume;
    UInt32 propsize = sizeof(Float32);
    OSStatus status = AudioObjectGetPropertyData(device_id, &virtualMasterVolumeAddress,
                                                 0, nullptr, &propsize,&volume);
    if(status != kAudioHardwareNoError){
        std::cout << "get default device volume error" << std::endl;
        return 0;
    }
    return volume;
}
 
// 设备默认输出设备的音量
void SetDefaultOutputDeviceVolume(float volume){
    auto device_id = GetDefaultDeviceID(true);
    AudioObjectPropertyAddress virtualMasterVolumeAddress = {
        kAudioHardwareServiceDeviceProperty_VirtualMasterVolume,
        kAudioDevicePropertyScopeOutput,
        kAudioObjectPropertyElementMaster
    };
    UInt32 propsize = sizeof(Float32);
    OSStatus status = AudioObjectSetPropertyData(device_id, &virtualMasterVolumeAddress,
                                                 0, nullptr, propsize,&volume);
    if(status != kAudioHardwareNoError){
        std::cout << "set default device volume error" << std::endl;
    }
}
 
// 获取默认设备是不是设置了静音
bool GetDefaultOutputDeviceMute(){
    auto device_id = GetDefaultDeviceID(true);
    UInt32 mute;
    UInt32 propsize = sizeof(UInt32);
    AudioObjectPropertyAddress address = {
        kAudioDevicePropertyMute,
        kAudioDevicePropertyScopeOutput,
        kAudioObjectPropertyElementMaster
    };
    OSStatus status = AudioObjectGetPropertyData(device_id, &address,
                                                 0, nullptr, &propsize,&mute);
    if(status != kAudioHardwareNoError){
        std::cout << "get default device mute error" << std::endl;
        return false;
    }
    // 1 静音
    return mute == 1;
}
 
// 设置当前默认输出设备是不是为静音
// true ： 静音
// false：不是静音
void SetDefaultOutputDeviceMute(bool mute){
    auto device_id = GetDefaultDeviceID(true);
    UInt32 mute_value = mute ? 1 : 0;
    UInt32 propsize = sizeof(UInt32);
    AudioObjectPropertyAddress address = {
        kAudioDevicePropertyMute,
        kAudioDevicePropertyScopeOutput,
        kAudioObjectPropertyElementMaster
    };
    OSStatus status = AudioObjectSetPropertyData(device_id, &address,
                                                 0, nullptr, propsize,&mute_value);
    if(status != kAudioHardwareNoError){
        std::cout << "set default device mute error" << std::endl;
    }
}

@implementation AudioVoicePlugin

@end
