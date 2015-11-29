//
//  cengjiTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/8.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "cengjiTableViewController.h"
#import "dataHttpManager.h"
@interface cengjiTableViewController ()
@property (nonatomic,strong) NSArray *cacheList;
@end

@implementation cengjiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cacheList = [[dataHttpManager getInstance].cacheDB getAllCache];
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
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FirstLevelCell = @"cengji";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    if((indexPath.row + 1) >= [dataHttpManager getInstance].cache.minLevel && (indexPath.row + 1) <= [dataHttpManager getInstance].cache.maxLevel){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = (indexPath.row+1);
    if(index < [dataHttpManager getInstance].cache.minLevel){
        [dataHttpManager getInstance].cache.minLevel = index;
    }else if (index > [dataHttpManager getInstance].cache.maxLevel){
        [dataHttpManager getInstance].cache.maxLevel = index;
    }else{
        if((index - [dataHttpManager getInstance].cache.minLevel) <= ([dataHttpManager getInstance].cache.maxLevel - index)){
            [dataHttpManager getInstance].cache.minLevel = index;
        }else{
            [dataHttpManager getInstance].cache.maxLevel = index;
        }
    }
    [tableView reloadData];
}

- (BOOL)isInCacheList:(NSInteger)typeID{
    if([dataHttpManager getInstance].cache.minLevel == typeID || [dataHttpManager getInstance].cache.maxLevel == typeID ){
        return YES;
    }
    return NO;
}


@end
