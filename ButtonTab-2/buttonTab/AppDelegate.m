//
//  AppDelegate.m
//  buttonTab
//
//  Created by 楚江 王 on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ButtonStyle.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //instance method '-contentView' not found (return type defaults tp 'id')
}
- (IBAction)menuButtonPressed:(id)sender {

    
    NSButton *button = (NSButton *)sender; 
    NSInteger tag = button.tag; 
    [button setImage:[NSImage imageNamed:@"menuBtnHover.png"]]; 
    for (int i = 1; i <= 3; i++) { 
        if (tag != i) { 
            button =[[self.window contentView] viewWithTag:i]; 
            
            [button setImage:[NSImage imageNamed:@"menuBtn.png"]]; 
            NSLog(@"button tag: %ld %d %@", tag,i ,button );
        } 
    }

}

@end
