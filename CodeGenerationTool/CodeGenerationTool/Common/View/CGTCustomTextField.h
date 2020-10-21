//
//  CGTCustomTextField.h
//  Training
//
//  Created by mac on 2020/10/21.
//  Copyright © 2020 Gensee Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CGTCustomTextFieldDelegate <NSObject>

- (void)hyperlinkToUrl:(NSURL *)url;

@end

@interface CGTCustomTextField : NSTextField

@property (weak) id<CGTCustomTextFieldDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
