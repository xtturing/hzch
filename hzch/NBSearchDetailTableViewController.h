//
//  NBSearchDetailTableViewController.h
//  hzch
//
//  Created by xtturing on 15/10/3.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SEARCH_KEY_WORD @"searchKeyword"
#define SEARCH_CATALOG @"searchcatalog"
#define SEARCH_DOWNLOAD @"searchdownload"

@interface NBSearchDetailTableViewController : UITableViewController

@property(nonatomic,strong)NSMutableDictionary *resultDic;
@property(nonatomic,strong) NSMutableArray *keywordList;
@property(nonatomic,strong)NSString *keyword;
@property(nonatomic)NSInteger searchType;

@property(nonatomic,weak)IBOutlet UIToolbar *toolBar;
@property(nonatomic,weak)IBOutlet UIBarButtonItem *nextItem;
@property(nonatomic,weak)IBOutlet UIBarButtonItem *preItem;
@property(nonatomic,weak)IBOutlet UIBarButtonItem *countItem;
-(IBAction)toolbarAction:(id)sender;

@end
