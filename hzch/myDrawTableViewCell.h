//
//  myDrawTableViewCell.h
//  hzch
//
//  Created by xtturing on 15/10/9.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Draw.h"
#import "DBCache.h"
@interface myDrawTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIButton *showBtn;
@property (nonatomic,strong) IBOutlet UIButton *editBtn;
@property (nonatomic,strong) IBOutlet UIButton *deleteBtn;
@property (nonatomic,strong) IBOutlet UILabel *titleLab;
@property (nonatomic,strong) IBOutlet UILabel *detailLab;
@property (nonatomic,strong) Draw *draw;
@property (nonatomic,strong) DBCache *cache;
@property (nonatomic,strong) NSString *layerUrl;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) void(^editSqlitBlock)(void);
- (IBAction)showDraw:(id)sender;
- (IBAction)editDraw:(id)sender;
- (IBAction)deleteDraw:(id)sender;



@end
