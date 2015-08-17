//
//  NGOauthViewController.m
//  NGYoutubeUpload
//
//  Created by Apple on 13/08/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "NGOauthViewController.h"

@implementation NGOauthViewController
static NSString *youTubeTokenURL = @"https://accounts.google.com/o/oauth2/token";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:229.0f/255 green:45.0f/255 blue:39.0f/255 alpha:1.0f]];
    
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 80)];
    [logo setTintColor:[UIColor whiteColor]];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    [logo setImage:[[UIImage imageNamed:@"YouTube.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.navigationItem setTitleView:logo];
    
    self.ngoAuthViewWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.ngoAuthViewWebView setDelegate:self];
    
    [self.view addSubview:self.ngoAuthViewWebView];
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if([pageTitle containsString:@"code="]){
        NSArray *codeArray = [pageTitle componentsSeparatedByString:@"code="];
        
        NSString *code = [codeArray lastObject];
        
        NSString *post = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", code,self.ngYoutubeAuth.youtubeClientID, self.ngYoutubeAuth.youtubeClientSecret, self.ngYoutubeAuth.uriCallBack];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:youTubeTokenURL]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            NSString *token = [json objectForKey:@"access_token"];
            NSString *refreshToken = [json objectForKey:@"refresh_token"];
            if (token && refreshToken) {
                self.ngYoutubeAuth.completion(YES, token, refreshToken);
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }else{
                NSLog(@"Error");
            }
        }];
    } else {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
