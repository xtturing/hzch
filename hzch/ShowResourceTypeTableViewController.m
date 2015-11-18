//
//  ShowResourceTypeTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/18.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "ShowResourceTypeTableViewController.h"

@interface ShowResourceTypeTableViewController ()

@end

@implementation ShowResourceTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = nil;
    NSInteger type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SHOWRESOURCETYPE"] integerValue];
    if(indexPath.row == 0){
        title = @"切换";
    }else{
        title = @"叠加";
    }
    static NSString *FirstLevelCell = @"ShowResource";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    if(indexPath.row == 0){
        if(type == 0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        if(type == 1){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.textLabel.text = title;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSUserDefaults standardUserDefaults] setObject:@(indexPath.row) forKey:@"SHOWRESOURCETYPE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [tableView reloadData];
}
@end
