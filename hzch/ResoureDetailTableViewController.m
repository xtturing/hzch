//
//  ResoureDetailTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/2.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "ResoureDetailTableViewController.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
#import "NBDepartMent.h"
#import "NBGovment.h"

@interface ResoureDetailTableViewController ()<dataHttpDelegate>
@property (nonatomic,strong) NSArray *detailList;
@end

@implementation ResoureDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(self.showType == 0){
            [[dataHttpManager getInstance] letGetCatalogDepartmentDetail:self.catalogID];
        }else{
            [[dataHttpManager getInstance]  letGetCatalogGovmentDetail:self.catalogID];
        }
    });
    self.title = self.titleName;
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
    return [_detailList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = nil;
    if(_showType == 0){
        NBDepartMent *depart = [_detailList objectAtIndex:indexPath.row];
        title = depart.NAME;
    }else{
        NBGovment *gov = [_detailList objectAtIndex:indexPath.row];
        title = gov.NAME;
    }
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

- (void)didGetFailed{
    [SVProgressHUD dismiss];
}

- (void)didGetCatalogDepartmentDetail:(NSArray *)departmentDetailList{
    [SVProgressHUD dismiss];
    self.detailList = departmentDetailList;
    [self.tableView reloadData];
}

- (void)didGetCatalogGovmentDetail:(NSArray *)govmentDetailList{
    [SVProgressHUD dismiss];
    self.detailList = govmentDetailList;
    [self.tableView reloadData];
}


@end
