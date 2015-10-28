//
//  polyonTableViewController.m
//  hzch
//
//  Created by xtturing on 15/10/27.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "polyonTableViewController.h"

@interface polyonTableViewController ()
@property(nonatomic)NSInteger styleIndex;
@property(nonatomic)NSInteger color2Index;
@property(nonatomic)NSInteger colorIndex;
@property(nonatomic)NSInteger stylePolyonIndex;
@property(nonatomic)NSInteger widthIndex;
@property(nonatomic)NSInteger aplaIndex;
@end

@implementation polyonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]  objectForKey:@"polyon"];
    if(dic){
        self.segment.selectedSegmentIndex = [[dic objectForKey:@"style"] integerValue];
        self.slider.value = [[dic objectForKey:@"width"] integerValue];
        self.widthValue.text = [NSString stringWithFormat:@"%d",(int)self.slider.value];
        
        self.slider2.value = [[dic objectForKey:@"aplaValue"] integerValue];
        self.aplaValue.text = [NSString stringWithFormat:@"%d%@",(int)self.slider2.value,@"%"];
        
        self.colorIndex = [[dic objectForKey:@"color"] integerValue];
        if(self.colorIndex == self.btn11.tag){
            [self.btn11.layer setBorderWidth:2.0];
        }
        if(self.colorIndex == self.btn12.tag){
            [self.btn12.layer setBorderWidth:2.0];
        }
        if(self.colorIndex == self.btn13.tag){
            [self.btn13.layer setBorderWidth:2.0];
        }
        if(self.colorIndex == self.btn14.tag){
            [self.btn14.layer setBorderWidth:2.0];
        }
        
        self.color2Index = [[dic objectForKey:@"color2"] integerValue];
        if(self.color2Index == self.btn31.tag){
            [self.btn31.layer setBorderWidth:2.0];
        }
        if(self.color2Index == self.btn32.tag){
            [self.btn32.layer setBorderWidth:2.0];
        }
        if(self.color2Index == self.btn33.tag){
            [self.btn33.layer setBorderWidth:2.0];
        }
        if(self.color2Index == self.btn34.tag){
            [self.btn34.layer setBorderWidth:2.0];
        }
        
        self.stylePolyonIndex = [[dic objectForKey:@"stylePolyon"] integerValue];
        if(self.stylePolyonIndex == self.btn21.tag){
            [self.btn21.layer setBorderWidth:2.0];
        }
        if(self.stylePolyonIndex == self.btn22.tag){
            [self.btn22.layer setBorderWidth:2.0];
        }
        if(self.stylePolyonIndex == self.btn23.tag){
            [self.btn23.layer setBorderWidth:2.0];
        }
        if(self.stylePolyonIndex == self.btn24.tag){
            [self.btn24.layer setBorderWidth:2.0];
        }
        if(self.stylePolyonIndex == self.btn25.tag){
            [self.btn25.layer setBorderWidth:2.0];
        }
    }else{
        self.colorIndex = self.btn11.tag;
        [self.btn11.layer setBorderWidth:2.0];
        self.color2Index = self.btn31.tag;
        [self.btn31.layer setBorderWidth:2.0];
        self.stylePolyonIndex = self.btn21.tag;
        [self.btn21.layer setBorderWidth:2.0];
    }
    self.styleIndex = self.segment.selectedSegmentIndex;
    self.widthIndex = self.slider.value;
    self.aplaIndex = self.slider2.value;
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
    [[NSUserDefaults standardUserDefaults] setObject:@{@"style":@(self.styleIndex),@"color":@(self.colorIndex),@"width":@(self.widthIndex),@"aplaValue":@(self.aplaIndex),@"stylePolyon":@(self.stylePolyonIndex),@"color2":@(self.color2Index)} forKey:@"polyon"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    ALERT(@"面样式保存完成");
}
- (IBAction)slider:(id)sender{
    UISlider *slid = (UISlider *)sender;
    self.widthIndex = slid.value;
    self.widthValue.text = [NSString stringWithFormat:@"%d",(int)slid.value];
}
- (IBAction)sliderApla:(id)sender{
    UISlider *slid = (UISlider *)sender;
    self.aplaIndex = slid.value;
    self.aplaValue.text = [NSString stringWithFormat:@"%d%@",(int)slid.value,@"%"];
}
- (IBAction)color:(id)sender{
    UIButton *btn = (UIButton *)sender;
    self.colorIndex = btn.tag;
    [self.btn11.layer setBorderWidth:0];
    [self.btn12.layer setBorderWidth:0];
    [self.btn13.layer setBorderWidth:0];
    [self.btn14.layer setBorderWidth:0];
    
    [btn.layer setBorderWidth:2.0];
    [self.tableView reloadData];
}
- (IBAction)styleButton:(id)sender{
    UIButton *btn = (UIButton *)sender;
    self.stylePolyonIndex = btn.tag;
    [self.btn21.layer setBorderWidth:0];
    [self.btn22.layer setBorderWidth:0];
    [self.btn23.layer setBorderWidth:0];
    [self.btn24.layer setBorderWidth:0];
    [self.btn25.layer setBorderWidth:0];
    [btn.layer setBorderWidth:2.0];
    [self.tableView reloadData];
}
- (IBAction)color2:(id)sender{
    UIButton *btn = (UIButton *)sender;
    self.color2Index = btn.tag;
    [self.btn31.layer setBorderWidth:0];
    [self.btn32.layer setBorderWidth:0];
    [self.btn33.layer setBorderWidth:0];
    [self.btn34.layer setBorderWidth:0];
    
    [btn.layer setBorderWidth:2.0];
    [self.tableView reloadData];
}

@end
