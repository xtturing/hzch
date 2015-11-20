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
    self.title = @"返回";
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
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier: FirstLevelCell];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = title;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger catalogID  = 0;
    NSString *titlename = nil;
    if(_showType == 0){
        NBDepartMent *depart = [_departmentList objectAtIndex:indexPath.row];
        catalogID = depart.CATALOGID;
        titlename = depart.NAME;
    }else{
        NBGovment *gov = [_govmentList objectAtIndex:indexPath.row];
        catalogID = gov.CATALOGID;
        titlename = gov.NAME;
    }
    ResoureDetailTableViewController *detailViewController = [[ResoureDetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    detailViewController.showType =self.showType;
    detailViewController.catalogID = catalogID;
    detailViewController.titleName = titlename;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didGetFailed{
    [SVProgressHUD dismiss];
    ALERT(@"请求失败，请确认网络连接");
}

- (void)didGetCatalogDepartment:(NSArray *)departmentList{
    [SVProgressHUD dismiss];
    if(departmentList.count > 0){
        self.departmentList = departmentList;
        [self.tableView reloadData];
    }else{
        ALERT(@"请求数据为空");
    }
}

- (void)didGetCatalogGovment:(NSArray *)govmentList{
    [SVProgressHUD dismiss];
    if(govmentList.count > 0){
        self.govmentList = govmentList;
        [self.tableView reloadData];
    }else{
        ALERT(@"请求数据为空");
    }
}


@end
