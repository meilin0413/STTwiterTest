//
//  AppWindow.m
//  ButtonHover
//
//  Created by 楚江 王 on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppWindow.h"

@implementation AppWindow



//---鼠标拖拽----------------------------------------------------------------
- (void)mouseDown:(NSEvent *)theEvent
{  
    
    
    NSRect  windowFrame = [self frame];
    initialLocation = [NSEvent mouseLocation];
    
    initialLocation.x -= windowFrame.origin.x;
    initialLocation.y -= windowFrame.origin.y;   
}
//-------------------------------------------------------------------------
- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint currentLocation;
    NSPoint newOrigin;
    
    NSRect  screenFrame = [[NSScreen mainScreen] frame];
    NSRect  windowFrame = [self frame];
    
    currentLocation = [NSEvent mouseLocation];
    newOrigin.x = currentLocation.x - initialLocation.x;
    newOrigin.y = currentLocation.y - initialLocation.y;
    
    // Don't let window get dragged up under the menu bar
    if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) ){
		newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
    }
    [self setFrameOrigin:newOrigin];
}
//---鼠标拖拽----------------------------------------------------------------

@end
