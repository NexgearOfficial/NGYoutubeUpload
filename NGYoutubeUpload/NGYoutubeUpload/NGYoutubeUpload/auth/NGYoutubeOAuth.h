//
//  YouTubeAuth.h
//  NGYoutubeUpload
//
//  Created by Apple on 13/08/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGOauthViewController.h"

typedef void (^YouTubeCompletion)(BOOL success, NSString *youTubeToken, NSString *youTubeRefreshToken);

@interface NGYoutubeOAuth : NSObject <NSURLConnectionDelegate>

@property(copy, nonatomic)YouTubeCompletion completion;

- (void)authenticateWithYouTubeUsingYouTubeClientID:(NSString*)youTubeClientID
                                youTubeClientSecret:(NSString*)youTubeClientSecret
                                       responseType:(NSString*)youTubeResponseType
                                              scope:(NSString*)scope
                                              state:(NSString*)state
                                     appURLCallBack:(NSString*)appURLCallBack
                                         accessType:(NSString*)youTubeAccessType
                                     viewController:(id)viewController
                                                   :(void (^)(BOOL success, NSString *youTubeToken, NSString *youTubeRefreshToken))completelion;

-(void) getNewAccessToken;

- (void)uploadYoutubeVideoDetails;
@end
