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


-(void)authenticateWithYouTubeUsingYouTubeClientID:(NSString *)youTubeClientID youTubeClientSecret:(NSString *)youTubeClientSecret responseType:(NSString *)youTubeResponseType scope:(NSString *)scope state:(NSString *)state appURLCallBack:(NSString *)appURLCallBack accessType:(NSString *)youTubeAccessType viewController:(id)viewController :(void (^)(BOOL, NSString *, NSString *))completion{
    
    
    
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
    self.completion = completion;
    
}

-(void) getNewAccessToken{
    NSString *post = [NSString stringWithFormat:@"client_id=348134387519-phohdm0urovbt0asodvi5is18r0f1r45.apps.googleusercontent.com&client_secret=Sqh1u7-HZD9AeaYtA5zrWyt8&refresh_token=%@&grant_type=refresh_token",[[NSUserDefaults standardUserDefaults]objectForKey:@"youtube_refresh"]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://accounts.google.com/o/oauth2/token"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }

}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data{
    NSLog(@"Received data %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [[NSUserDefaults standardUserDefaults]setObject:[dictionary objectForKey:@"access_token"] forKey:@"youtube_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self uploadYoutubeVideoDetails];

}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}

- (NSString *) getCorrectURL{
    
    //return [[NSString alloc] initWithFormat:@"https://www.googleapis.com/upload/youtube/v3/videos"];
    
    
    return [[NSString alloc] initWithFormat:@"https://www.googleapis.com/upload/youtube/v3/videos?uploadType=resumable&part=snippet,status&key=%@&access_token=%@",@"AIzaSyAgcGf7jXXNe5Pk_PohUv2tV-kjdUI1TPY",[[NSUserDefaults standardUserDefaults] objectForKey:@"youtube_token"]];
}

- (void)uploadYoutubeVideoDetails {
    NSLog(@"access - %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"youtube_token"]);
    NSDictionary *headersDict = @{@"Content-Type": @"application/json; charset=UTF-8", @"Accept": @"application/json", @"Authorization":[[NSUserDefaults standardUserDefaults] objectForKey:@"youtube_token"],@"x-upload-content-type":@"video/*"};
    //NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"AIzaSyAgcGf7jXXNe5Pk_PohUv2tV-kjdUI1TPY",@"key",@"snippet,status",@"part",@"resumable",@"uploadType", nil
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self getCorrectURL]]];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *snippetDictionary = [[NSMutableDictionary alloc] init];
    [snippetDictionary setObject:@"Frodo" forKey:@"title"];
    [snippetDictionary setObject:@"Frodo rocks" forKey:@"description"];
    [snippetDictionary setObject:@"22" forKey:@"categoryId"];
    [snippetDictionary setObject:[NSArray arrayWithObjects:@"Frodo",@"Rocks", nil] forKey:@"tags"];
    
    [body setObject:snippetDictionary forKey:@"snippet"];
    
    NSMutableDictionary *statusDictionary = [[NSMutableDictionary alloc] init];
    [statusDictionary setObject:@"public" forKey:@"privacyStatus"];
    [body setObject:statusDictionary forKey:@"status"];
    //[body setObject:videoID forKey:@"id"];
    NSError *error;
    NSLog(@"BODY :: %@",body);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    
    [request setHTTPBody:jsonData];
    [request setAllHTTPHeaderFields:headersDict];
    
    NSURLResponse * response = nil;
    NSError * reqError = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&reqError];
    
    if (reqError == nil)
    {
        NSError *err;
        if([response ]){
            NSLog(@"Response: %@", [[response allHeaderFields] objectForKey:@"Location"]);
            NSString *locationUrl = [[response allHeaderFields] objectForKey:@"Location"];
            [self uploadFile : locationUrl];
        }        // Parse data here
    } else{
           NSLog(@"error %@",reqError);
        NSLog(@"response %@",response);
    }
    
    /*AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //NSLog(@"Response : %@",operation.request);
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[operation response] allHeaderFields]){
            NSLog(@"Response: %@", [[[operation response] allHeaderFields] objectForKey:@"Location"]);
            NSString *locationUrl = [[[operation response] allHeaderFields] objectForKey:@"Location"];
            [self uploadFile : locationUrl];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Error : %@",operation.responseString);
        
    }];
    [operation start];*/
    
}

- (void) uploadFile : (NSString *) locationUrl{
    NSDictionary *headersDict = @{@"Content-Type": @"video/.mp4", @"Accept": @"application/json", @"Authorization":[[NSUserDefaults standardUserDefaults] objectForKey:@"youtube_token"]};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:locationUrl]];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"instagram03140" ofType:@"mp4"]]];
    [request setAllHTTPHeaderFields:headersDict];
    
   /* AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        NSLog(@"Error : %@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Error : %@",operation.responseString);
        
    }];
    [operation start];*/
}

@end
