//
//  NGOauthViewController.h
//  NGYoutubeUpload
//
//  Created by Apple on 13/08/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGYoutubeOAuth.h"

@interface NGOauthViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong)id youTubeSender;

@property (nonatomic, strong)UIWebView *ngoAuthViewWebView;

@property (nonatomic, strong)NSString *youtubeClientID;

@property (nonatomic, strong)NSString *youtubeClientSecret;

@property (nonatomic, strong)NSString *uriCallBack;

@property (nonatomic, strong)NSString *state;

@end
