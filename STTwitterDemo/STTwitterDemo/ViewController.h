//
//  ViewController.h
//  STTwitterDemo
//ta
//  Created by Lily li on 2017/6/1.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "STTwitter.h"
@interface ViewController : NSViewController <STTwitterAPIOSProtocol>
@property (nonatomic, strong) NSArray *statuses;

@property (weak) IBOutlet NSTextField *consumerKey;
@property (weak) IBOutlet NSTextField *consumerSecret;
@property (weak) IBOutlet NSImageView *userImage;

@property (weak) IBOutlet NSTextField *loginInStatus;
@property (weak) IBOutlet NSTextField *getTimeline;
@property (weak) IBOutlet NSTableView *tableView;
//@property (weak) IBOutlet NSTableView *tableViewPicture;
@property (weak) IBOutlet NSImageView *imageView;


- (IBAction)loginWithMac:(id)sender;
- (IBAction)loginOnWeb:(id)sender;
- (IBAction)getTimeline:(id)sender;
- (IBAction)logIn:(id)sender;
- (IBAction)favarate:(id)sender;

@property (nonatomic,retain) NSString* user;
@property (nonatomic,retain) NSString* passWord;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;
@end

