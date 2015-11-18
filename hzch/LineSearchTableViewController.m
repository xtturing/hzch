//
//  LineSearchTableViewController.m
//  hzch
//
//  Created by xtturing on 15/9/24.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "LineSearchTableViewController.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
@interface LineSearchTableViewController ()<dataHttpDelegate>
- (IBAction)doBack:(id)sender;
@property (nonatomic, strong) NBRoute *route;
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
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[dataHttpManager getInstance] letGetLineSearch:self.startText.text end:self.endText.text];
        });
    }else{
        ALERT(@"请先选择起点和终点");
    }
}

- (IBAction)showLineInMap:(id)sender{
    if(self.route){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_ROUTE_IN_MAP" object:nil userInfo:@{@"route":self.route}];
        [self doBack:nil];
    }
}

- (void)addStartPoint:(NSNotification *)info{
    NSString *point = [info.userInfo objectForKey:@"point"];
    self.startText.text = point;
}

- (void)addEndPoint:(NSNotification *)info{
    NSString *point = [info.userInfo objectForKey:@"point"];
    self.endText.text = point;
}

-(void)didGetRoute:(NBRoute *)route{
    [SVProgressHUD dismiss];
    self.rightBar.enabled = YES;
    _route = route;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_ROUTE_IN_MAP" object:nil userInfo:@{@"route":self.route}];
    [self.tableView reloadData];
}

- (void)didGetFailed{
    [SVProgressHUD dismiss];
    self.rightBar.enabled = NO;
    ALERT(@"路径查询服务异常");
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_route.routeItemList count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_route.routeItemList.count > 0){
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 44.0)];
        customView.backgroundColor = [UIColor clearColor];
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor orangeColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:16];
        headerLabel.frame = CGRectMake(20.0, 5.0, 300.0, 18.0);
        
        UILabel * headerLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel2.backgroundColor = [UIColor clearColor];
        headerLabel2.opaque = NO;
        headerLabel2.textColor = [UIColor lightGrayColor];
        headerLabel2.font = [UIFont boldSystemFontOfSize:14];
        headerLabel2.frame = CGRectMake(20.0, 28.0, 300.0, 16.0);
        headerLabel.text = [NSString stringWithFormat:@"总里程:约%@公里",self.route.distance];
        headerLabel2.text = [NSString stringWithFormat:@"历时约%.2f分钟",[self.route.duration floatValue]/60];
        [customView addSubview:headerLabel];
        [customView addSubview:headerLabel2];
        return customView;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdetify = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    NBRouteItem *item = (NBRouteItem *)[_route.routeItemList objectAtIndex:indexPath.row];
    cell.textLabel.text = item.streetName;
    cell.detailTextLabel.text = item.strguide;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.5;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.minimumScaleFactor = 0.5;
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

@end
