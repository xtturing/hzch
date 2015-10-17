//
//  LayersManagerTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/17.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "LayersManagerTableViewController.h"
#import "dataHttpManager.h"
@interface LayersManagerTableViewController ()

@end

@implementation LayersManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doBack:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[dataHttpManager getInstance].namelayers.allKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [[dataHttpManager getInstance].namelayers.allKeys  objectAtIndex:indexPath.row];
    NSString *title = [[dataHttpManager getInstance].namelayers objectForKey:key];
    
    static NSString *FirstLevelCell = @"NBLayer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    UIButton *eyeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [eyeButton setImage:[UIImage imageNamed:@"show_normal"] forState:UIControlStateNormal];
    eyeButton.tag = indexPath.row;
    [eyeButton addTarget:self action:@selector(showLayerInMap:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = eyeButton;
    
    cell.textLabel.text = title;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self addlayerIndex:indexPath.row];
}

- (void)showLayerInMap:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [self addlayerIndex:btn.tag];
}

- (void)addlayerIndex:(NSInteger)index{
    NSString *wmtsname = [[dataHttpManager getInstance].resourceLayers.allKeys objectAtIndex:index];
    NSString *wmtsurl = [[dataHttpManager getInstance].resourceLayers objectForKey:wmtsname];
    NSString *wmtsID = [[dataHttpManager getInstance].namelayers.allKeys  objectAtIndex:index];
    NSString *name = [[dataHttpManager getInstance].namelayers objectForKey:wmtsID];
    UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UIButton *btn = (UIButton *)cell.accessoryView;
    [btn setImage:[UIImage imageNamed:@"hidden_normal"] forState:UIControlStateNormal];
    ALERT(@"已从地图移除");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_WMTS_LAYER_ON_MAP" object:nil userInfo:@{@"wmtsurl":wmtsurl,@"wmtsname":wmtsname,@"wmtsID":wmtsID,@"name":name}];
    [self.tableView reloadData];
    
}
@end
