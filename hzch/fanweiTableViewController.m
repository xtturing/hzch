//
//  fanweiTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/8.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "fanweiTableViewController.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
@interface fanweiTableViewController ()<dataHttpDelegate>

@end

@implementation fanweiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!([dataHttpManager getInstance].rangeDic && [dataHttpManager getInstance].rangeDic.count > 0)){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[dataHttpManager getInstance] letGetRange];
        });
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [dataHttpManager getInstance].delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [dataHttpManager getInstance].delegate =  nil;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    }
    return [dataHttpManager getInstance].rangeDic.count;
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
    
    if(indexPath.section == 0){
        cell.textLabel.text = @"当前可视范围";
    }else{
        cell.textLabel.text = [[dataHttpManager getInstance].rangeDic.allKeys objectAtIndex:indexPath.row];
    }
    
    if([cell.textLabel.text isEqualToString:[dataHttpManager getInstance].cache.range]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7;
    return cell;
}

- (void)didGetFailed{
    ALERT(@"获取行政区划失败");
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        [dataHttpManager getInstance].cache.range = @"当前可视范围";
        [dataHttpManager getInstance].cache.rangeBox = nil;
    }else{
        [dataHttpManager getInstance].cache.range = [[dataHttpManager getInstance].rangeDic.allKeys objectAtIndex:indexPath.row];
        [dataHttpManager getInstance].cache.rangeBox = [[dataHttpManager getInstance].rangeDic objectForKey:[dataHttpManager getInstance].cache.range];
    }
    [tableView reloadData];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)didGetRange:(NSMutableDictionary *)rangeDic{
    [SVProgressHUD dismiss];
    [dataHttpManager getInstance].rangeDic = [NSDictionary dictionaryWithDictionary:rangeDic];
    [self.tableView reloadData];
}

@end
