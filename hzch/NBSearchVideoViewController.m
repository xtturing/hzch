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
    // add to view
    MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:url]];
    
    [movie.moviePlayer prepareToPlay];
    [self presentMoviePlayerViewControllerAnimated:movie];
    [movie.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [movie.view setBackgroundColor:[UIColor clearColor]];
    
    [movie.view setFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                           selector:@selector(movieFinishedCallback:)
     
                                               name:MPMoviePlayerPlaybackDidFinishNotification
     
                                             object:movie.moviePlayer];
    
}


-(void)movieFinishedCallback:(NSNotification*)notify{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
     
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
     
                                                object:theMovie];
    
    [self dismissMoviePlayerViewControllerAnimated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
