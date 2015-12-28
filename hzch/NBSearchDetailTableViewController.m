//
//  NBSearchDetailTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/3.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBSearchDetailTableViewController.h"
#import "NBSearch.h"
#import "NBSearchCatalog.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
#import "mapViewController.h"
#import "NBSearchCatalogDetailTableViewController.h"
#import "SqliteDetailTableViewController.h"
@interface NBSearchDetailTableViewController ()<dataHttpDelegate>{
    int page;
    int pageSize;
    int allCount;
    NSInteger tableID;
}
@end

@implementation NBSearchDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    pageSize = 15;
    self.showMapItem.enabled = NO;
    [self doSearch:self.keyword];
    self.title = self.keyword;
    if(self.searchType == 2){
        self.toolBar.hidden = YES;
    }
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
    if(_searchType == 0){
        NBSearch *search = [results objectAtIndex:indexPath.row];
        title = search.name;
        detail = search.address;
    }
    if(_searchType == 1){
        NBSearchCatalog *catalog = [results objectAtIndex:indexPath.row];
        if(catalog.name.length > 0){
            title = catalog.name;
        }else{
            for(NSString *key in catalog.catalogDic.allKeys){
                if([[key lowercaseString] containsString:@"name"]){
                    title = [catalog.catalogDic objectForKey:key];
                    break;
                }
            }
        }
        detail = catalog.address;
    }
    if(_searchType == 2){
        NSDictionary *dic = [results objectAtIndex:indexPath.row];
        title = [dic objectForKey:@"NAME"]?[dic objectForKey:@"NAME"]:[dic objectForKey:@"FNAME"];
        detail = [dic objectForKey:@"ADDRESS"]?[dic objectForKey:@"ADDRESS"]:[dic objectForKey:@"COUNTRY"];
    }
    
    static NSString *FirstLevelCell = @"NBSearch";
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
    cell.textLabel.minimumScaleFactor = 0.7;
    cell.detailTextLabel.text = detail;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.minimumScaleFactor = 0.7;
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
- (void)didGetSearch:(NSMutableDictionary *)searchDic{
    [SVProgressHUD dismiss];
    if([[searchDic objectForKey:@"results"] count] > 0){
        self.showMapItem.enabled = YES;
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
        ALERT(@"请求数据为空");
         [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didgetSearchCatalog:(NSMutableDictionary *)searchDic{
    [SVProgressHUD dismiss];
    if([[searchDic objectForKey:@"results"] count] > 0){
        self.showMapItem.enabled = YES;
        allCount = [[searchDic objectForKey:@"totalCount"] intValue];
        allCount = ceil(allCount / (pageSize*1.000));
        self.countItem.title = [NSString stringWithFormat:@"第%d页／共%d页",page,allCount];
        self.resultDic = searchDic;
        tableID = [[searchDic objectForKey:@"tableid"] integerValue];
//        [dataHttpManager getInstance].tableID = tableID;
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

- (void)didgetSearchSqlite:(NSMutableDictionary *)searchDic{
    [SVProgressHUD dismiss];
    if([[searchDic objectForKey:@"results"] count] > 0){
        self.showMapItem.enabled = YES;
        self.resultDic = searchDic;
        self.toolBar.hidden = YES;
        [self.tableView reloadData];
    }else{
        self.toolBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)doSearch:(NSString *)keyword{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    if(![self hasKeyword:keyword]){
        [self.keywordList addObject:keyword];
    }
    [self.tableView reloadData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *key = SEARCH_KEY_WORD;
        if(_searchType == 0){
            key = SEARCH_KEY_WORD;
            [[dataHttpManager getInstance] letGetSearch:keyword page:page pageSize:pageSize];
        }
        if(_searchType == 1){
            key = SEARCH_CATALOG;
            [[dataHttpManager getInstance] letGetSearchCatalog:keyword page:page pageSize:pageSize];
        }
        if(_searchType == 2){
            key = SEARCH_DOWNLOAD;
            [[dataHttpManager getInstance] letGetSearchSqlite:keyword];
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.keywordList forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    
}

- (BOOL)hasKeyword:(NSString *)key{
    for(NSString *word in self.keywordList){
        if([word isEqualToString:key]){
            return YES;
        }
    }
    return NO;
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
        [self doSearch:self.keyword];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_searchType == 1){
        NSArray *results = [_resultDic objectForKey:@"results"];
        NBSearchCatalog *catalog = [results objectAtIndex:indexPath.row];
    }
//    if(_searchType == 2){
//        NSArray *results = [_resultDic objectForKey:@"results"];
//        NSDictionary *dic =[results objectAtIndex:indexPath.row];
//        [dataHttpManager getInstance].sqliteCalloutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
//        for(NSString *key in dic.allKeys){
//            if([dic objectForKey:key] == nil || [dic objectForKey:key] == [NSNull null])
//            {
//                [[dataHttpManager getInstance].sqliteCalloutDic removeObjectForKey:key];
//            }else{
//                if([[dic objectForKey:key] isKindOfClass:[NSString class]]){
//                    NSString *value = [dic objectForKey:key];
//                    if([value stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0 || [value isEqualToString:@"<null>"]){
//                        [[dataHttpManager getInstance].sqliteCalloutDic removeObjectForKey:key];
//                    }
//                }
//                if([key isEqualToString:@"GEOJSON"] || [key isEqualToString:@"Geometry"]
//                   || [key isEqualToString:@"type"]|| [key isEqualToString:@"title"]|| [key isEqualToString:@"detail"]|| [key isEqualToString:@"FeatureGUI"]|| [key isEqualToString:@"updatestat"]|| [key isEqualToString:@"PK_UID"]){
//                    [[dataHttpManager getInstance].sqliteCalloutDic removeObjectForKey:key];
//                }
//            }
//        }
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        SqliteDetailTableViewController *sqliteViewContoller = [storyboard instantiateViewControllerWithIdentifier:@"SqliteDetailTableViewController"];
//        sqliteViewContoller.isPush = YES;
//        [self.navigationController pushViewController:sqliteViewContoller animated:YES];
//    }
    [self showMap:indexPath.row];
}

-(IBAction)showInMap:(id)sender{
    [self showMap:0];
}

- (void)showMap:(NSInteger)index{
    NSArray *results = [_resultDic objectForKey:@"results"];
    if([results count] > 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_POINTS_ON_MAP" object:nil userInfo:@{@"results":results,@"searchType":@(_searchType),@"index":@(index)}];
        
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
