//
//  ViewController.m
//  hzch
//
//  Created by xtturing on 15/9/16.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "ViewController.h"
#import "esriView.h"

@interface ViewController ()<esriViewDelegate,UITabBarDelegate>

@property (strong,nonatomic)  esriView *esriView;

@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedView;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *layerBtn;
@property (weak, nonatomic) IBOutlet UIButton *baseMapBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.esriView               = [[esriView alloc] initWithFrame:self.conView.frame];
    self.esriView.delegate      = self;
    self.tabBar.delegate        = self;
    
    [self.conView addSubview:self.esriView];
    [self.conView addSubview:self.segmentedView];
    [self.conView addSubview:self.deleteBtn];
    [self.conView addSubview:self.layerBtn];
    [self.conView addSubview:self.baseMapBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    switch (item.tag) {
        case 1001:{
            [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"NBDownLoadNavigationViewController"] animated:YES completion:^{
                
            }];
        }
            
            break;
        case 1002:{
            [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"BDNavViewController"] animated:YES completion:^{
                
            }];
        }
            
            break;
        case 1003:{
            [self.esriView showToolView];
        }
            
            break;
        case 1004:{
            [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"SetViewController"] animated:YES completion:^{
                
            }];
        }
            
            break;
        default:
            break;
    }
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
