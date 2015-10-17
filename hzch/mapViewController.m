//
//  mapViewController.m
//  hzch
//
//  Created by xtturing on 15/10/11.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "mapViewController.h"
#import "esriView.h"
@interface mapViewController ()<esriViewDelegate>
@property (strong,nonatomic)  esriView *esriView;
@end

@implementation mapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.esriView               = [[esriView alloc] initWithFrame:self.view.bounds];
    self.esriView.delegate      = self;
    [self.view addSubview:self.esriView];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapViewDidLoad{
    [self performSelector:@selector(addMapPoint) withObject:nil afterDelay:0.4];
}

- (void)addMapPoint{
    [self.esriView addAllWmtsLayers];
    [self.esriView addCustLayer:self.resultList withType:self.searchType];
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
