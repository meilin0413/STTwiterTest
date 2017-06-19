//
//  WebViewController.m
//  STTwitterDemo
//
//  Created by Lily li on 2017/6/1.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)closeWebVIew:(id)sender {
    [self dismissController:@"webViewController"];
}

@end
