//
//  SqliteDetailTableViewController.m
//  hzch
//
//  Created by xtturing on 15/11/1.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "SqliteDetailTableViewController.h"
#import "NBSearchImageViewController.h"
#import "NBSearchVideoViewController.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
@interface SqliteDetailTableViewController ()<dataHttpDelegate>

@property (nonatomic,strong) NSMutableDictionary *showDic;

@end

@implementation SqliteDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[dataHttpManager getInstance] letGetThematic];
    });
    [self removeNullName];
    
    self.title = [[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"name"]?[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"name"]:([[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"NAME"]?[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"NAME"]:[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"FNAME"]);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [dataHttpManager getInstance].delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [dataHttpManager getInstance].delegate =  nil;
}

- (IBAction)doBack:(id)sender{
    if(self.isPush){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didGetThematic:(NSMutableDictionary *)thematicDic{
    [SVProgressHUD dismiss];
    [self removeNullName];
    [self.tableView reloadData];
}

- (void)removeNullName{
    self.showDic = [NSMutableDictionary dictionaryWithDictionary:[dataHttpManager getInstance].sqliteCalloutDic];
    if([dataHttpManager getInstance].thematicDic.count > 0){
        for (NSString *key in [dataHttpManager getInstance].sqliteCalloutDic.allKeys) {
            NSString *name = [[dataHttpManager getInstance].thematicDic objectForKey:[key lowercaseString]];
            if(!name){
                name = [[dataHttpManager getInstance].thematicDic objectForKey:[key uppercaseString]];
            }
            if(!name){
                [self.showDic removeObjectForKey:key];
            }
        }
        if(self.showDic.count <= 0){
            self.showDic = [NSMutableDictionary dictionaryWithDictionary:[dataHttpManager getInstance].sqliteCalloutDic];
        }
    }
    
}

- (void)didGetFailed{
    [SVProgressHUD dismiss];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.showDic.allKeys  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.showDic.allKeys objectAtIndex:indexPath.row];
    static NSString *FirstLevelCell = @"sqliteCalloutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier: FirstLevelCell];
    }
    if((([key isEqualToString:@"IMAGE"] || [key isEqualToString:@"image"]) || ([key isEqualToString:@"VIDEO"] || [key isEqualToString:@"video"]))){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSString *name = [[dataHttpManager getInstance].thematicDic objectForKey:[key lowercaseString]];
    if(!name){
        name = [[dataHttpManager getInstance].thematicDic objectForKey:[key uppercaseString]];
    }
    if(name){
        cell.textLabel.text = [NSString stringWithFormat:@"%@:",name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.showDic objectForKey:key]];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.showDic objectForKey:key]];
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.minimumScaleFactor = 0.7;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [self.showDic.allKeys objectAtIndex:indexPath.row];
    NSString *value = [self.showDic objectForKey:key];
    if(([key isEqualToString:@"IMAGE"] || [key isEqualToString:@"image"]) && value.length > 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NBSearchImageViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"NBSearchImageViewController"];
        mapViewController.catalogID = [[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"metadataid"] integerValue]?[[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"metadataid"] integerValue]:[dataHttpManager getInstance].tableID;
        mapViewController.imageUrl = value;
        mapViewController.titleName = self.title;
          self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationController pushViewController:mapViewController animated:YES];
    }else if(([key isEqualToString:@"VIDEO"] || [key isEqualToString:@"video"]) && value.length > 0){
        NSString* escaped_value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url = [NSString stringWithFormat:@"http://ditu.zj.cn/MEDIA/%ld/VIDEO/%@",(long)([[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"metadataid"] integerValue]?[[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"metadataid"] integerValue]:[dataHttpManager getInstance].tableID),escaped_value];
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
    }else{
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if((cell.detailTextLabel.text.length + cell.textLabel.text.length)> 14){
            ALERT(cell.detailTextLabel.text);
        }
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
