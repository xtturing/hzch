//
//  NBSearchCatalogDetailTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/17.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBSearchCatalogDetailTableViewController.h"
#import "NBSearchImageViewController.h"
#import "NBSearchVideoViewController.h"
#import "dataHttpManager.h"
@interface NBSearchCatalogDetailTableViewController ()

@end

@implementation NBSearchCatalogDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = self.catalog.name;
}

- (IBAction)doBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.catalog.catalogDic.allKeys  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.catalog.catalogDic.allKeys objectAtIndex:indexPath.row];
    NSString *title= [self.catalog.catalogDic objectForKey:key];
    static NSString *FirstLevelCell = @"NBSearchcatalog";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    if([key isEqualToString:@"image"] || [key isEqualToString:@"video"]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = title;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [self.catalog.catalogDic.allKeys objectAtIndex:indexPath.row];
    NSString *value = [self.catalog.catalogDic objectForKey:key];
    if([key isEqualToString:@"image"] && value.length > 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NBSearchImageViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"NBSearchImageViewController"];
        mapViewController.catalogID = self.tableID;
        mapViewController.imageUrl = value;
        mapViewController.titleName = self.catalog.name;
        [self.navigationController pushViewController:mapViewController animated:YES];
    }
    if([key isEqualToString:@"video"]){
        NSString* escaped_value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url = [NSString stringWithFormat:@"http://ditu.zj.cn/MEDIA/%ld/VIDEO/%@",(long)self.tableID,escaped_value];
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
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        NBSearchVideoViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"NBSearchVideoViewController"];
//        mapViewController.catalogID = self.tableID;
//        mapViewController.imageUrl = value;
//        mapViewController.titleName = self.catalog.name;
//        [self.navigationController pushViewController:mapViewController animated:YES];
    }
    
}

-(void)movieFinishedCallback:(NSNotification*)notify{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController* theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
     
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
     
                                                 object:theMovie];
    
    [self dismissMoviePlayerViewControllerAnimated];
    
}


@end
