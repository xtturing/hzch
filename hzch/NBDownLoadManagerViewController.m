//
//  NBDownLoadManagerViewController.m
//  tdtnb
//
//  Created by xtturing on 14-7-31.
//  Copyright (c) 2014年 xtturing. All rights reserved.
//

#import "NBDownLoadManagerViewController.h"
#import "dataHttpManager.h"
#import "NBTpk.h"
#import "NBSpatialData.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "DownloadManager.h"
#import "DowningCell.h"
#import "Utility.h"
#import "myDrawTableViewCell.h"
@interface NBDownLoadManagerViewController ()<dataHttpDelegate>{
   
}
@property (nonatomic ,strong) NSMutableDictionary *downlist;
@property (nonatomic ,strong) NSMutableDictionary *tpkList;
@property (nonatomic ,strong) NSMutableDictionary *dataList;
@end

@implementation NBDownLoadManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[dataHttpManager getInstance] letLoadTPK];
    });
    [_segment addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"RELOADTABLE" object:nil];
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)reload{
    self.downlist = [[DownloadManager sharedInstance]getFinishedTask];
    [self.table performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    [self.table reloadData];
}
- (void)didGetFailed{
    [SVProgressHUD dismiss];
    ALERT(@"请求失败，请确认网络连接");
}

-(void)didLoadTPK:(NSMutableDictionary *)Dic{
    [SVProgressHUD dismiss];
    NSArray *tpks = [Dic objectForKey:@"tpk"];
    NSArray *datas = [Dic objectForKey:@"data"];
    self.dataList = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.tpkList = [[NSMutableDictionary alloc] initWithCapacity:0];
    for(NBTpk *tpk in tpks){
        DownloadItem *downItem=[[DownloadItem alloc] init];
        downItem.tpk = tpk;
        NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",tpk.url]];
        downItem.url=url;
        DownloadItem *task=[[DownloadManager sharedInstance] getDownloadItemByUrl:[downItem.url description]];
        downItem.downloadPercent=task.downloadPercent;
        if(task)
        {
            downItem.downloadState=task.downloadState;
        }
        else
        {
            downItem.downloadState=DownloadNotStart;
        }
        [self.tpkList setObject:downItem forKey:[downItem.url description]];
    }
    for(NBSpatialData *data in datas){
        DownloadItem *downItem=[[DownloadItem alloc] init];
        downItem.data = data;
        NSURL  *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",data.url]];
        downItem.url=url;
        DownloadItem *task=[[DownloadManager sharedInstance] getDownloadItemByUrl:[downItem.url description]];
        downItem.downloadPercent=task.downloadPercent;
        if(task)
        {
            downItem.downloadState=task.downloadState;
        }
        else
        {
            downItem.downloadState=DownloadNotStart;
        }
        [self.dataList setObject:downItem forKey:[downItem.url description]];
    }
    self.downlist = [[DownloadManager sharedInstance]getFinishedTask];
    [self.table reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *urlKey = [self.downlist.allKeys objectAtIndex:indexPath.row];
    DownloadItem *findItem=[_tpkList objectForKey:urlKey];
    NSString *name = nil;
    if(findItem==nil)
    {
        findItem=[_dataList objectForKey:urlKey];
        name = findItem.data.note;
    }else{
        name = findItem.tpk.content;
    }
    static NSString *FirstLevelCell = @"downLoadCell";
    myDrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 FirstLevelCell];
    if (cell == nil) {
        cell = [[myDrawTableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    cell.titleLab.text = name;
    cell.type = 1;
    cell.layerUrl = urlKey;
    cell.editBtn.hidden = YES;
    cell.titleLab.adjustsFontSizeToFitWidth = YES;
    if([self hasAddLocalLayer:urlKey]){
        [cell.showBtn setImage:[UIImage imageNamed:@"show_normal"] forState:UIControlStateNormal];
    }else{
        [cell.showBtn setImage:[UIImage imageNamed:@"hidden_normal"] forState:UIControlStateNormal];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.downlist count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (BOOL)hasAddLocalLayer:(NSString *)name{
    for(NSString *layerurl in [dataHttpManager getInstance].localLayers){
        if([layerurl isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}
@end
