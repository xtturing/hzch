//
//  NBSearchCatalogDetailTableViewController.h
//  hzch
//
//  Created by xtturing on 15/10/17.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBSearchCatalog.h"
@interface NBSearchCatalogDetailTableViewController : UITableViewController

@property (nonatomic,strong) NBSearchCatalog *catalog;
@property (nonatomic,assign) NSInteger tableID;
@end
