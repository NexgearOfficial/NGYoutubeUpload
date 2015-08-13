//
//  YouTubeAuth.m
//  NGYoutubeUpload
//
//  Created by Apple on 13/08/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "NGYoutubeOAuth.h"

@implementation NGYoutubeOAuth
static NSString *youTubeAuthorizationURL = @"https://accounts.google.com/o/oauth2/auth";


-(void)authenticateWithYouTubeUsingYouTubeClientID:(NSString *)youTubeClientID youTubeClientSecret:(NSString *)youTubeClientSecret responseType:(NSString *)youTubeResponseType scope:(NSString *)scope state:(NSString *)state appURLCallBack:(NSString *)appURLCallBack accessType:(NSString *)youTubeAccessType viewController:(id)viewController :(void (^)(BOOL, NSString *, NSString *))completelion{

    NSString *authenticateURLString = [NSString stringWithFormat:@"%@?client_id=%@&response_type=code&state=%@&scope=%@&redirect_uri=%@&access_type=%@", youTubeAuthorizationURL, youTubeClientID, state, scope, appURLCallBack, youTubeAccessType];
    
    NGOauthViewController *OAuthController = [[NGOauthViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:OAuthController];
    [viewController presentViewController:navController animated:YES completion:^{
        OAuthController.uriCallBack = appURLCallBack;
        OAuthController.state = state;
        OAuthController.youtubeClientID = youTubeClientID;
        OAuthController.youtubeClientSecret = youTubeClientSecret;
        OAuthController.youTubeSender = self;
        [OAuthController.ngoAuthViewWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]]];
        
    }];
    self.completelion = completelion;
    
}

@end
