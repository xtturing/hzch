//
//  ViewController.m
//  hzch
//
//  Created by xtturing on 15/9/16.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "ViewController.h"
#import "esriView.h"

@interface ViewController ()<esriViewDelegate,UITabBarDelegate>{
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
    [self.conView addSubview:self.segmentedView];
    [self.conView addSubview:self.deleteBtn];
    [self.conView addSubview:self.layerBtn];
    [self.conView addSubview:self.clearBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    switch (item.tag) {
        case 1001:{
            [self.esriView hiddenToolView];
            [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"NBDownLoadNavigationViewController"] animated:YES completion:^{
                
            }];
        }
            
            break;
        case 1002:{
            [self.esriView hiddenToolView];
            [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"BDNavViewController"] animated:YES completion:^{
                
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

- (void)didSelectLineSearch{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"LineSearchNavigationViewController"] animated:YES completion:^{
        
    }];
}

- (void)didSearch{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"searchNavigationViewController"] animated:YES completion:^{
        
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
