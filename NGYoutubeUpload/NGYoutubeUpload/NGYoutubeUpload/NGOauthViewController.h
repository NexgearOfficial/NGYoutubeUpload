//
//  NGOauthViewController.h
//  NGYoutubeUpload
//
//  Created by Apple on 13/08/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NGYoutubeOAuth.h"
@class NGYoutubeOAuth;

@interface NGOauthViewController : UIViewController<UIWebViewDelegate>{
}
@property (nonatomic, strong)NGYoutubeOAuth *ngYoutubeAuth;

@property (nonatomic, strong)UIWebView *ngoAuthViewWebView;


@end
