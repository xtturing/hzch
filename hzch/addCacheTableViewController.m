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

@interface addCacheTableViewController ()

@property (nonatomic,strong) NSArray *cacheList;
@end

@implementation addCacheTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(![dataHttpManager getInstance].cache){
        DBCache *cache = [[DBCache alloc]init];
        cache.minLevel = 1;
        cache.maxLevel = 20;
        cache.name = @"中国电子地图";
        cache.layerName = @"vec";
        cache.isShow = YES;
        cache.range = @"当前可视范围";
        cache.typeID = 0;
        [dataHttpManager getInstance].cache = cache;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.nameLabel.text = [dataHttpManager getInstance].cache.name;
    [self.minLabel setTitle:[NSString stringWithFormat:@"%ld",[dataHttpManager getInstance].cache.minLevel] forState:UIControlStateNormal];
    [self.maxLabel setTitle:[NSString stringWithFormat:@"%ld",[dataHttpManager getInstance].cache.maxLevel] forState:UIControlStateNormal];
    self.rangeLabel.text = [dataHttpManager getInstance].cache.range;
    self.textLabel.text = [dataHttpManager getInstance].cache.name;
}

- (IBAction)addCache:(id)sender{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [dataHttpManager getInstance].cache.name = self.textLabel.text;
    if([self isInCacheList:[dataHttpManager getInstance].cache.typeID]){
        [[dataHttpManager getInstance].cacheDB updateCache:[dataHttpManager getInstance].cache];
    }else{
         [[dataHttpManager getInstance].cacheDB insertCache:[dataHttpManager getInstance].cache];
    }
    [SVProgressHUD dismiss];
    ALERT(@"添加缓存成功");
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)isInCacheList:(NSInteger)typeID{
    self.cacheList = [[dataHttpManager getInstance].cacheDB getAllCache];
    if(!self.cacheList || self.cacheList.count == 0){
        return NO;
    }
    for (DBCache *cache in self.cacheList) {
        if(cache.typeID == typeID){
            return YES;
        }
    }
    return NO;
}

@end
