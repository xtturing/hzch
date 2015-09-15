//
//  TianDiTuData.h
//  EarthQuake
//
//  Created by hvit-pc on 14-5-9.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TianDiTuData : NSObject

-(NSData *)QueryTile:(NSString*)t x:(NSInteger)x y:(NSInteger)y l:(NSInteger)l;

- (BOOL)InsertTile:(NSString*)t x:(NSInteger)x y:(NSInteger)y l:(NSInteger)l tiels:(NSData *)tiels;

@end
