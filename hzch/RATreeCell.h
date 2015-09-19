//
//  RATreeCell.h
//  hzch
//
//  Created by xtturing on 15/9/19.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeNodeInfo.h"

@interface RATreeCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) IBOutlet UIImageView *plusImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIView *underLine;

- (void)fillWithNode:(RATreeNodeInfo*)node;
@end
