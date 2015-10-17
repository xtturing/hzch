//
//  DrawSearchDetailTableViewController.h
//  hzch
//
//  Created by xtturing on 15/10/18.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawSearchDetailTableViewController : UITableViewController
@property(nonatomic,strong)NSMutableDictionary *resultDic;

@property(nonatomic,weak)IBOutlet UIToolbar *toolBar;
@property(nonatomic,weak)IBOutlet UIBarButtonItem *nextItem;
@property(nonatomic,weak)IBOutlet UIBarButtonItem *preItem;
@property(nonatomic,weak)IBOutlet UIBarButtonItem *countItem;
@property(nonatomic,weak)IBOutlet UIBarButtonItem *showMapItem;
-(IBAction)toolbarAction:(id)sender;
-(IBAction)showInMap:(id)sender;
- (IBAction)doBack:(id)sender;
@end
