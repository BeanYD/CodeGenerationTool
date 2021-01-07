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

+ (instancetype)HUDWithParentView:(NSView *)parentView;
+ (instancetype)HUDWithParentView:(NSView *)parentView message:(NSString *)message;
+ (instancetype)HUDWithParentView:(NSView *)parentView message:(NSString *)message topTitle:(NSString *)topTitle;
- (void)hideProgressHUD;

- (void)updateFrame;

@end

NS_ASSUME_NONNULL_END
