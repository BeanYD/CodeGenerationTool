//
//  OfflineView.h
//  Miniclass
//
//  Created by mac on 2020/12/18.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@interface ProgressHUD : NSView

@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) NSTextField *textLabel;
@property (nonatomic, strong) NSView *topView;

/**
 * parentView   HUD父视图
 * message      加载图标下的文案
 * topTitle         顶部提示视图，项目特定的离线加载UI
 */
+ (instancetype)HUDWithParentView:(NSView *)parentView;
+ (instancetype)HUDWithParentView:(NSView *)parentView message:(NSString *)message;
+ (instancetype)HUDWithParentView:(NSView *)parentView message:(NSString *)message topTitle:(NSString *)topTitle;

/**
 * 移除HUD
 */
- (void)hideProgressHUD;

/**
 * 窗口进行resize时需要进行同步调用，暂时需要外部调用，后续可修改为内部实现适配
 */
- (void)updateFrame;

@end

NS_ASSUME_NONNULL_END
