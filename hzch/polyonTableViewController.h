//
//  polyonTableViewController.h
//  hzch
//
//  Created by xtturing on 15/10/27.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface polyonTableViewController : UITableViewController

- (IBAction)segment:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)slider:(id)sender;
- (IBAction)color:(id)sender;
- (IBAction)color2:(id)sender;
- (IBAction)styleButton:(id)sender;
- (IBAction)sliderApla:(id)sender;

@property(nonatomic,weak)IBOutlet UILabel *widthValue;
@property(nonatomic,weak)IBOutlet UILabel *aplaValue;
@property(nonatomic,weak)IBOutlet UISegmentedControl *segment;
@property(nonatomic,weak)IBOutlet UISlider *slider;
@property(nonatomic,weak)IBOutlet UISlider *slider2;

@property(nonatomic,weak)IBOutlet UIButton *btn11;
@property(nonatomic,weak)IBOutlet UIButton *btn12;
@property(nonatomic,weak)IBOutlet UIButton *btn13;
@property(nonatomic,weak)IBOutlet UIButton *btn14;

@property(nonatomic,weak)IBOutlet UIButton *btn21;
@property(nonatomic,weak)IBOutlet UIButton *btn22;
@property(nonatomic,weak)IBOutlet UIButton *btn23;
@property(nonatomic,weak)IBOutlet UIButton *btn24;
@property(nonatomic,weak)IBOutlet UIButton *btn25;

@property(nonatomic,weak)IBOutlet UIButton *btn31;
@property(nonatomic,weak)IBOutlet UIButton *btn32;
@property(nonatomic,weak)IBOutlet UIButton *btn33;
@property(nonatomic,weak)IBOutlet UIButton *btn34;

@end
