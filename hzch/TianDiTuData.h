//
//  TianDiTuData.h
//  EarthQuake
//
//  Created by hvit-pc on 14-5-9.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBCache.h"

#define kURLGetTile @"%@?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=%@&FORMAT=%@&TILEMATRIXSET=%@&TILECOL=%ld&TILEROW=%ld&TILEMATRIX=%ld&STYLE=%@"

@interface TianDiTuData : NSObject
@property (nonatomic,assign) NSInteger totalTileNum;
@property (nonatomic,assign) NSInteger finishTileNum;
-(NSData *)QueryTile:(NSString*)t x:(NSInteger)x y:(NSInteger)y l:(NSInteger)l;

- (BOOL)InsertTile:(NSString*)t x:(NSInteger)x y:(NSInteger)y l:(NSInteger)l tiels:(NSData *)tiels;

- (void)GetTiles:(DBCache *)cache;

- (void)stopGetTiles;

@end
