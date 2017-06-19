//
//  ViewController.m
//  STTwitterDemo
//
//  Created by Lily li on 2017/6/1.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import "ViewController.h"
#import "STTwitter.h"
#import <Accounts/Accounts.h>
#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "NSMutableAttributeString+range.h"
#import "imageViewController.h"

typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage); // don't bother with NSError for that

@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *macAccounts;
@property (nonatomic, strong) accountChooserBlock_t accountChooserBlock;
@property (nonatomic, strong) WebViewController *webView;
@property (nonatomic, strong) NSButton *button;
@property (nonatomic, strong) imageViewController *imageViewa;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //add notification;
    // Do any additional setup after loading the view.
    [self.view.layer setBackgroundColor:[[NSColor whiteColor]CGColor]];
    
    self.accountStore = [[ACAccountStore alloc] init];
    [_consumerKey setStringValue:@"PdLBPYUXlhQpt4AguShUIw"];
    [_consumerSecret setStringValue:@"drdhGuKSingTbsDLtYpob4m5b5dn1abf9XXYyZKQzk"];
  //  NSURL *url = [NSURL URLWithString:@"http://pbs.twimg.com/media/DBTYiauVoAEvEql.jpg"];
 //    NSURL *url = [NSURL URLWithString:@"http://www.wsxz.cn/ylzx/uploads/allimg/170504/00523Q211-0.jpg"];
//    NSData *dat = [NSData dataWithContentsOfFile:@"/Users/Lily/Desktop/1.png"];
    
//    NSError *error = nil;
//    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
//    NSImage *image = [[NSImage alloc] initWithData:data];
//    
//    [_imageView setImage:image];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotification:) name:@"dismiss" object:nil];
    
    
}
- (void)reciveNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"dismiss"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *token = [userInfo objectForKey:@"token"];
        NSString *verifier = [userInfo objectForKey:@"verifier"];
        [self setOAuthToken:token oauthVerifier:verifier];
        [self dismissViewController:[self webView]];
        NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(60, 380, 80, 80)];
//        imageView.objectValue = [NSImage ]
    }
}

- (void)updateUserImage
{
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)loginWithMac:(id)sender {
    [_loginInStatus setStringValue:@"Trying to login with mac..."];
    __weak typeof(self) weakself = self;
    self.accountChooserBlock = ^(ACAccount *account,NSString *errorMessage){
        NSString *status = nil;
        if (account)
        {
            status = [NSString stringWithFormat:@"Did select %@",account.username];
            NSLog(@"status %@",status);
            [weakself loginWithMacAccount:account];
            
        }
        else
        {
            status = errorMessage;
        }
        [weakself.loginInStatus setStringValue:status];
    };
   [self chooseAcount];
}

- (void)loginWithMacAccount:(ACAccount *)account
{
    self.twitter = nil;
    self.twitter = [STTwitterAPI twitterAPIOSWithAccount:account delegate:self];
    
    [_twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID){
        [_loginInStatus setStringValue:[NSString stringWithFormat:@"@%@ (%@)", username, userID]];
        
    }errorBlock:^(NSError *error){
        [_loginInStatus setStringValue:[error localizedDescription]];
    }];
    
}
- (IBAction)loginOnWeb:(id)sender {
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"6OJhZCxIjOQirQDeuK2M2Tp98"  consumerSecret:@"TknCBx4ZslQLcmVejidNszPsPNfM27Q2ePOAvOvLafulVbXitE"];
    [_loginInStatus setStringValue:@"Trying to login with Safari"];
    [_loginInStatus setStringValue:@""];
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"-- url: %@", url);
        NSLog(@"-- oauthToken: %@", oauthToken);
        
//        if([self.openSafariSwitch isOn]) {
//            [[NSApplication sharedApplication] openURL:url];
//        } else {
//            WebViewController *webViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
//        
//            [self presentViewController:webViewVC animated:YES completion:^{
//                NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                [webViewVC.webView loadRequest:request];
//            }];
       // }
        //[[NSWorkspace sharedWorkspace] openURL:url];
        self.webView = [self.storyboard instantiateControllerWithIdentifier:@"webViewController"];
        [self presentViewControllerAsSheet:self.webView];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView.webView loadRequest:request];
        
        //[self performSelector:@selector(dismissViewController:) withObject:webView afterDelay:15.0];
        
    } authenticateInsteadOfAuthorize:NO
                    forceLogin:@(YES)
                    screenName:nil
                 oauthCallback:@"myapp://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                        [_loginInStatus setStringValue:[error localizedDescription]];
                    }];
    
}



- (IBAction)getTimeline:(id)sender {
    [self.getTimeline setStringValue:@""];
    
    [_twitter getHomeTimelineSinceID:nil count:20 successBlock:^(NSArray *statuses){
        NSLog(@"-------statuses: %@",statuses);
        self.statuses = statuses;
        [self.getTimeline setStringValue:[NSString stringWithFormat:@"%lu statuses",(unsigned long)[statuses count]]];
        [self.tableView reloadData];
        
    }errorBlock:^(NSError *error){
        [self.getTimeline setStringValue:error ? [error localizedDescription] : @"Unknown error"];
    }];
    
//    [_twitter getUserTimelineWithScreenName:@"meilinli3" successBlock:^(NSArray *statues){
//        self.statuses = statues;
//        [statues writeToFile:@"/Volumes/Data/myproject/STTwitterDemo/hihisdga.json" atomically:YES];
//        [self.getTimeline setStringValue:@"succese"];
//        NSLog(@"status %@",statues);
//        
//        [self.tableView reloadData];
//    }errorBlock:^(NSError *error)
//     {
//         [self.getTimeline setStringValue:error ? [error localizedDescription] : @"Unknown error"];
//         
//     }];
    
//    [_twitter getHomeTimelineSinceID:nil count:20 successBlock:^(NSArray *statuses){
//        NSLog(@"-- statuses: %@", statuses);
//        [self.getTimeline setStringValue:[NSString stringWithFormat:@"%lu statuses", (unsigned long)[statuses count]]];
//        self.statuses = statuses;
//        NSLog(@"statues %@",statuses);
//        [self.tableView reloadData];
//        
//    }errorBlock:^(NSError *error){
//        [self.getTimeline setStringValue:[error localizedDescription]];
//    }];
}

- (IBAction)logIn:(id)sender {
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"PdLBPYUXlhQpt4AguShUIw" consumerSecret:@"drdhGuKSingTbsDLtYpob4m5b5dn1abf9XXYyZKQzk" username:@"meilinli3" password:@"limeiling123"];
    
    [_twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID){
        [_loginInStatus setStringValue:[NSString stringWithFormat:@"@%@ (%@)", username, userID]];
    }errorBlock:^(NSError *error){
        [_loginInStatus setStringValue:[error localizedDescription]];
    }];
    
}

- (IBAction)favarate:(id)sender {
    NSLog(@"should change button image");
}

- (void)chooseAcount
{
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreRequestCompletionHandler = ^(BOOL granted, NSError *error){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (granted == NO)
            {
                _accountChooserBlock(nil,@"Acccess not granted.");
                return;
            }
            self.macAccounts = [_accountStore accountsWithAccountType:accountType];
            NSLog(@"account %@",_macAccounts);
            if ([_macAccounts count] == 1)
            {
            
                ACAccount *account = [_macAccounts lastObject];
                NSLog(@"account is %@",account);
                _accountChooserBlock(account,nil);
            }
            else
            {
                NSLog(@"hhhhhhhhh");
                //alert a window to choose username;
            }
        }];
    };
#if TARGET_OS_IPHONE &&  (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0) {
        [self.accountStore requestAccessToAccountsWithType:accountType
                                     withCompletionHandler:accountStoreRequestCompletionHandler];
    } else {
        [self.accountStore requestAccessToAccountsWithType:accountType
                                                   options:NULL
                                                completion:accountStoreRequestCompletionHandler];
    }
#else
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:accountStoreRequestCompletionHandler];
#endif
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier
{
    [self dismissController:nil];
    [_twitter postAccessTokenRequestWithPIN:verfier successBlock:^(NSString *oathToken,NSString * oauthTokenSecret, NSString *userID,NSString *screenName){
        NSLog(@"-- screenName: %@", screenName);
        [_loginInStatus setStringValue:[NSString stringWithFormat:@"%@ (%@)", screenName, userID]];
    }errorBlock:^(NSError *error){
        [_loginInStatus setStringValue:[error localizedDescription]];
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.statuses count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSDictionary *dic = [self.statuses objectAtIndex:row];
    NSDictionary *user = [dic objectForKey:@"user"];
    
    NSLog(@"%@",[dic objectForKey:@"favorited"]);
    
    NSDictionary *entities = [dic objectForKey:@"entities"];
    NSArray *media = [entities objectForKey:@"media"];
    NSMutableArray *mediaURLs = [NSMutableArray array];
    NSURL *mediaUrl = nil;
    for (NSDictionary *dict in media)
    {
        [mediaURLs addObject:[ NSURL URLWithString:[dict objectForKey:@"media_url"]]];
    }
    
    NSURL *url = [NSURL URLWithString:[user valueForKey:@"profile_image_url"]];
    
    NSString *identifier = tableColumn.identifier;
    CGFloat rowHeigtht = [tableView rowHeight];
    
    if ([identifier isEqualToString:@"maincell"])
    {
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSImage *image = [[NSImage alloc] initWithData:data];
        NSButton *button = [[NSButton alloc]initWithFrame:NSMakeRect(0, rowHeigtht-55, 80, 50)];
        [button setImage:image];
        [button setBordered:NO];
        [button setTarget:self];
        [button setAction:@selector(showImage:)];
        
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        [cellView addSubview:button];
        [cellView setNeedsDisplay:YES];
//        
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        NSImage *image = [[NSImage alloc] initWithData:data];
//       
//        
//        NSImageView *imageVIew = [[NSImageView alloc] initWithFrame:NSMakeRect(0,0, 100, 50)];
//        imageVIew.objectValue = image;
//        [cellView addSubview:imageVIew];
//        [cellView setNeedsDisplay:YES];
//        NSImageView *imageVIew = [tableView makeViewWithIdentifier:identifier owner:self];
//        
//        imageVIew.objectValue = image;
        
        return cellView;
        
    }
    else
    {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
        
        float tempHeight = 0;
        float tempWidth =0;
        if ([mediaURLs count] != 0)
        {
            NSInteger index = 0;
            
            for (NSURL *mediaUrl in mediaURLs)
            {
                NSImage *mediaImage = [[NSImage alloc] initWithData:[NSData dataWithContentsOfURL:mediaUrl]];
                if (index % 2 ==0)
                {
                    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0,80, 100, 50)];
                    imageView.objectValue = mediaImage;
                    tempWidth = tempWidth +100;
                    [cellView addSubview:imageView];
                    [cellView setNeedsDisplay:YES];
                }
                else
                {
                     NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0,80, 100, 50)];
                    imageView.objectValue = mediaImage;
                     tempHeight = tempHeight + 50;
                    tempWidth = 0;
                    [cellView addSubview:imageView];
                    [cellView setNeedsDisplay:YES];
                }
                
                index++;
            }
            
        }
        NSTextField *textField = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, 250, 80)];
        [textField setSelectable:YES];
        [textField setAllowsEditingTextAttributes:YES];
        NSMutableString *text = [NSMutableString stringWithString:[dic objectForKey:@"text"]];
        NSLog(@"text %@",text);
        [text appendString:@" "];
        
        NSMutableAttributedString *textWithAttribute = [[NSMutableAttributedString alloc] initWithString:text];
        
        for (NSInteger index=0; index< [text length]; index++)
        {
            NSRange range = [text rangeof:@"https:" after:index];
           
            if (range.location != NSNotFound)
            {
                NSRange blankRange = [text rangeof:@" " after:range.location];
                if (blankRange.location != NSNotFound)
                {
                    range.length = blankRange.location -range.location;
                    NSString *string = [text substringWithRange:range];
                    [textWithAttribute addAttribute:NSLinkAttributeName value:string range:range];
                    [textWithAttribute addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
                    index = range.location + range.length -1;
                }
               
            }
            else
                break;
            
        }
        for (NSInteger index=0; index< [text length]; index++)
        {
            NSRange range = [text rangeof:@"@" after:index];
            
            if (range.location != NSNotFound)
            {
                NSRange blankRange = [text rangeof:@" " after:range.location];
                if (blankRange.location != NSNotFound)
                {
                    range.length = blankRange.location -range.location;
                    NSString *string = [text substringWithRange:range];
                    [textWithAttribute addAttribute:NSLinkAttributeName value:string range:range];
                    [textWithAttribute addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
                    index = range.location + range.length -1;
                }
                
            }
            else
                break;
            
        }
        //NSArray *urls = [text componentsMa]
        
        
        textField.objectValue = textWithAttribute;
        [textField setBordered:NO];
        [textField setAutoresizingMask:NSViewWidthSizable];
        [textField setEditable:NO];
        NSButton *favoritedButton = [[NSButton alloc]initWithFrame:NSMakeRect(260, 0, 15, 15) ];
        favoritedButton.tag = 15;
        
        NSTextField *countOfFavorite = [[NSTextField alloc] initWithFrame:NSMakeRect(275, 0, 45, 15)];
//        countOfFavorite.tag -15
        [countOfFavorite setBordered:NO];
        countOfFavorite.tag = row;
        [countOfFavorite setEditable:NO];
        [countOfFavorite setAutoresizingMask:NSViewWidthSizable];
        
        id b = [dic objectForKey:@"favorite_count"];
        countOfFavorite.objectValue = [dic objectForKey:@"favorite_count"];
        NSLog(@"count %@",[dic objectForKey:@"favorite_count"]);
        [favoritedButton setTarget:self];
        [favoritedButton setAction:@selector(changeButtonBackgroud:)];
        favoritedButton.tag = row;

        if ([[dic objectForKey:@"favorited"] intValue]!=0 )
        {                                                                                                                                                       
            [favoritedButton setImage:[NSImage imageNamed:@"redheart"]];
            [favoritedButton setImageScaling:NSImageScaleProportionallyDown];
        }
        else
        {
            [favoritedButton setImage:[NSImage imageNamed:@"faverate"]];
            [favoritedButton setImageScaling:NSImageScaleProportionallyDown];
        }
        
        [favoritedButton setImagePosition:NSImageOnly];
        [favoritedButton setBordered:NO];
//        [favoritedButton sizeToFit];
        
        [cellView addSubview:favoritedButton];
        [cellView addSubview:textField];
        [cellView addSubview:countOfFavorite];
        
        
        
       
        return cellView;
    }
    
    return nil;
}

- (void)changeButtonBackgroud:(id)sender {
    //
    NSButton *button = (NSButton *)sender;
    NSInteger tag = button.tag;
    NSLog(@"tag %li",tag);
    if ([button image] == [NSImage imageNamed:@"faverate"])
    {
        [button setImage:[NSImage imageNamed:@"redheart"]];
        
    }
    else
        [button setImage:[NSImage imageNamed:@"faverate"]];
    id a = [button.superview viewWithTag:button.tag];
    
    NSString *count = [(NSTextField *)[button.superview viewWithTag:button.tag] stringValue];
    
    NSLog(@"favorite count %@",count);
    NSLog(@"button supper view %@",button.superview);
}

- (void)showImage:(id)sender
{
    NSButton *button = (NSButton *)sender;
    NSImage *image = [button image];
    [[image TIFFRepresentation] writeToFile:@"image" atomically:NO];
    
    [[NSWorkspace sharedWorkspace] openFile:@"image"];
    
}
- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount
{
    if(twitterAPI != _twitter) return;
    NSLog(@"-- account was invalidated: %@ | %@", invalidatedAccount, invalidatedAccount.username);
}


@end
