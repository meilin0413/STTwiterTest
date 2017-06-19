//
//  imageViewController.m
//  STTwitterDemo
//
//  Created by Lily li on 2017/6/16.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "imageViewController.h"
#import "ImageView.h"

@interface imageViewController ()

@end

@implementation imageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    ImageView *imageView = [[ImageView alloc] initWithFrame:NSMakeRect(0, 0, 450, 300)];
    NSImage *image = [NSImage imageNamed:@"close"];
    [imageView setImageScaling:NSImageScaleProportionallyUpOrDown];
    imageView.objectValue = image;
    [[self view] addSubview:imageView];
    
}

@end
