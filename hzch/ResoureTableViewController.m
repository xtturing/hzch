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
    NSString *detail = nil;
    if(_showType == 0){
        NBDepartMent *depart = [_departmentList objectAtIndex:indexPath.row];
        title = depart.NAME;
        detail = [NSString stringWithFormat:@"%ld",(long)depart.CATALOGID];
    }else{
        title = [_govmentList objectAtIndex:indexPath.row];
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
    cell.detailTextLabel.text = detail;
    
    return cell;
}


- (void)didGetFailed{
    [SVProgressHUD dismiss];
}

- (void)didGetCatalogDepartment:(NSArray *)departmentList{
    [SVProgressHUD dismiss];
    self.departmentList = departmentList;
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
