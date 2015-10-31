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
@interface SqliteDetailTableViewController ()

@end

@implementation SqliteDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = [[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"title"];
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
    return [[dataHttpManager getInstance].sqliteCalloutDic.allKeys  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [[dataHttpManager getInstance].sqliteCalloutDic.allKeys objectAtIndex:indexPath.row];
    static NSString *FirstLevelCell = @"sqliteCalloutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    if((([key isEqualToString:@"IMAGE"] || [key isEqualToString:@"image"]) || ([key isEqualToString:@"VIDEO"] || [key isEqualToString:@"video"]))){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if([[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:key] isKindOfClass:[NSString class]]){
        cell.textLabel.text = [[dataHttpManager getInstance].sqliteCalloutDic objectForKey:key];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:key]];
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [[dataHttpManager getInstance].sqliteCalloutDic.allKeys objectAtIndex:indexPath.row];
    NSString *value = [[dataHttpManager getInstance].sqliteCalloutDic objectForKey:key];
    if(([key isEqualToString:@"IMAGE"] || [key isEqualToString:@"image"]) && value.length > 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NBSearchImageViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"NBSearchImageViewController"];
        mapViewController.catalogID = [[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"metadataid"] integerValue];
        mapViewController.imageUrl = value;
        mapViewController.titleName = self.title;
        [self.navigationController pushViewController:mapViewController animated:YES];
    }
    if(([key isEqualToString:@"VIDEO"] || [key isEqualToString:@"video"]) && value.length > 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NBSearchVideoViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"NBSearchVideoViewController"];
        mapViewController.catalogID = [[[dataHttpManager getInstance].sqliteCalloutDic objectForKey:@"metadataid"] integerValue];
        mapViewController.imageUrl = value;
        mapViewController.titleName = self.title;
        [self.navigationController pushViewController:mapViewController animated:YES];
    }
    
}

@end
