//
//  CGTMouseEventViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/10/3.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTMouseEventViewController.h"

@interface CGTMouseEventViewController ()

@property (nonatomic, strong) NSButton *dragButton;

@property (assign) BOOL isDrag;

@property (assign) NSPoint previousPoint;
@property (assign) NSPoint currentPoint;


@end

@implementation CGTMouseEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    
    [self.view addSubview:self.dragButton];
    self.dragButton.frame = NSMakeRect(10, 10, 100, 50);
//    self.dragButton.enabled = NO;
    
    self.dragButton.ignoresMultiClick = YES;
}

- (void)mouseDown:(NSEvent *)event {
    _previousPoint = [self.view convertPoint:[event locationInWindow] fromView:nil];
    
    _isDrag = NO;
    CGRect dragFrame = self.dragButton.frame;
    if (CGRectContainsPoint(dragFrame, _previousPoint)) {
        _isDrag = YES;
        
    }
}

- (void)mouseDragged:(NSEvent *)event {
    
    _currentPoint = [self.view convertPoint:[event locationInWindow] fromView:nil];
    
    if (_isDrag) {
        CGRect dragFrame = self.dragButton.frame;
        dragFrame.origin.x += _currentPoint.x - _previousPoint.x;
        dragFrame.origin.y += _currentPoint.y - _previousPoint.y;
        self.dragButton.frame = dragFrame;
        _previousPoint = _currentPoint;
    }
}

- (void)mouseUp:(NSEvent *)event {
    if (_isDrag) {
        _isDrag = NO;
    }
}

- (void)dragButtonClick:(NSButton *)button {
    
}

- (NSButton *)dragButton {
    if (!_dragButton) {
        _dragButton = [NSButton buttonWithTitle:@"drag" target:self action:@selector(dragButtonClick:)];
    }
    
    return _dragButton;
}

@end
