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
    if(_showType == 0){
        NBDepartMent *depart = [_detailList objectAtIndex:indexPath.row];
        title = depart.NAME;
        ctype = depart.CTYPE;
        wmsurl = depart.WMS;
        wmtsurl = depart.WMTS;
        NSLog(@"++++++++++++++%@",wmsurl);
    }else{
        NBGovment *gov = [_detailList objectAtIndex:indexPath.row];
        title = gov.NAME;
        ctype = gov.CTYPE;
        wmsurl = gov.WMS;
        wmtsurl = gov.WMTS;
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
        [eyeButton setImage:[UIImage imageNamed:@"show_normal"] forState:UIControlStateNormal];
        [eyeButton setImage:[UIImage imageNamed:@"show_click"] forState:UIControlStateSelected];
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
    if(_showType == 0){
        NBDepartMent *depart = [_detailList objectAtIndex:index];
        wmtsname = depart.CCODE;
        wmtsurl = depart.WMTS;
    }else{
        NBGovment *gov = [_detailList objectAtIndex:index];
        wmtsname = gov.CCODE;
        wmtsurl = gov.WMTS;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_WMTS_LAYER_ON_MAP" object:nil userInfo:@{@"wmtsurl":wmtsurl,@"wmtsname":wmtsname,}];
    ALERT(@"已添加到地图");

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
