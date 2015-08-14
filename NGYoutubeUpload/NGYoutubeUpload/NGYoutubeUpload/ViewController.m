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
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"youtube_refresh"]){
        [youTubeOAuth getNewAccessToken];
    } else {
        [youTubeOAuth authenticateWithYouTubeUsingYouTubeClientID:@"348134387519-phohdm0urovbt0asodvi5is18r0f1r45.apps.googleusercontent.com"
                                              youTubeClientSecret:@"Sqh1u7-HZD9AeaYtA5zrWyt8"
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
                                                                         [youTubeOAuth uploadYoutubeVideoDetails];
                                                                     }
                                                                     
                                                                     
                                                                 }];
        
        
    }
    
    }





@end
