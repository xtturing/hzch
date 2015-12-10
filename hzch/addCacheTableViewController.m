//
//  addCacheTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/8.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "addCacheTableViewController.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
#import "TianDiTuData.h"

@interface addCacheTableViewController (){
    BOOL _isAddCache;
}

@property (nonatomic,strong) NSArray *cacheList;
@property (nonatomic,strong) NSDictionary *layer;

@end

@implementation addCacheTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _layer = @{@"vec":@"中国电子地图",@"cva":@"中国电子地图注记",@"img":@"中国影像",@"cia":@"中国影像注记",@"zjemap":@"浙江电子地图",@"zjemapanno":@"浙江电子地图注记",@"imgmap":@"浙江影像",@"imgmap_lab":@"浙江影像注记"};
    if(!_cache){
        _cache = [[DBCache alloc]init];
        _cache.minLevel = 1;
        _cache.maxLevel = 20;
        _cache.layerName = @"vec";
        _cache.isShow = YES;
        _cache.range = @"当前可视范围";
        _cache.typeID = 0;
        _cache.rangeBox = nil;
        _isAddCache = YES;
        _cache.createDate = [[NSDate date] timeIntervalSince1970]*1000;
    }else{
        _isAddCache = NO;
        NSInteger fin = [[[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"%@_%@",_cache.name,@"FINISH"]] integerValue];
        NSInteger tot = [[[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"%@_%@",_cache.name,@"TOTAL"]] integerValue];
        double num = (fin*1.0000/tot)*100.00;
        if(num > 0.00000001){
            [self.startCache setTitle:[NSString stringWithFormat:@"继续缓存(已完成:%.8lf%@)",num,@"%"] forState:UIControlStateNormal];
        }
    }
    [dataHttpManager getInstance].cache = _cache;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.nameLabel.text = [_layer objectForKey:[dataHttpManager getInstance].cache.layerName];
    [self.minLabel setTitle:[NSString stringWithFormat:@"%ld",[dataHttpManager getInstance].cache.minLevel] forState:UIControlStateNormal];
    [self.maxLabel setTitle:[NSString stringWithFormat:@"%ld",[dataHttpManager getInstance].cache.maxLevel] forState:UIControlStateNormal];
    self.rangeLabel.text = [dataHttpManager getInstance].cache.range;
    if([dataHttpManager getInstance].cache.name){
        self.textLabel.text = [dataHttpManager getInstance].cache.name;
    }else{
        self.textLabel.text = [NSString stringWithFormat:@"%@_%@",[dataHttpManager getInstance].cache.range,self.nameLabel.text];
    }
}

- (IBAction)addCache:(id)sender{
    [dataHttpManager getInstance].cache.name = self.textLabel.text;
    if(!_isAddCache){
        [[dataHttpManager getInstance].cacheDB updateCache:[dataHttpManager getInstance].cache];
    }else{
        if([self isInCacheList]){
            ALERT(@"缓存名称已存在，请重新命名");
            return;
        }else{
            [[dataHttpManager getInstance].cacheDB insertCache:[dataHttpManager getInstance].cache];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
    TianDiTuData *tianji = [[TianDiTuData alloc] init];
    [tianji GetTiles:[dataHttpManager getInstance].cache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)isInCacheList{
    self.cacheList = [[dataHttpManager getInstance].cacheDB getAllCache];
    if(!self.cacheList || self.cacheList.count == 0){
        return NO;
    }
    for (DBCache *cache in self.cacheList) {
        if([cache.name isEqualToString:[dataHttpManager getInstance].cache.name]){
            return YES;
        }
    }
    return NO;
}

@end
