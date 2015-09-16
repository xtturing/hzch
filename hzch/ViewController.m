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
@property (weak, nonatomic) IBOutlet UITabBarItem *tabItemBar;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.esriView               = [[esriView alloc] initWithFrame:self.conView.frame];
    self.esriView.delegate      = self;
    self.tabBar.selectedItem    = self.tabItemBar;
    self.tabBar.delegate        = self;
    
    [self.conView addSubview:self.esriView];
    [self.conView addSubview:self.segmentedView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
