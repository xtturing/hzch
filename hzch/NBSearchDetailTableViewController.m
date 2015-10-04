//
//  NBSearchDetailTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/3.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBSearchDetailTableViewController.h"
#import "NBSearch.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
@interface NBSearchDetailTableViewController ()<dataHttpDelegate>{
    int page;
    int pageSize;
    NSInteger allCount;
}
@end

@implementation NBSearchDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    pageSize = 15;
    [self doSearch:self.keyword];
    self.title = self.keyword;
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
    NSArray *results = [_resultDic objectForKey:@"results"];
    NBSearch *search = [results objectAtIndex:indexPath.row];
    
    static NSString *FirstLevelCell = @"NBSearch";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = search.name;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = search.address;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (void)didGetFailed{
    [SVProgressHUD dismiss];
}
- (void)didGetSearch:(NSMutableDictionary *)searchDic{
    [SVProgressHUD dismiss];
    if([[searchDic objectForKey:@"results"] count] > 0){
        self.resultDic = searchDic;
        self.toolBar.hidden = NO;
        [self.tableView reloadData];
    }else{
        self.toolBar.hidden = YES;
    }
}

- (void)doSearch:(NSString *)keyword{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    if(![self hasKeyword:keyword]){
        [self.keywordList addObject:keyword];
    }
    [self.tableView reloadData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[dataHttpManager getInstance] letGetSearch:keyword page:page pageSize:pageSize];
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


@end
