//
//  tucengTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/8.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "tucengTableViewController.h"
#import "dataHttpManager.h"
@interface tucengTableViewController (){
}
@property (nonatomic,strong) NSArray *cacheList;
@property (nonatomic,strong)  NSArray *array;
@property (nonatomic,strong)  NSArray *layerArray;
@end

@implementation tucengTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.cacheList = [[dataHttpManager getInstance].cacheDB getAllCache];
    _array = @[@"中国电子地图",@"中国电子地图注记",@"中国影像",@"中国影像注记",@"浙江电子地图",@"浙江电子地图注记",@"浙江影像",@"浙江影像注记"];
    _layerArray = @[@"vec",@"cva",@"img",@"cia",@"zjemap",@"zjemapanno",@"imgmap",@"imgmap_lab"];
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
    return [_array count];
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
    if([self isInCacheList:indexPath.row]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [_array objectAtIndex:indexPath.row];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![self isInCacheList:indexPath.row]){
        [dataHttpManager getInstance].cache.typeID = indexPath.row;
        [dataHttpManager getInstance].cache.name = [_array objectAtIndex:indexPath.row];
        [dataHttpManager getInstance].cache.layerName = [_layerArray objectAtIndex:indexPath.row];
        [dataHttpManager getInstance].cache.minLevel = 1;
        [dataHttpManager getInstance].cache.maxLevel = 20;
        [dataHttpManager getInstance].cache.isShow = YES;
        [tableView reloadData];
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        for (DBCache *cache in self.cacheList) {
            if(cache.typeID == indexPath.row){
                [dataHttpManager getInstance].cache = cache;
                break;
            }
        }
        [tableView reloadData];
    }
}

- (BOOL)isInCacheList:(NSInteger)typeID{
    if(!self.cacheList || self.cacheList.count == 0){
        if([dataHttpManager getInstance].cache.typeID == typeID){
            return YES;
        }
        return NO;
    }else{
        for (DBCache *cache in self.cacheList) {
            if(cache.typeID == typeID){
                return YES;
            }
        }
    }
    
    return NO;
}

@end
