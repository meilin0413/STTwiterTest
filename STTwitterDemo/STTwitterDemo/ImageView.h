//
//  ImageView.h
//  STTwitterDemo
//
//  Created by Lily li on 2017/6/16.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageView : NSImageView
{
    NSTrackingArea *trackingArea;
    NSButton *button;
}

@end
