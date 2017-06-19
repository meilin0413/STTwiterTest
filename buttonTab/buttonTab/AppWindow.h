//
//  AppWindow.h
//  buttonTab
//
//  Created by 楚江 王 on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppWindow : NSWindow{
    CGPoint initialLocation;
}
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSWindow *window;

@end
