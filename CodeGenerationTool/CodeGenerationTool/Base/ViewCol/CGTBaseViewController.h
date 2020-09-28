//
//  CGTBaseViewController.h
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/4.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGTBaseViewController : NSViewController

- (instancetype)initWithFrame:(CGRect)frame;

- (NSWindowController *)windowColMakingFromWindowColName:(NSString *)colName;

@end

NS_ASSUME_NONNULL_END
