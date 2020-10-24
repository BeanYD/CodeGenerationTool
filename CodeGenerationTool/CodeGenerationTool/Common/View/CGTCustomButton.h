//
//  CustomButton.h
//  Training
//
//  Created by mac on 2020/10/16.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kTextColorKey;
extern NSString * const kFontKey;
extern NSString * const kBackgroundColorKey;
extern NSString * const kBorderColorKey;
extern NSString * const kBorderWidthKey;
extern NSString * const kCornerRadiusKey;
extern NSString * const kShadowOffsetKey;

@interface CGTCustomButton : NSButton

/**
 背景色 - 默认是APP的蓝色按钮
 */
@property (strong) NSColor *backgroundColor;

/**
 边框
 */
@property (strong) NSColor *borderColor;
@property (assign) CGFloat borderWidth;

/**
 阴影偏移量 - 如果不需要阴影请不要设置
 */
@property (assign) CGSize shadowOffset;

/**
 圆角的半径 - 默认为4
 */
@property (assign) CGFloat cornerRadius;

/**
 文本颜色
 文本位置
 */
- (void)setTextColor:(NSColor *)textColor alignment:(NSTextAlignment)alignment;

- (void)setTextString:(NSString *)textString;

/**
 设置标题 - 这只是一个快捷方法，你可以根据富文本内容设置更多自定标题

 @param title 内容
 @param textColor 颜色
 */
- (void)setTitle:(NSAttributedString *)title
       textColor:(NSColor *)textColor
            font:(NSFont *)font
       alignment:(NSTextAlignment)alignment;

/**
 * 通过传入的字典设置样式
 */
- (void)addAttributes:(NSDictionary *)attrs;

@end

NS_ASSUME_NONNULL_END
