//
//  ButtonStyle.m
//  buttonTab
//
//  Created by 楚江 王 on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ButtonStyle.h"
#import "AppWindow.h"

@implementation ButtonStyle

-(void)updateTrackingAreas{
    [super updateTrackingAreas];
    NSTrackingAreaOptions option=NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    trackingArea =[[NSTrackingArea alloc] initWithRect:NSZeroRect options:option owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}
-(void)mouseDown:(NSEvent *)theEvent{
    switch (self.tag) {
        case 1:
            [self setImage:[NSImage imageNamed:@"menuBtnDown.png"]];
            break;
        case 2:
            [self setImage:[NSImage imageNamed:@"menuBtnDown.png"]];
            break;
        case 3:
            [self setImage:[NSImage imageNamed:@"menuBtnDown.png"]];
            break;
        default:
            break;
    }
}
-(void)mouseUp:(NSEvent *)theEvent{
    NSButton *button = (NSButton *)self; 
    WebView *webView = [(AppWindow *)self.superview.window webView];
    for (int i = 1; i <= 3; i++) { 
        if (self.tag != i) { 
            button =[[self.window contentView] viewWithTag:i]; 
            [button setImage:[NSImage imageNamed:@"menuBtn.png"]]; 
        }else {
            [self setImage:[NSImage imageNamed:@"menuBtnHover.png"]];
            
            
            NSString *urlString;
            if (self.tag==1) {
                urlString = @"http://www.baidu.com";
            }
            if (self.tag==2) {
                urlString = @"http://www.google.com";
            }
            if (self.tag==3) {
                urlString = @"http://www.taobao.com";
            }
            [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]]; 
        } 
    }
}
@end
