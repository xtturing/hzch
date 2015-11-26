//
//  CanvasView.h
//  MapKitDrawing
//
//  Created by tazi afafe on 17/05/2014.
//  Copyright (c) 2014 tazi.omar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "esriView.h"

@interface CanvasView : UIImageView

@property(nonatomic, weak) esriView *delegate;

@property(nonatomic,assign) UIColor *lineColor;
@property(nonatomic,assign) CGFloat lineWidth;

@end
