//
//  NBSearchCatalogDetailTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/17.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBSearchCatalogDetailTableViewController.h"
#import "NBSearchImageViewController.h"

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
        
    }
    
}

@end
