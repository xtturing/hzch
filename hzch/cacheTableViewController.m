//
//  cacheTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/8.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "cacheTableViewController.h"
#import "myDrawTableViewCell.h"
#import "dataHttpManager.h"
#import "DBCache.h"
#import "addCacheTableViewController.h"
@interface cacheTableViewController ()

@property (nonatomic,strong) NSArray *cacheList;

@end

@implementation cacheTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"地图缓存管理";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"RELOADTABLE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCell:) name:@"updateDownloadCache" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.cacheList = [[dataHttpManager getInstance].cacheDB getAllCache];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reload{
    self.cacheList = [[dataHttpManager getInstance].cacheDB getAllCache];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];
}

- (void)reloadCell:(NSNotification *)info{
    NSString *cacheName = [info.userInfo objectForKey:@"name"];
    for(NSInteger i = 0; i< self.cacheList.count; i++){
        DBCache *cache = [self.cacheList objectAtIndex:i];
        if([cache.name isEqualToString:cacheName]){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
                myDrawTableViewCell *cell = (myDrawTableViewCell *)[self.tableView cellForRowAtIndexPath:indexpath];
                NSInteger fin = [[[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"%@_%@",cache.name,@"FINISH"]] integerValue];
                NSInteger tot = [[[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"%@_%@",cache.name,@"TOTAL"]] integerValue];
                double num = (fin*1.0000/tot)*100.00;
                if(num > 0.00000001){
                    [cell.detailLab setText:[NSString stringWithFormat:@"已完成:%.8lf%@",num,@"%"]];
                }else{
                    [cell.detailLab setText:@""];
                }
            });
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cacheList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FirstLevelCell = @"cacheCell";
    DBCache *cache = (DBCache *)[self.cacheList objectAtIndex:indexPath.row];
    myDrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 FirstLevelCell];
    if (cell == nil) {
        cell = [[myDrawTableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text = cache.name;
    NSInteger fin = [[[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"%@_%@",cache.name,@"FINISH"]] integerValue];
    NSInteger tot = [[[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"%@_%@",cache.name,@"TOTAL"]] integerValue];
    double num = (fin*1.0000/tot)*100.00;
    if(num > 0.00000001){
        [cell.detailLab setText:[NSString stringWithFormat:@"(已完成:%.8lf%@)",num,@"%"]];
    }else{
        [cell.detailLab setText:@""];
    }
    if(cache.isShow){
        [cell.showBtn setImage:[UIImage imageNamed:@"show_normal"] forState:UIControlStateNormal];
    }else{
        [cell.showBtn setImage:[UIImage imageNamed:@"hidden_normal"] forState:UIControlStateNormal];
    }
    __weak typeof(self) weakSelf = self;
    cell.editSqlitBlock = ^(){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        addCacheTableViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"addCacheTableViewController"];
        mapViewController.cache = [weakSelf.cacheList objectAtIndex:indexPath.row];
        weakSelf.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [weakSelf.navigationController pushViewController:mapViewController animated:YES];
    };
    cell.type = 3;
    cell.cache = cache;
    cell.titleLab.adjustsFontSizeToFitWidth = YES;
    return cell;
}

@end
