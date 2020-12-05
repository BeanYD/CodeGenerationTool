//
//  DeviceMediaManager.m
//  Training
//
//  Created by mac on 2020/10/20.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import "DeviceMediaManager.h"
#import <AVFoundation/AVFoundation.h>

@interface DeviceMediaManager () <AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong) AVCaptureSession *avSession;
@property (strong) AVCaptureVideoDataOutput *videoOutput;

@end

@implementation DeviceMediaManager

- (instancetype)init {
    if (self = [super init]) {
        [self initializeAvSession];
    }
    
    return self;
}

- (AVCaptureSession *)initializeAvSession {
    if (!_avSession) {
        // init AVCaptureSession
        AVCaptureSession *avSession = [[AVCaptureSession alloc] init];
        avSession.sessionPreset = AVCaptureSessionPreset320x240;
        // 设备对象 (audio)
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        // 输入流
        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
        // 输出流
        AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [audioOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        // 添加输入输出流
        if ([avSession canAddInput:audioInput]) {
            [avSession addInput:audioInput];
        }
        if ([avSession canAddOutput:audioOutput]) {
            [avSession addOutput:audioOutput];
        }
        
        // 设备对象 (video)
        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // 输入流
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        // 输出流
        AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [videoOutput setAlwaysDiscardsLateVideoFrames:NO];
    //        [self.videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        
        // 帧的大小在这里设置才有效
        videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                          [NSNumber numberWithInt: 640], (id)kCVPixelBufferWidthKey,
                                          [NSNumber numberWithInt: 480], (id)kCVPixelBufferHeightKey,
                                          nil];
        /*
                                                                            调用次数       CVBytesPerRow
         kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;      （420f）                       1924
         kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange ;      420v                        1924            964
         kCVPixelFormatType_422YpCbCr8_yuvs;                    yuvs            30          2560
         kCVPixelFormatType_422YpCbCr8                          2vuy            30          2560
         */
        [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        self.videoOutput = videoOutput;
        
        // 获取当前设备支持的像素格式
    //        NSLog(@"-- videoDevice.formats = %@", videoDevice.formats);
        
        //根据设备输出获得连接
        AVCaptureConnection *connection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
        [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        
        // 摄像头翻转
//        if (connection.isVideoMirroringSupported) {
//            connection.videoMirrored = YES;
//        }
        
        if ([avSession canAddInput:videoInput]) {
            [avSession addInput:videoInput];
        }
        if ([avSession canAddOutput:videoOutput]) {
            [avSession addOutput:videoOutput];
        }
        
        _avSession = avSession;
    }
    
    return _avSession;
}

- (void)stopAvSession {
    [self.avSession stopRunning];
}

- (void)startAvSession {
    [self.avSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (output == self.videoOutput) {
        
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

        if (self.completion) {
            CIImage *ciImage = [CIImage imageWithCVImageBuffer:imageBuffer];
            CIContext* context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
            CGRect rect = CGRectMake(0, 0, 640, 480);
            CGImageRef videoImage = [context createCGImage:ciImage fromRect:rect];
            NSImage *image = [[NSImage alloc] initWithCGImage:videoImage size:rect.size];
            CGImageRelease(videoImage);
            self.imgCompletion(image);
            return;
        }
                
        CVPixelBufferLockBaseAddress(imageBuffer,0);

        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
        // Get the data size for contiguous planes of the pixel buffer.
        size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
        if( CVPixelBufferIsPlanar(imageBuffer) ){
    //        void* baseAddress1 = baseAddress;
            baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    //        bufferSize += ((size_t)baseAddress - (size_t)baseAddress1);
        }

        struct DeviceVideoParam param;
        memset(&param, 0, sizeof(param));
        param.width = width;
        param.height = height;
        param.bytesPerRow = bytesPerRow;
        param.baseAddress = baseAddress;
        param.bufferSize = bufferSize;
        if (self.completion) {
            self.completion(param);
        }
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
}

@end
