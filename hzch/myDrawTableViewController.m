//
//  myDrawTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/9.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "myDrawTableViewController.h"
#import "dataHttpManager.h"
#import "Draw.h"
#import "myDrawTableViewCell.h"

@interface myDrawTableViewController ()
@property(nonatomic,strong) NSMutableArray *drawList;

@end

@implementation myDrawTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.drawList = [[dataHttpManager getInstance].drawDB getAllDraws];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"RELOADTABLE" object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reload{
    self.drawList = [[dataHttpManager getInstance].drawDB getAllDraws];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_drawList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Draw *draw = [_drawList objectAtIndex:indexPath.row];
    static NSString *FirstLevelCell = @"drawCell";
    myDrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             FirstLevelCell];
    if (cell == nil) {
        cell = [[myDrawTableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier: FirstLevelCell];
    }
    cell.titleLab.text = draw.name;
    cell.titleLab.tag = draw.createDate;
    cell.type = 0;
    if([self hasShowDraw:[NSString stringWithFormat:@"%ld",draw.createDate]]){
        [cell.showBtn setImage:[UIImage imageNamed:@"show_normal"] forState:UIControlStateNormal];
    }else{
        [cell.showBtn setImage:[UIImage imageNamed:@"hidden_normal"] forState:UIControlStateNormal];
    }
    cell.titleLab.adjustsFontSizeToFitWidth = YES;
    cell.draw = draw;
    return cell;
}

- (BOOL)hasShowDraw:(NSString *)cellTag{
    for (id tag in [dataHttpManager getInstance].drawLayers) {
        if([cellTag isEqualToString: tag]){
            return YES;
        }
    }
    return NO;
}

@end
