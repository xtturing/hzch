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
    NSInteger ctype = 0;
    NSString *wmsurl = nil;
    NSString *wmtsurl = nil;
    NSString *wmtsname = nil;
    NSString *wmtsID = nil;
    if(_showType == 0){
        NBDepartMent *depart = [_detailList objectAtIndex:indexPath.row];
        title = depart.NAME;
        ctype = depart.CTYPE;
        wmsurl = depart.WMS;
        wmtsurl = depart.WMTS;
        wmtsname = depart.CCODE;
        wmtsID = [NSString stringWithFormat:@"%ld",(long)depart.CATALOGID];
    }else{
        NBGovment *gov = [_detailList objectAtIndex:indexPath.row];
        title = gov.NAME;
        ctype = gov.CTYPE;
        wmsurl = gov.WMS;
        wmtsurl = gov.WMTS;
        wmtsname = gov.CCODE;
        wmtsID = [NSString stringWithFormat:@"%ld",(long)gov.CATALOGID];
    }
    static NSString *FirstLevelCell = @"NBDepartMent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    if(ctype == 4 && (wmsurl.length > 0 || wmsurl.length > 0)){
        UIButton *eyeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        if([self hasInMapLayerName:wmtsID]){
            [eyeButton setImage:[UIImage imageNamed:@"show_normal"] forState:UIControlStateNormal];
        }else{
            [eyeButton setImage:[UIImage imageNamed:@"hidden_normal"] forState:UIControlStateNormal];
        }
        eyeButton.tag = indexPath.row;
        [eyeButton addTarget:self action:@selector(showLayerInMap:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = eyeButton;
    }else{
        cell.accessoryView = nil;
    }
    
    cell.textLabel.text = title;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (BOOL)hasInMapLayerName:(NSString *)name{
    for(NSString *layerName in [dataHttpManager getInstance].resourceLayers.allKeys){
        if([layerName isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self addlayerIndex:indexPath.row];
}

- (void)showLayerInMap:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [self addlayerIndex:btn.tag];
}

- (void)addlayerIndex:(NSInteger)index{
    NSString *wmtsname = nil;
    NSString *wmtsurl = nil;
    NSString *wmtsID = nil;
    NSString *name = nil;
    if(_showType == 0){
        NBDepartMent *depart = [_detailList objectAtIndex:index];
        wmtsname = depart.CCODE;
        wmtsurl = depart.WMTS;
        wmtsID = [NSString stringWithFormat:@"%ld",(long)depart.CATALOGID];
        name = depart.NAME;
    }else{
        NBGovment *gov = [_detailList objectAtIndex:index];
        wmtsname = gov.CCODE;
        wmtsurl = gov.WMTS;
        wmtsID = [NSString stringWithFormat:@"%ld",(long)gov.CATALOGID];
        name = gov.NAME;
    }
    if([self hasInMapLayerName:wmtsname]){
        UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        UIButton *btn = (UIButton *)cell.accessoryView;
        [btn setImage:[UIImage imageNamed:@"hidden_normal"] forState:UIControlStateNormal];
        ALERT(@"已从地图移除");
    }else{
        UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        UIButton *btn = (UIButton *)cell.accessoryView;
        [btn setImage:[UIImage imageNamed:@"show_normal"] forState:UIControlStateNormal];
        ALERT(@"已添加到地图");
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_WMTS_LAYER_ON_MAP" object:nil userInfo:@{@"wmtsurl":wmtsurl,@"wmtsname":wmtsname,@"wmtsID":wmtsID,@"name":name}];
    [self.tableView reloadData];

}
- (void)didGetFailed{
    [SVProgressHUD dismiss];
    ALERT(@"请求失败，请确认网络连接");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didGetCatalogDepartmentDetail:(NSArray *)departmentDetailList{
    [SVProgressHUD dismiss];
    if([departmentDetailList count] > 0){
        self.detailList = departmentDetailList;
        [self.tableView reloadData];
    }else{
        ALERT(@"请求数据为空");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didGetCatalogGovmentDetail:(NSArray *)govmentDetailList{
    [SVProgressHUD dismiss];
    if([govmentDetailList count] > 0){
        self.detailList = govmentDetailList;
        [self.tableView reloadData];
    }else{
        ALERT(@"请求数据为空");
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
