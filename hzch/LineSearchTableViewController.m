//
//  LineSearchTableViewController.m
//  hzch
//
//  Created by xtturing on 15/9/24.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "LineSearchTableViewController.h"
#import "dataHttpManager.h"
@interface LineSearchTableViewController ()<dataHttpDelegate>
- (IBAction)doBack:(id)sender;
@end

@implementation LineSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addStartPoint:) name:@"ADD_START_POINT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEndPoint:) name:@"ADD_END_POINT" object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)getStartPointInMap:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"START_POINT_IN_MAP" object:nil];
    }];
}
- (IBAction)getEndPointInMap:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"END_POINT_IN_MAP" object:nil];
    }];
}

- (IBAction)doLineSearch:(id)sender{
    if(self.startText.text.length > 0 && self.endText.text.length > 0){
        [[dataHttpManager getInstance] letGetLineSearch:self.startText.text end:self.endText.text];
    }else{
        ALERT(@"请先选择起点和终点");
    }
}

- (IBAction)showLineInMap:(id)sender{
    
}

- (void)addStartPoint:(NSNotification *)info{
    NSString *point = [info.userInfo objectForKey:@"point"];
    self.startText.text = point;
}

- (void)addEndPoint:(NSNotification *)info{
    NSString *point = [info.userInfo objectForKey:@"point"];
    self.endText.text = point;

}

- (void)didGetLineSearch:(NSMutableDictionary *)lineDic{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
