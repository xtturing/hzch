//
//  lineTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/27.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "lineTableViewController.h"

@interface lineTableViewController ()
@property(nonatomic)NSInteger styleIndex;
@property(nonatomic)NSInteger colorIndex;
@property(nonatomic)NSInteger widthIndex;
@end

@implementation lineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]  objectForKey:@"line"];
    if(dic){
        self.segment.selectedSegmentIndex = [[dic objectForKey:@"style"] integerValue];
        self.slider.value = [[dic objectForKey:@"width"] integerValue];
        self.widthValue.text = [NSString stringWithFormat:@"%d",(int)self.slider.value];
        self.colorIndex = [[dic objectForKey:@"color"] integerValue];
        if(self.colorIndex == self.btn1.tag){
            [self.btn1.layer setBorderWidth:2.0];
        }
        if(self.colorIndex == self.btn2.tag){
            [self.btn2.layer setBorderWidth:2.0];
        }
        if(self.colorIndex == self.btn3.tag){
            [self.btn3.layer setBorderWidth:2.0];
        }
        if(self.colorIndex == self.btn4.tag){
            [self.btn4.layer setBorderWidth:2.0];
        }
    }else{
        self.colorIndex = self.btn1.tag;
        [self.btn1.layer setBorderWidth:2.0];
    }
    self.styleIndex = self.segment.selectedSegmentIndex;
    self.widthIndex = self.slider.value;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segment:(id)sender{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    self.styleIndex = seg.selectedSegmentIndex;
}
- (IBAction)save:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:@{@"style":@(self.styleIndex),@"color":@(self.colorIndex),@"width":@(self.widthIndex)} forKey:@"line"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    ALERT(@"线样式保存完成");
}
- (IBAction)slider:(id)sender{
    UISlider *slid = (UISlider *)sender;
    self.widthIndex = slid.value;
    self.widthValue.text = [NSString stringWithFormat:@"%d",(int)slid.value];
}
- (IBAction)color:(id)sender{
    UIButton *btn = (UIButton *)sender;
    self.colorIndex = btn.tag;
    [self.btn1.layer setBorderWidth:0];
    [self.btn2.layer setBorderWidth:0];
    [self.btn3.layer setBorderWidth:0];
    [self.btn4.layer setBorderWidth:0];
    
    [btn.layer setBorderWidth:2.0];
    [self.tableView reloadData];
}
@end
