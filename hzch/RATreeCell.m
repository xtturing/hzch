//
//  RATreeCell.m
//  hzch
//
//  Created by xtturing on 15/9/19.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "RATreeCell.h"
#import "RADataObject.h"
#define DepartmentCellHeight 44
#define EmployeeCellHeight  44
@implementation RATreeCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.avatarImageView.layer.cornerRadius = 5.f;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)fillWithNode:(RATreeNodeInfo*)node
{
    if (node) {
        NSInteger cellType = node.treeDepthLevel;
        
        [self setCellStypeWithType:cellType originX:20.0 *cellType+20];
        if (cellType == 1) {
            self.plusImageView.image = [UIImage imageNamed:@"zoom_down_click"];
        }else if (cellType == 2){
            self.avatarImageView.image = [UIImage imageNamed:@"layer_click"];
        }
        if([node.children count] > 0){
           self.nameLabel.text = [NSString stringWithFormat:@"%@(%lu)",((RADataObject *)node.item).name,(unsigned long)[node.children count]];
        }else{
           
           self.nameLabel.text = [NSString stringWithFormat:@"%@",((RADataObject *)node.item).name];
        }
        
    }
}

- (void)setCellStypeWithType:(NSInteger)type originX:(CGFloat)x
{
    if (type == 2) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,
                                            self.contentView.frame.origin.y,
                                            self.contentView.frame.size.width, EmployeeCellHeight);
        
        self.plusImageView.hidden = YES;
        
        //设置头像的位置
        CGFloat iconWidth = EmployeeCellHeight - 20;
        self.avatarImageView.frame = CGRectMake(x, EmployeeCellHeight/2.f - iconWidth/2.f, iconWidth, iconWidth);
        
        //这是label
        self.nameLabel.frame = CGRectMake(self.avatarImageView.frame.origin.x+self.avatarImageView.frame.size.width + 5/*space*/,
                                           0,
                                           self.contentView.frame.size.width - self.avatarImageView.frame.origin.x - self.avatarImageView.frame.size.width - 5 - 5/*space*/,
                                           self.contentView.frame.size.height);
        
        //underline
        self.underLine.frame = CGRectMake(x,
                                          self.contentView.frame.size.height - 0.5,
                                          self.contentView.frame.size.width - x,
                                          0.5);
        self.underLine.backgroundColor = [UIColor colorWithRed:242/255.f green:244/255.f blue:246/255.f alpha:1];
        
    }else{
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,
                                            self.contentView.frame.origin.y,
                                            self.contentView.frame.size.width, DepartmentCellHeight);
        
        self.avatarImageView.hidden = YES;
        
        //设置 + 号的位置
        self.plusImageView.frame = CGRectMake(x, self.plusImageView.frame.origin.y,
                                              self.plusImageView.frame.size.width,
                                              self.plusImageView.frame.size.height);
        
        //设置 label的位置
        self.nameLabel.frame = CGRectMake(self.plusImageView.frame.origin.x+self.plusImageView.frame.size.width + 5/*space*/, 0,
                                           self.contentView.frame.size.width - self.plusImageView.frame.origin.x - self.plusImageView.frame.size.width - 5 - 5/*space*/,
                                           self.contentView.frame.size.height);
        
        //underline
        self.underLine.frame = CGRectMake(x,
                                          self.contentView.frame.size.height - 0.5,
                                          self.contentView.frame.size.width - x,
                                          0.5);
        self.underLine.backgroundColor = [UIColor colorWithRed:242/255.f green:244/255.f blue:246/255.f alpha:1];
    }
}

@end
