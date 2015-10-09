//
//  myDrawTableViewCell.h
//  hzch
//
//  Created by xtturing on 15/10/9.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myDrawTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIButton *showBtn;
@property (nonatomic,strong) IBOutlet UIButton *editBtn;
@property (nonatomic,strong) IBOutlet UIButton *deleteBtn;
@property (nonatomic,strong) IBOutlet UILabel *titleLab;

@end
