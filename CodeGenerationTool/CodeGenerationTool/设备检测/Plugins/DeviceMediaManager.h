//
//  DeviceMediaManager.h
//  Training
//
//  Created by mac on 2020/10/20.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct DeviceVideoParam
{
    size_t bytesPerRow;
    size_t width;
    size_t height;
    void *baseAddress;
    size_t bufferSize;
};

@interface DeviceMediaManager : NSObject


@property (copy) void (^completion)(struct DeviceVideoParam param);
@property (copy) void (^imgCompletion)(NSImage *image);

- (void)startAvSession;
- (void)stopAvSession;

@end

NS_ASSUME_NONNULL_END
