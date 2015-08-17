//
//  YouTubeAuth.h
//  NGYoutubeUpload
//
//  Created by Apple on 13/08/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NGOauthViewController.h"

typedef void (^YouTubeCompletion)(BOOL success, NSString *youTubeToken, NSString *youTubeRefreshToken);


@interface NGYoutubeOAuth : NSObject <NSURLConnectionDelegate>

@property(copy, nonatomic)YouTubeCompletion completion;

@property (nonatomic, weak)NSString *youtubeClientID;

@property (nonatomic, strong)NSString *youtubeClientSecret;

@property (nonatomic, strong)NSString *youtubepublicAPIKey;

@property (nonatomic, strong)NSString *uriCallBack;

@property (nonatomic, strong)NSString *state;

@property (nonatomic, strong)NSString *scope;

@property (nonatomic, strong)NSString *youTubeAccessType;


- (id) initWithClientId:(NSString *)clientID clientSecret:(NSString *) clientSecret;

- (void) uploadVideo:(NSData *) videoData;

@end
