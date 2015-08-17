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

NSString *currentFetch = @"";


/**
 *  Custom initializer of the class
 *
 *  @param clientID     youtube clientId
 *  @param clientSecret youtube cleint Secret
 *
 *  @return self
 */
-(id)initWithClientId:(NSString *)clientID clientSecret:(NSString *)clientSecret{
    if ((self = [super init]))
    {
        self.youtubeClientID = clientID;
        self.youtubeClientSecret = clientSecret;
        self.state = @"";
        self.scope = @"https://www.googleapis.com/auth/youtube.force-ssl%20https://www.googleapis.com/auth/youtube%20https://www.googleapis.com/auth/youtubepartner%20https://www.googleapis.com/auth/youtube.upload";
        self.uriCallBack = @"urn:ietf:wg:oauth:2.0:oob";
        self.youTubeAccessType = @"offline";
    }
    return self;
}

/**
 *  Uploads the video
 *
 *  @param videoData
 */
-(void)uploadVideo:(NSData *)videoData{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"youtube_refresh"]){
        [self getNewAccessToken];
    } else {
        NSString *authenticateURLString = [NSString stringWithFormat:@"%@?client_id=%@&response_type=code&state=%@&scope=%@&redirect_uri=%@&access_type=%@", youTubeAuthorizationURL, self.youtubeClientID, self.state, self.scope, self.uriCallBack, self.youTubeAccessType];
        NGOauthViewController *OAuthController = [[NGOauthViewController alloc]init];
        OAuthController.ngYoutubeAuth = self;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:OAuthController];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navController animated:YES completion:^{
            [OAuthController.ngoAuthViewWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]]];
        }];
        
    }
}

/**
 *  Get the new access token with the refresh token
 */
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
    currentFetch = @"access_token";
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
    if([currentFetch isEqualToString:@"access_token"]){
        [[NSUserDefaults standardUserDefaults]setObject:[dictionary objectForKey:@"access_token"] forKey:@"youtube_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self uploadYoutubeVideoDetails];

    }

}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Received Error %@",error);

}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}


/**
 *  Get the URL for video data upload
 *
 *  @return URL
 */
- (NSString *) getCorrectURL{
    
    return [[NSString alloc] initWithFormat:@"https://www.googleapis.com/upload/youtube/v3/videos?uploadType=resumable&part=snippet,status&key=%@&access_token=%@",@"AIzaSyAgcGf7jXXNe5Pk_PohUv2tV-kjdUI1TPY",[[NSUserDefaults standardUserDefaults] objectForKey:@"youtube_token"]];
}
/**
 *  Uploads the video details
 */

- (void)uploadYoutubeVideoDetails {
    NSLog(@"access - %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"youtube_token"]);
    NSDictionary *headersDict = @{@"Content-Type": @"application/json; charset=UTF-8", @"Accept": @"application/json", @"Authorization":[[NSUserDefaults standardUserDefaults] objectForKey:@"youtube_token"],@"x-upload-content-type":@"video/*"};
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
    NSError *error;
    NSLog(@"BODY :: %@",body);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    
    [request setHTTPBody:jsonData];
    [request setAllHTTPHeaderFields:headersDict];
    
    NSHTTPURLResponse * response = nil;
    NSError * reqError = nil;
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&reqError];

    if (reqError == nil)
    {
        if(response){
            [self uploadFile : [[response allHeaderFields] objectForKey:@"Location"]];
        }
    } else{
           NSLog(@"error %@",reqError);
           NSLog(@"response %@",response);
    }
}

/**
 *  Uploads the video file
 *
 *  @param locationUrl : The URL where the video will be uploaded.
 */

- (void) uploadFile : (NSString *) locationUrl{
    NSDictionary *headersDict = @{@"Content-Type": @"video/.mp4", @"Accept": @"application/json", @"Authorization":[[NSUserDefaults standardUserDefaults] objectForKey:@"youtube_token"]};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:locationUrl]];
    [request setHTTPMethod:@"PUT"];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"instagram03140" ofType:@"mp4"] options:0 error:&error];
    [request setHTTPBody:data];
    [request setAllHTTPHeaderFields:headersDict];
    currentFetch = @"uploadFile";
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

@end
