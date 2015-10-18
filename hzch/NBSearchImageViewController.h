//
//  NBSearchImageViewController.h
//  hzch
//
//  Created by xtturing on 15/10/18.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBSearchImageViewController : UIViewController

@property(nonatomic,weak)IBOutlet UIImageView *imageView;

@property(nonatomic,strong) NSString *imageUrl;
@property(nonatomic,assign) NSInteger catalogID;
@property (nonatomic,strong) NSString *titleName;

@end
