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
#import "SpatialDatabase.h"
@interface NBDownLoadManagerViewController ()<dataHttpDelegate>{
    sqlite3 *db;
}
@property (nonatomic ,strong) NSMutableDictionary *downTpklist;
@property (nonatomic ,strong) NSMutableDictionary *downDatalist;
@property (nonatomic ,strong) NSMutableDictionary *tpkList;
@property (nonatomic ,strong) NSMutableDictionary *dataList;
@property (nonatomic ,strong) NSMutableArray *dbArray;
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)reload{
    [self.downTpklist removeAllObjects];
    [self.downDatalist removeAllObjects];
    [self.dbArray removeAllObjects];
    for(DownloadItem *downItem in self.tpkList.allValues){
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
        if(downItem.downloadState == DownloadFinished){
            [self.downTpklist setObject:downItem forKey:[downItem.url description]];
        }
    }
    for(DownloadItem *downItem in self.dataList.allValues){
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
        if(downItem.downloadState == DownloadFinished){
            [self.downDatalist setObject:downItem forKey:[downItem.url description]];
        }
    }
    [self loadDataDB];
    [self.table performSelector:@selector(reloadData) withObject:nil afterDelay:2.0];
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
    self.downDatalist = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.downTpklist = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.dbArray = [[NSMutableArray alloc] initWithCapacity:0];
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
        if(downItem.downloadState == DownloadFinished){
            [self.downTpklist setObject:downItem forKey:[downItem.url description]];
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
        if(downItem.downloadState == DownloadFinished){
            [self.downDatalist setObject:downItem forKey:[downItem.url description]];
        }
        [self.dataList setObject:downItem forKey:[downItem.url description]];
    }
    [self loadDataDB];
    [self.table reloadData];
}

- (void)loadDataDB{
    for(NSString *downItemurl in self.downDatalist.allKeys){
        NSArray *array = [downItemurl componentsSeparatedByString:@"/"];
        NSString *name = [array objectAtIndex:(array.count-1)];
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *desPath=[[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"] stringByAppendingPathComponent:name];
        if([[name pathExtension] isEqualToString:@"sqlite"]){
            SpatialDatabase *db = [SpatialDatabase databaseWithPath:desPath];
            [db open];
            FMResultSet *rs = [db executeQuery:@"SELECT * FROM geometry_columns"];
            NSDictionary *column = nil;
            while ([rs next]) {
                column = [rs resultDictionary];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:column];
                [dic setObject:downItemurl forKey:@"url"];
                [self.dbArray addObject:dic];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *urlKey = nil;
    DownloadItem *findItem=nil;
    NSString *name = nil;
    if(_segment.selectedSegmentIndex==0)
    {
        urlKey = [_downTpklist.allKeys objectAtIndex:indexPath.row];
        findItem=[_tpkList objectForKey:urlKey];
        name = findItem.tpk.content;
    }else{
        NSMutableDictionary *array =[_dbArray objectAtIndex:indexPath.row];
        urlKey = [array objectForKey:@"url"];
        findItem=[_dataList objectForKey:urlKey];
        name = [array objectForKey:@"f_table_name"];
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
    cell.layerUrl = urlKey;
    if(_segment.selectedSegmentIndex==0)
    {
        cell.type = 1;
        cell.editBtn.hidden = YES;
        if([self hasAddLocalLayer:urlKey]){
            [cell.showBtn setImage:[UIImage imageNamed:@"show_normal"] forState:UIControlStateNormal];
        }else{
            [cell.showBtn setImage:[UIImage imageNamed:@"hidden_normal"] forState:UIControlStateNormal];
        }
    }else{
        cell.type = 2;
        cell.editBtn.hidden = NO;
        cell.editSqlitBlock = ^(){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"yangshiTableViewController"] animated:YES];
        };
        if([self hasShowSqlit:name] && [self hasShowSqliteValue:urlKey]){
            [cell.showBtn setImage:[UIImage imageNamed:@"show_normal"] forState:UIControlStateNormal];
        }else{
            [cell.showBtn setImage:[UIImage imageNamed:@"hidden_normal"] forState:UIControlStateNormal];
        }
    }
    
    cell.titleLab.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_segment.selectedSegmentIndex == 0){
        return [self.downTpklist count];
    }
    return [self.dbArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (BOOL)hasShowSqlit:(NSString *)cellTag{
    for (id tag in [dataHttpManager getInstance].sqliteLayers.allKeys) {
        if([cellTag isEqualToString: tag]){
            return YES;
        }
    }
    return NO;
}
- (BOOL)hasShowSqliteValue:(NSString *)layerurl{
    for (id tag in [dataHttpManager getInstance].sqliteLayers.allValues) {
        if([layerurl isEqualToString: tag]){
            return YES;
        }
    }
    return NO;
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
