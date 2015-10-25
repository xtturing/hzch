//
//  LineSearchTableViewController.h
//  hzch
//
//  Created by xtturing on 15/9/24.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineSearchTableViewController : UITableViewController

- (IBAction)getStartPointInMap:(id)sender;
- (IBAction)getEndPointInMap:(id)sender;
- (IBAction)showLineInMap:(id)sender;
- (IBAction)doLineSearch:(id)sender;
@property(nonatomic,weak)IBOutlet UITextField *startText;
@property(nonatomic,weak)IBOutlet UITextField *endText;
@property(nonatomic,weak)IBOutlet UIBarButtonItem *rightBar;
@end
