//
//  CGTCustomTableHeaderCell.m
//  Training
//
//  Created by mac on 2020/10/23.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import "CGTCustomTableHeaderCell.h"

@implementation CGTCustomTableHeaderCell

- (instancetype)initTextCell:(NSString *)string {
    if (self = [super initTextCell:string]) {
        
        // TODO: text的文字样式修改为传入的方式
        self.textColor = [NSColor colorWithRed:120./256 green:123./256 blue:128./256 alpha:1.f];
        self.font = [NSFont fontWithName:@"PingFang SC" size:12.f];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.textColor = [NSColor whiteColor];
        self.font = [NSFont fontWithName:@"PingFang SC" size:12.f];
    }
    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    
    [self drawWithFrame:cellFrame inView:controlView needGrid:NO highlighted:NO];
}

/**
 * grid:是否需要网格
 * isHighlighted:是否需要高亮
 * 方法描述：修改headerCell的背景色
 * TODO: 目前写死，可考虑传入修改
 */
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView needGrid:(BOOL)grid highlighted:(BOOL)isHighlighted {
    CGRect cfillRect, cborderRect;
    
    CGRectDivide(cellFrame, &cborderRect, &cfillRect, 1.0, CGRectMaxYEdge);
    NSRect fillRect = NSMakeRect(cfillRect.origin.x, cfillRect.origin.y - (grid ? 0 : 1), cfillRect.size.width, cfillRect.size.height + (grid ? 0 : 2));
    [[NSColor colorWithRed:48./256 green:50./256 blue:56./256 alpha:1.] set];
    NSRectFill(fillRect);
    
    [[NSGraphicsContext currentContext] setShouldAntialias:YES];
    
    //set highlight behavior
    if (isHighlighted)
    {
        [[NSColor colorWithDeviceWhite:0.0 alpha:0.1] set];
        // macOS < 10.12 : NSCompositeSourceOver macOS > 10.12 : NSCompositingOperationSourceOver
        NSRectFillUsingOperation(fillRect, NSCompositingOperationSourceOver);
    }
    
    // 边框线重绘
    if (grid) {
        NSPoint ptStart, ptEnd;
        NSBezierPath *path = [NSBezierPath bezierPath];
        ptStart.x = fillRect.origin.x + fillRect.size.width - 1;
        ptStart.y = fillRect.origin.y;

        ptEnd.x = fillRect.origin.x + fillRect.size.width - 1;
        ptEnd.y = fillRect.origin.y + fillRect.size.height;

        [path moveToPoint:ptStart];
        [path lineToPoint:ptEnd];

        ptStart.x = cellFrame.origin.x;
        ptStart.y = cellFrame.origin.y + cellFrame.size.height;
        ptEnd.x = cellFrame.origin.x + cellFrame.size.width;
        ptEnd.y = cellFrame.origin.y + cellFrame.size.height;

        [path moveToPoint:ptStart];
        [path lineToPoint:ptEnd];

        ptStart.x = fillRect.origin.x;
        ptStart.y = fillRect.origin.y;
        ptEnd.x = fillRect.origin.x + fillRect.size.width;
        ptEnd.y = fillRect.origin.y;

        [path moveToPoint:ptStart];
        [path lineToPoint:ptEnd];

        [[NSColor whiteColor] set];
        [path stroke];
    }
    
    [self drawInteriorWithFrame:fillRect inView:controlView];
}

/**
 * 重写 - (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView; 方法，修改title文字的位置
 * 目前是向右偏移30
 */
 
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    CGRect titleRect = [self titleRectForBounds:cellFrame];
        
    titleRect.origin.x = titleRect.origin.x + 30;
    [self.attributedStringValue drawInRect:titleRect];
}

@end
