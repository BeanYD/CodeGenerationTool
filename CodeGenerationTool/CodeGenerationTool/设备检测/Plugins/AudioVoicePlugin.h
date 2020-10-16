//
//  AudioVoicePlugin.h
//  CodeGenerationTool
//
//  Created by mac on 2020/10/15.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 获取默认设备的音量
float GetDefaultOutputDeviceVolume(void);

@interface AudioVoicePlugin : NSObject

@end

NS_ASSUME_NONNULL_END
