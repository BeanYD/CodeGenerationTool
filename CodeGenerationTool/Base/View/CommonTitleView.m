//
//  CommonTitleView.m
//  Training
//
//  Created by mac on 2020/10/16.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import "CommonTitleView.h"

@interface CommonTitleView()

@property (strong) NSTextField *titleLabel;

@end

@implementation CommonTitleView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        NSTextField *titleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(NSWidth(self.frame) / 4, 5, NSWidth(self.frame) / 2, 16)];
        titleLabel.editable = NO;
        titleLabel.selectable = NO;
        titleLabel.textColor = [NSColor whiteColor];
        titleLabel.font = [NSFont fontWithName:@"PingFang SC" size:12.];
        titleLabel.backgroundColor = [NSColor colorWithRed:56.0/256 green:59.0/256 blue:66.0/256 alpha:1.0];
        titleLabel.stringValue = @"";
        titleLabel.alignment = NSTextAlignmentCenter;
        [titleLabel setBordered:NO];
        titleLabel.usesSingleLineMode = YES;
        self.titleLabel = titleLabel;
        
        [self addSubview:titleLabel];
    }
    
    return self;
}

- (void)setTitleLabelString:(NSString *)string {
    self.titleLabel.stringValue = string;
}

@end
