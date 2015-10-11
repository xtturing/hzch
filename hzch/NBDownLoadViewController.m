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

@property (nonatomic ,strong) NSArray *tpkList;
@property (nonatomic ,strong) NSArray *dataList;
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

- (void)downloadManager{
    NBDownLoadManagerViewController *manager = [[NBDownLoadManagerViewController alloc]initWithNibName:@"NBDownLoadManagerViewController" bundle:nil];
//     manager.tpkList = _tpkList;
    manager.layers =self.layers;
    [self.navigationController pushViewController:manager animated:YES];
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
    self.tpkList = [Dic objectForKey:@"tpk"];
    self.dataList = [Dic objectForKey:@"data"];
    [self.table reloadData];
}

-(void)downloadNotification:(NSNotification *)notif
{
    DownloadItem *notifItem=notif.object;
    //    NSLog(@"%@,%d,%f",notifItem.url,notifItem.downloadState,notifItem.downloadPercent);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = nil;
    NSString *content = nil;
    NSString *url = nil;
    NSString *date = nil;
    if(indexPath.section == 0){
        NBTpk *tpk = [self.tpkList objectAtIndex:indexPath.row];
        name = tpk.content;
        content = tpk.news;
        url = [NSString stringWithFormat:@"http://%@",tpk.url];
        date = tpk.updatetime;
    }else{
        NBSpatialData *data = [self.dataList objectAtIndex:indexPath.row];
        name = data.note;
        content = data.news;
        url = [NSString stringWithFormat:@"http://%@",data.url];
        date = data.updatetime;
    }
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
            NSString *desPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:name];
            [[DownloadManager sharedInstance]startDownload:url withLocalPath:desPath];
        };
        cell.DowningCellCancelClick=^(DowningCell *cell)
        {
            [[DownloadManager sharedInstance]cancelDownload:url];
        };
    }
    cell.lblTitle.text=name;
    cell.lblPercent.text = content;
    [cell.btnOperate setTitle:date forState:UIControlStateNormal];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DowningCell *cell=(DowningCell *)[self.table cellForRowAtIndexPath:indexPath];
//    DownloadItem *downItem = [_tpkList.allValues objectAtIndex:indexPath.row];
//    if([cell.btnOperate.titleLabel.text isEqualToString:@"下载完成"] && downItem.downloadPercent == 1){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"addLocalTileLayer" object:nil userInfo:[NSDictionary dictionaryWithObject:[[[downItem.url description] componentsSeparatedByString:@"="] objectAtIndex:1] forKey:@"name"]];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }else if([cell.btnOperate.titleLabel.text isEqualToString:@"已加载"]){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeLocalTileLayer" object:nil userInfo:[NSDictionary dictionaryWithObject:[[[downItem.url description] componentsSeparatedByString:@"="] objectAtIndex:1] forKey:@"name"]];
//        [self.table reloadData];
//    }else{
//        [self downloadManager];
//    }
}

- (BOOL)hasAddLocalLayer:(NSString *)name{
    if(self.layers == nil || self.layers.count == 0){
        return NO;
    }
    for(AGSTiledLayer *layer in self.layers){
        if([layer isKindOfClass:[AGSLocalTiledLayer class]] && [layer.name isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}


@end
