//
//  ImageView.m
//  STTwitterDemo
//
//  Created by Lily li on 2017/6/16.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView

- (void)awakeFromNib{
    
    [[self window] setAcceptsMouseMovedEvents:YES];
    [[self window] makeFirstResponder:self];
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}
- (void)mouseEntered:(NSEvent *)event
{
    NSLog(@"hohoga");
    button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 25, 25)];
    NSImage *image = [NSImage imageNamed:@"dowload"];
    [button setImage:image];
    [button setImageScaling:NSImageScaleProportionallyDown];
    [button setBordered:NO];
    
    [self addSubview:button];
}
- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:(NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways) owner:self userInfo:nil];
}
- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    NSTrackingAreaOptions option=NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:option owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    
}
- (BOOL)acceptsFirstResponder
{
    return YES;
}
- (void)mouseExited:(NSEvent *)event
{
    [button setHidden:YES];
}
@end
