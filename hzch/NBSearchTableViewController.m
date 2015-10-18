//
//  NBSearchTableViewController.m
//  hzch
//
//  Created by xtturing on 15/9/29.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBSearchTableViewController.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
#import "NBSearchDetailTableViewController.h"

@interface NBSearchTableViewController ()<dataHttpDelegate>

@property(nonatomic,strong) NSMutableArray *keywordList;
@property(nonatomic,assign) NSInteger searchType;

@end

@implementation NBSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchType = 0;
    self.title = @"返回";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadSearchList];
    [dataHttpManager getInstance].delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [dataHttpManager getInstance].delegate =  nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)doBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)segmentControl:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    self.searchType = segment.selectedSegmentIndex;
    [self loadSearchList];
    [self.tableView reloadData];
}

- (void)loadSearchList{
    NSArray *array = nil;
    if(_searchType == 0){
       array = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_KEY_WORD];
       self.searchBar.placeholder = @"请输入地名地址，行政区划等关键字";
    }
    if(_searchType == 1){
        array = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_CATALOG];
        self.searchBar.placeholder = @"请输入专题资源关键字";
    }
    if(_searchType == 2){
        array = [[NSUserDefaults standardUserDefaults] objectForKey:SEARCH_DOWNLOAD];
        self.searchBar.placeholder = @"请输入离线数据关键字";
    }
    if(array){
        self.keywordList = [NSMutableArray arrayWithArray:array];
    }else{
         _keywordList = [NSMutableArray arrayWithCapacity:0];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return [self.keywordList count];
    }
    if(section == 1 && [self.keywordList count] > 0){
        return 1;
    }
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0 && [self.keywordList count] > 0){
        return @"查询记录";
    }
    return @"";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        static NSString *FirstLevelCell = @"NBClearKeyWord";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 FirstLevelCell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue2
                    reuseIdentifier: FirstLevelCell];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"清空所有查询记录";
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        return cell;
    }else{
        NSString *title = nil;
        title = [self.keywordList objectAtIndex:indexPath.row];
        static NSString *FirstLevelCell = @"NBDepartMent";
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
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        [self deleteAllSearch];
    }else{
        [self pushSearchView:[self.keywordList objectAtIndex:indexPath.row]];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self pushSearchView:searchBar.text];
}

- (void)pushSearchView:(NSString *)searchtext{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NBSearchDetailTableViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"NBSearchDetailTableViewController"];
    detailViewController.keyword = searchtext;
    detailViewController.searchType = self.searchType;
    detailViewController.keywordList = self.keywordList;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)deleteAllSearch{
    NSString *key = SEARCH_KEY_WORD;
    if(_searchType == 0){
        key = SEARCH_KEY_WORD;
    }
    if(_searchType == 1){
        key = SEARCH_CATALOG;
    }
    if(_searchType == 2){
        key = SEARCH_DOWNLOAD;
    }
    [self.keywordList removeAllObjects];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}
@end
