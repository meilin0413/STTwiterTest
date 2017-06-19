//
//  ButtonStyle.m
//  ButtonHover
//
//  Created by 楚江 王 on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ButtonStyle.h"

@implementation ButtonStyle




-(void)updateTrackingAreas{
    [super updateTrackingAreas];
    NSTrackingAreaOptions option=NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    trackingArea =[[NSTrackingArea alloc] initWithRect:NSZeroRect options:option owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}



-(void)mouseEntered:(NSEvent *)theEvent{    
    switch (self.tag) {
        case 2:
            [self setImage:[NSImage imageNamed:@"closeHover.png"]];
            break;
        default:
            break;
    } 
}
-(void)mouseExited:(NSEvent *)theEvent{
    switch (self.tag) {
        case 2:
            [self setImage:[NSImage imageNamed:@"close.png"]];
            break;
        default:
            break;
    }
}
-(void)mouseDown:(NSEvent *)theEvent{
    switch (self.tag) {
        case 2:
            [self setImage:[NSImage imageNamed:@"closeDown.png"]];
            break;
        default:
            break;
    }
}
-(void)mouseUp:(NSEvent *)theEvent{
    switch (self.tag) {
        case 2:
            [self setImage:[NSImage imageNamed:@"close.png"]];
            break;
        default:
            break;
    }
    
}
@end
