//
//  YouTubeAuth.h
//  NGYoutubeUpload
//
//  Created by Apple on 13/08/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGOauthViewController.h"

typedef void (^YouTubeCompletelion)(BOOL success, NSString *youTubeToken, NSString *youTubeRefreshToken);

@interface NGYoutubeOAuth : NSObject

@property(copy, nonatomic)YouTubeCompletelion completelion;

- (void)authenticateWithYouTubeUsingYouTubeClientID:(NSString*)youTubeClientID
                                youTubeClientSecret:(NSString*)youTubeClientSecret
                                       responseType:(NSString*)youTubeResponseType
                                              scope:(NSString*)scope
                                              state:(NSString*)state
                                     appURLCallBack:(NSString*)appURLCallBack
                                         accessType:(NSString*)youTubeAccessType
                                     viewController:(id)viewController
                                                   :(void (^)(BOOL success, NSString *youTubeToken, NSString *youTubeRefreshToken))completelion;
@end
