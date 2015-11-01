//
//  NBSearchVideoViewController.m
//  hzch
//
//  Created by xtturing on 15/10/18.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBSearchVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>  
#define HTTP_IMAGE  @"http://ditu.zj.cn/MEDIA/%ld/VIDEO/%@"
@interface NBSearchVideoViewController ()
@end

@implementation NBSearchVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @"返回";
    self.title = self.titleName;
     NSString* escaped_value = [self.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:HTTP_IMAGE,(long)self.catalogID,escaped_value];
    NSLog(@"video url %@", url);
    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];
    // add to view
    [self.view addSubview:playerViewController.view];
    // play movie
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    player.controlStyle = MPMovieControlStyleNone;
    player.shouldAutoplay = YES;
    player.repeatMode = MPMovieRepeatModeOne;
    [player setFullscreen:YES animated:YES];
    player.scalingMode = MPMovieScalingModeAspectFit;
    [player play];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
