//
//  NBDownLoadManagerViewController.h
//  tdtnb
//
//  Created by xtturing on 14-7-31.
//  Copyright (c) 2014年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBDownLoadManagerViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) NSArray *layers;
@property (nonatomic, assign) int segIndex;
- (IBAction)doBack:(id)sender;
@end
