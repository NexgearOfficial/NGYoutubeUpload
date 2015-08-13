//
//  ViewController.m
//  NGYoutubeUpload
//
//  Created by Apple on 13/08/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)connectYouTube:(id)sender {
    NGYoutubeOAuth *youTubeOAuth = [[NGYoutubeOAuth alloc]init];
    
    [youTubeOAuth authenticateWithYouTubeUsingYouTubeClientID:@"348134387519-tqsouuj9hfon405rhohfalhqlc1lmpi0.apps.googleusercontent.com"
                                          youTubeClientSecret:@"ZzWDgnMCBlMA05Q8vKneD8Lk"
                                                 responseType:@"code"
                                                        scope:@"https://www.googleapis.com/auth/youtube.force-ssl%20https://www.googleapis.com/auth/youtube%20https://www.googleapis.com/auth/youtubepartner%20https://www.googleapis.com/auth/youtube.upload"
                                                        state:@""
                                               appURLCallBack:@"urn:ietf:wg:oauth:2.0:oob"
                                                   accessType:@"offline"
                                               viewController:self
                                                             :^(BOOL success, NSString *youTubeToken, NSString *youTubeRefreshToken) {
                                                                 
                                                                 if (success) {
                                                                     //the token you will use to request right now
                                                                     [[NSUserDefaults standardUserDefaults] setObject:youTubeToken forKey:@"youtube_token"];
                                                                     //token you can use to request a new token on your behalf for requestion later
                                                                     //this only shows when you ask for "offline access"
                                                                     [[NSUserDefaults standardUserDefaults] setObject:youTubeRefreshToken forKey:@"youtube_refresh"];   
                                                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                                                     NSLog(@" youtube token %@",youTubeToken);
                                                                     NSLog(@" youtube refresh token %@",youTubeRefreshToken);
                                                                     //Do whatever you need with the token
                                                                     
                                                                 }
                                                                 
                                                                 
                                                             }];
    

}

@end
