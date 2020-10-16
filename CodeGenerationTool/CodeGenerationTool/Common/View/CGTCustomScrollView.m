//
//  DetectionScrollView.m
//  Training
//
//  Created by mac on 2020/10/16.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import "CGTCustomScrollView.h"

@implementation CGTCustomScrollView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    _borderColor = [NSColor whiteColor];
}

- (BOOL)wantsUpdateLayer {
    return YES;
}

- (void)updateLayer {
    //changed to the width or height of a single source pixel centered at the specified location.
    self.layer.contentsCenter = CGRectMake(0.5, 0.5, 0, 0);
    //setImage
    self.layer.borderWidth = 1.;
    self.layer.borderColor = _borderColor.CGColor;
}

@end
