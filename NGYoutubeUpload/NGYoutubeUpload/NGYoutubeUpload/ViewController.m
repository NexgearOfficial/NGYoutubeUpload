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
    NGYoutubeOAuth *youTubeOAuth = [[NGYoutubeOAuth alloc]initWithClientId:@"348134387519-phohdm0urovbt0asodvi5is18r0f1r45.apps.googleusercontent.com" clientSecret:@"Sqh1u7-HZD9AeaYtA5zrWyt8"];
    [youTubeOAuth uploadVideo:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Sequence_02" ofType:@"mp4"]]];
}
@end
