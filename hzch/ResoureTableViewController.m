//
//  ResoureTableViewController.m
//  hzch
//
//  Created by xtturing on 15/9/29.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "ResoureTableViewController.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
#import "NBDepartMent.h"
#import "NBGovment.h"
#import "ResoureDetailTableViewController.h"

@interface ResoureTableViewController ()<dataHttpDelegate>
@property (nonatomic,strong) NSArray *departmentList;
@property (nonatomic,strong) NSArray *govmentList;
@property (nonatomic) NSInteger showType;
@end

@implementation ResoureTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.showType = 0;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[dataHttpManager getInstance] letGetCatalogDepartment];
        [[dataHttpManager getInstance] letGetCatalogGovment];
    });
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)segmentControl:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    self.showType = segment.selectedSegmentIndex;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_showType == 0){
        return [_departmentList count];
    }else{
        return [_govmentList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = nil;
    if(_showType == 0){
        NBDepartMent *depart = [_departmentList objectAtIndex:indexPath.row];
        title = depart.NAME;
    }else{
        NBGovment *gov = [_govmentList objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResoureDetailTableViewController *detailViewController = [[ResoureDetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    detailViewController.showType =self.showType;
    if(_showType == 0){
        NBDepartMent *depart = [_departmentList objectAtIndex:indexPath.row];
        detailViewController.catalogID = depart.CATALOGID;
        detailViewController.titleName = depart.NAME;
    }else{
        NBGovment *gov = [_govmentList objectAtIndex:indexPath.row];
        detailViewController.catalogID = gov.CATALOGID;
        detailViewController.titleName = gov.NAME;
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didGetFailed{
    [SVProgressHUD dismiss];
}

- (void)didGetCatalogDepartment:(NSArray *)departmentList{
    [SVProgressHUD dismiss];
    self.departmentList = departmentList;
    if(self.showType == 0){
        [self.tableView reloadData];
    }
}

- (void)didGetCatalogGovment:(NSArray *)govmentList{
    [SVProgressHUD dismiss];
    self.govmentList = govmentList;
    if(self.showType == 1){
        [self.tableView reloadData];
    }
}


@end
