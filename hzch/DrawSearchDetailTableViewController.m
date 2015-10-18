//
//  DrawSearchDetailTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/18.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "DrawSearchDetailTableViewController.h"
#import "NBSearchCatalog.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
#import "mapViewController.h"
#import "NBSearchCatalogDetailTableViewController.h"
@interface DrawSearchDetailTableViewController ()<dataHttpDelegate>{
    int page;
    int pageSize;
    int allCount;
    NSInteger tableID;
}

@end

@implementation DrawSearchDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    pageSize = 15;
    [self doSearch];
    self.navigationItem.backBarButtonItem.title = @"返回";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [dataHttpManager getInstance].delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [dataHttpManager getInstance].delegate =  nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_resultDic objectForKey:@"results"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title= nil;
    NSString *detail = nil;
    NSArray *results = [_resultDic objectForKey:@"results"];
    NBSearchCatalog *catalog = [results objectAtIndex:indexPath.row];
    title = catalog.name;
    detail = catalog.address;
    static NSString *FirstLevelCell = @"NBSearchCatalog";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = title;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = detail;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (void)didGetFailed{
    [SVProgressHUD dismiss];
    ALERT(@"请求失败，请确认网络连接");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didGetTableIDFailed{
    [SVProgressHUD dismiss];
    ALERT(@"没有可以查询的图层或图层数大于1");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didGetDraw:(NSMutableDictionary *)searchDic{
    [SVProgressHUD dismiss];
    if([[searchDic objectForKey:@"results"] count] > 0){
        self.showMapItem.enabled = YES;
        tableID = [[searchDic objectForKey:@"tableid"] integerValue];
        allCount = [[searchDic objectForKey:@"totalCount"] intValue];
        allCount = ceil(allCount / (pageSize*1.000));
        self.countItem.title = [NSString stringWithFormat:@"第%d页／共%d页",page,allCount];
        self.resultDic = searchDic;
        self.toolBar.hidden = NO;
        if(page > 1){
            self.preItem.enabled = YES;
        }else{
            self.preItem.enabled = NO;
        }
        if(page >= allCount){
            self.nextItem.enabled = NO;
        }else{
            self.nextItem.enabled = YES;
        }
        [self.tableView reloadData];
    }else{
        self.toolBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)doSearch{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.tableView reloadData];
    NSArray *array = [dataHttpManager getInstance].drawPoints;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[dataHttpManager getInstance] doTouchDrawSearchMinx:[[array objectAtIndex:0] doubleValue] miny:[[array objectAtIndex:1] doubleValue] maxx:[[array objectAtIndex:2] doubleValue] maxy:[[array objectAtIndex:3] doubleValue] page:page pageSize:pageSize];
    });
}

-(IBAction)toolbarAction:(id)sender{
    UIBarButtonItem *btnItem = (UIBarButtonItem *)sender;
    if(btnItem.tag == 5001){
        page -=1;
    }
    if(btnItem.tag == 5003){
        page +=1;
    }
    if(page > 0 && page <= allCount){
        [self doSearch];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *results = [_resultDic objectForKey:@"results"];
    NBSearchCatalog *catalog = [results objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NBSearchCatalogDetailTableViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"NBSearchCatalogDetailTableViewController"];
    mapViewController.catalog = catalog;
    mapViewController.tableID = tableID;
    [self.navigationController pushViewController:mapViewController animated:YES];
}

-(IBAction)showInMap:(id)sender{
    NSArray *results = [_resultDic objectForKey:@"results"];
    if([results count] > 0){
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        mapViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
//        mapViewController.resultList = results;
//        mapViewController.searchType = 1;
//        [self.navigationController pushViewController:mapViewController animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_POINTS_ON_MAP" object:nil userInfo:@{@"results":results,@"searchType":@(1)}];
    }
}

@end
