//
//  PointTableViewController.h
//  hzch
//
//  Created by xtturing on 15/10/27.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointTableViewController : UITableViewController

- (IBAction)segment:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)slider:(id)sender;
- (IBAction)color:(id)sender;

@property(nonatomic,weak)IBOutlet UILabel *widthValue;
@property(nonatomic,weak)IBOutlet UISegmentedControl *segment;
@property(nonatomic,weak)IBOutlet UISlider *slider;
@property(nonatomic,weak)IBOutlet UIButton *btn1;
@property(nonatomic,weak)IBOutlet UIButton *btn2;
@property(nonatomic,weak)IBOutlet UIButton *btn3;
@property(nonatomic,weak)IBOutlet UIButton *btn4;
@end
