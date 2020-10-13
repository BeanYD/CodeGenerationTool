//
//  AppDelegate.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/7/4.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
		
	self.mainWindow = [CGTInvokeConfig className:@"CGTMainWindowController" invokeMethodName:@"defaultWindowCol"];
	[[self.mainWindow window] orderFront:nil];
	
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    return NSTerminateNow;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    
}
- (void)applicationWillHide:(NSNotification *)notification {
    
}
- (void)applicationDidHide:(NSNotification *)notification {
    
}
- (void)applicationWillUnhide:(NSNotification *)notification {
    
}
- (void)applicationDidUnhide:(NSNotification *)notification {
    
}
- (void)applicationWillBecomeActive:(NSNotification *)notification {
    
}
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    
}
- (void)applicationWillResignActive:(NSNotification *)notification {
    
}
- (void)applicationDidResignActive:(NSNotification *)notification {
    
}
- (void)applicationWillUpdate:(NSNotification *)notification {
    
}
- (void)applicationDidUpdate:(NSNotification *)notification {
    
}
- (void)applicationDidChangeScreenParameters:(NSNotification *)notification {
    
}
- (void)applicationDidChangeOcclusionState:(NSNotification *)notification API_AVAILABLE(macos(10.9)) {
    
}


@end
