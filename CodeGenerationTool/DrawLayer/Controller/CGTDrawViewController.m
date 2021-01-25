//
//  CGTDrawViewController.m
//  CodeGenerationTool
//
//  Created by mac on 2021/1/25.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "CGTDrawViewController.h"

@interface CGTDrawViewController () <CALayerDelegate>

@end

@implementation CGTDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    CALayer *subLayer = [[CALayer alloc] init];
    
    subLayer.bounds = self.view.bounds;
    subLayer.position = CGPointMake(160, 200);
    subLayer.backgroundColor = [NSColor redColor].CGColor;
    subLayer.delegate = self;
    [self.view.layer addSublayer:subLayer];
    [subLayer setNeedsDisplay];
}

- (void)drawlayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -NSHeight(self.view.frame));
    NSImage *image = [NSImage imageNamed:@"加载"];
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CGContextDrawImage(ctx, CGRectMake(0, 0, 100, 100), imageRef);
    CGContextRestoreGState(ctx);
}

@end
