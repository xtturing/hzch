//
//  addCacheTableViewController.h
//  hzch
//
//  Created by xtturing on 15/10/8.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addCacheTableViewController : UITableViewController

@property(nonatomic,strong) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UIButton *minLabel;
@property(nonatomic,strong) IBOutlet UIButton *maxLabel;
@property(nonatomic,strong) IBOutlet UILabel *rangeLabel;
@property(nonatomic,strong) IBOutlet UITextField *textLabel;

- (IBAction)addCache:(id)sender;

@end
