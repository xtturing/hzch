//
//  ViewController.m
//  hzch
//
//  Created by xtturing on 15/9/16.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "ViewController.h"
#import "esriView.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
#import "DrawSearchDetailTableViewController.h"
#import "NBSearchCatalogDetailTableViewController.h"
@interface ViewController ()<esriViewDelegate,UITabBarDelegate,dataHttpDelegate>{
    NSInteger segIndex;
    BOOL showMap;
}

@property (strong,nonatomic)  esriView *esriView;

@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedView;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *layerBtn;
@property(nonatomic,weak)IBOutlet UIButton *clearBtn;
@property (nonatomic,strong) UINavigationController *resoureViewController;
@property (nonatomic,strong) UINavigationController *searchViewController;
@property (nonatomic,strong) UINavigationController *lineSearchViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.esriView               = [[esriView alloc] initWithFrame:self.conView.frame];
    self.esriView.delegate      = self;
    self.tabBar.delegate        = self;
    segIndex = 0;
    showMap = YES;
    [self.conView addSubview:self.esriView];
    self.esriView.ClickCalloutBlock = ^(NSDictionary *dic){
        [dataHttpManager getInstance].sqliteCalloutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        for(NSString *key in dic.allKeys){
            if([dic objectForKey:key] == nil || [dic objectForKey:key] == [NSNull null])
            {
                [[dataHttpManager getInstance].sqliteCalloutDic removeObjectForKey:key];
            }else{
                if([[dic objectForKey:key] isKindOfClass:[NSString class]]){
                    NSString *value = [dic objectForKey:key];
                    if([value stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0 || [value isEqualToString:@"<null>"]){
                        [[dataHttpManager getInstance].sqliteCalloutDic removeObjectForKey:key];
                    }
                }
                if([key isEqualToString:@"GEOJSON"] || [key isEqualToString:@"Geometry"] || [key isEqualToString:@"type"]|| [key isEqualToString:@"title"]|| [key isEqualToString:@"detail"]|| [key isEqualToString:@"FeatureGUI"]|| [key isEqualToString:@"updatestat"]|| [key isEqualToString:@"PK_UID"]){
                    [[dataHttpManager getInstance].sqliteCalloutDic removeObjectForKey:key];
                }
            }
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"SearchCatalogDetailNavigation"] animated:YES completion:nil];
    };
    [self.conView addSubview:self.segmentedView];
    [self.conView addSubview:self.deleteBtn];
    [self.conView addSubview:self.layerBtn];
    [self.conView addSubview:self.clearBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLayerOnMap:) name:@"ADD_WMTS_LAYER_ON_MAP" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPointsOnMap:) name:@"ADD_POINTS_ON_MAP" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [dataHttpManager getInstance].delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [dataHttpManager getInstance].delegate =  nil;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    switch (item.tag) {
        case 1002:{
            [self.esriView hiddenToolView];
            if(_resoureViewController == nil){
                self.resoureViewController = [storyboard instantiateViewControllerWithIdentifier:@"BDNavViewController"];
            }
            [self presentViewController:_resoureViewController animated:YES completion:^{
                
            }];
        }
            
            break;
        case 1001:{
            [self.esriView hiddenToolView];
            [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"NBDownLoadNavigationViewController"] animated:YES completion:^{
                
            }];
        }
            
            break;
        case 1003:{
            [self.esriView showToolView];
        }
            
            break;
        case 1004:{
            [self.esriView hiddenToolView];
            [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"SetViewController"] animated:YES completion:^{
                
            }];
        }
            
            break;
        default:
            break;
    }
}

- (void)addPointsOnMap:(NSNotification *)info{
    NSArray *resultList = [info.userInfo objectForKey:@"results"];
    NSInteger searchType = [[info.userInfo objectForKey:@"searchType"] integerValue];
    [self.esriView addCustLayer:resultList withType:searchType];
}

- (void)addLayerOnMap:(NSNotification *)info{
    [self.esriView addWMTSLayer:info];
}

- (void)didSelectLineSearch{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(_lineSearchViewController == nil){
        self.lineSearchViewController = [storyboard instantiateViewControllerWithIdentifier:@"LineSearchNavigationViewController"];
    }
    [self presentViewController:self.lineSearchViewController animated:YES completion:^{
        
    }];
}

- (void)didDrawSearch{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"SearchDetailNavigationViewController"] animated:YES completion:^{
        
    }];
}

- (void)didGetFailed{
    [SVProgressHUD dismiss];
    ALERT(@"请求失败，请确认网络连接");
}

- (void)didGetTableIDFailed{
    [SVProgressHUD dismiss];
    ALERT(@"没有可以查询的图层");
}
- (void)didGetDraw:(NSMutableDictionary *)searchDic{
    [SVProgressHUD dismiss];
    if(searchDic.count > 0){
        

    }else{
        ALERT(@"手势查询结果为空");
    }
}

- (void)didSearch{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(_searchViewController == nil){
        self.searchViewController = [storyboard instantiateViewControllerWithIdentifier:@"searchNavigationViewController"] ;
    }
    [self presentViewController:_searchViewController animated:YES completion:^{
        
    }];
}
- (IBAction)changeMap:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    segIndex = segment.selectedSegmentIndex;
    [self.esriView changeMap:segIndex];
}
- (IBAction)deleteMap:(id)sender{
    [self.esriView deleteMap];
}
- (IBAction)layerMap:(id)sender{
    if([dataHttpManager getInstance].resourceLayers.count > 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"LayersManagerTableViewController"] animated:YES completion:^{
            
        }];
    }else{
        ALERT(@"没有添加可视专题图层");
    }
    
}
- (IBAction)clearMap:(id)sender{
    showMap = !showMap;
    if(showMap){
        [self.clearBtn setImage:[UIImage imageNamed:@"basemap_close"] forState:UIControlStateNormal];
    }else{
        [self.clearBtn setImage:[UIImage imageNamed:@"basemap_open"] forState:UIControlStateNormal];
    }
    [self.esriView clearMap:showMap index:segIndex];
}
#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self didSearch];
    return NO;
}

- (void)esriViewDetails:(esriView *)controller details:(AGSGraphic *)agsGraphic queryParams:(QueryParams *)queryParams{
    
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
