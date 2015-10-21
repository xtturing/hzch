//
//  NBDownLoadViewController.m
//  tdtnb
//
//  Created by xtturing on 14-7-31.
//  Copyright (c) 2014年 xtturing. All rights reserved.
//

#import "NBDownLoadViewController.h"
#import "NBDownLoadManagerViewController.h"
#import "dataHttpManager.h"
#import "NBTpk.h"
#import "NBSpatialData.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "DownloadManager.h"
#import "DowningCell.h"
#import "Utility.h"

@interface NBDownLoadViewController ()<dataHttpDelegate>

@property (nonatomic ,strong) NSMutableDictionary *tpkList;
@property (nonatomic ,strong) NSMutableDictionary *dataList;
- (IBAction)doBack:(id)sender;
@end

@implementation NBDownLoadViewController

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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[dataHttpManager getInstance] letLoadTPK];
    });
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadNotification:) name:kDownloadManagerNotification object:nil];
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
- (IBAction)doBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.table reloadData];
}

-(void)updateCell:(DowningCell *)cell withDownItem:(DownloadItem *)downItem withIndexPath:(NSIndexPath *)indexPath
{
    DownloadItem *findItem = nil;
    if(indexPath.section == 0){
        findItem=[_tpkList objectForKey:[downItem.url description]];
        cell.lblTitle.text=[findItem.tpk.content description];
    }else{
        findItem=[_dataList objectForKey:[downItem.url description]];
        cell.lblTitle.text=[findItem.data.note description];
    }
    cell.lblPercent.text=[NSString stringWithFormat:@"下载进度:%0.2f%@",downItem.downloadPercent*100,@"%"];
    [cell.btnOperate setTitle:downItem.downloadStateDescription forState:UIControlStateNormal];
}
-(void)updateUIByDownloadItem:(DownloadItem *)downItem
{
    DownloadItem *findItem=[_tpkList objectForKey:[downItem.url description]];
    NSInteger section = 0;
    NSInteger index= 0;
    if(findItem==nil)
    {
        findItem=[_dataList objectForKey:[downItem.url description]];
        if(findItem == nil){
            return;
        }
        index=[_dataList.allKeys indexOfObject:[downItem.url description]];
        section = 1;
    }else{
        index=[_tpkList.allKeys indexOfObject:[downItem.url description]];
    }
    findItem.downloadStateDescription=downItem.downloadStateDescription;
    findItem.downloadPercent=downItem.downloadPercent;
    findItem.downloadState=downItem.downloadState;
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:section];
    DowningCell *cell=(DowningCell *)[self.table cellForRowAtIndexPath:path];
    [self updateCell:cell withDownItem:downItem withIndexPath:path];
}

-(void)downloadNotification:(NSNotification *)notif
{
    DownloadItem *notifItem=notif.object;
    [self updateUIByDownloadItem:notifItem];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadItem *downItem = nil;
    NSString *url= nil;
    NSString *name = nil;
    if(indexPath.section == 0){
        downItem = [_tpkList.allValues objectAtIndex:indexPath.row];
    }else{
        downItem = [_dataList.allValues objectAtIndex:indexPath.row];
    }
    url=[downItem.url description];
    NSArray *array = [[downItem.url description] componentsSeparatedByString:@"/"];
    name = [array objectAtIndex:(array.count-1)];
    static NSString *cellIdentity=@"DowningCell";
    DowningCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"DowningCell" owner:self options:nil] lastObject];
        cell.DowningCellOperateClick=^(DowningCell *cell){
            
            if([[DownloadManager sharedInstance]isExistInDowningQueue:url])
            {
                [[DownloadManager sharedInstance]pauseDownload:url];
                return;
            }
            NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *desPath=[[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"] stringByAppendingPathComponent:name];
            [[DownloadManager sharedInstance]startDownload:url withLocalPath:desPath];
        };
        cell.DowningCellCancelClick=^(DowningCell *cell)
        {
            [[DownloadManager sharedInstance]cancelDownload:url];
            if([self hasAddLocalLayer:url]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_LOCAL_LAYER" object:nil userInfo:@{@"localurl":url}];
            }
        };
    }
    [self updateCell:cell withDownItem:downItem withIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [_tpkList count];
    }else{
        return [_dataList count];
    }
    
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
