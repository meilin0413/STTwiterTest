//
//  AppDelegate.m
//  STTwitterDemo
//
//  Created by Lily li on 2017/6/1.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    
}
- (void)handleURLEvent:(NSAppleEventDescriptor*)theEvent withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
    // Process URL Request
    NSString* path = [[theEvent paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSURL *url = [NSURL URLWithString:path];
    
    if ([[url scheme] isEqualToString:@"myapp"] == NO) return;
    
    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
    
    NSString *token = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];
    NSDictionary *userInfo = @{@"token":token,@"verifier":verifier};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:self userInfo:userInfo];
    
    //post notification;
    //[[[NSApplication sharedApplication] mainWindow] makeKeyAndOrderFront:nil];
//    ViewController *vc = [[ViewController alloc] init];
//    [vc setOAuthToken:token oauthVerifier:verifier];
    
}
- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
