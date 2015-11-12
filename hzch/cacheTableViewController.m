//
//  cacheTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/8.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "cacheTableViewController.h"
#import "myDrawTableViewCell.h"
#import "dataHttpManager.h"
#import "DBCache.h"

@interface cacheTableViewController ()

@property (nonatomic,strong) NSArray *cacheList;

@end

@implementation cacheTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"地图缓存管理";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"RELOADTABLE" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.cacheList = [[dataHttpManager getInstance].cacheDB getAllCache];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reload{
    self.cacheList = [[dataHttpManager getInstance].cacheDB getAllCache];
    [dataHttpManager getInstance].cacheList = self.cacheList;
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cacheList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FirstLevelCell = @"cacheCell";
    DBCache *cache = (DBCache *)[self.cacheList objectAtIndex:indexPath.row];
    myDrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 FirstLevelCell];
    if (cell == nil) {
        cell = [[myDrawTableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text = cache.name;
    if(cache.isShow){
        [cell.showBtn setImage:[UIImage imageNamed:@"show_normal"] forState:UIControlStateNormal];
    }else{
        [cell.showBtn setImage:[UIImage imageNamed:@"hidden_normal"] forState:UIControlStateNormal];
    }
    cell.type = 3;
    cell.cache = cache;
    cell.titleLab.adjustsFontSizeToFitWidth = YES;
    return cell;
}

@end
