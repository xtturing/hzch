//
//  NBSpatialData.h
//  hzch
//
//  Created by xtturing on 15/9/28.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionaryAdditions.h"
@interface NBSpatialData : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *updatetime;
@property (nonatomic, strong) NSString *news;
@property (nonatomic, strong) NSString *url;

- (NBSpatialData *)initWithJsonDictionary:(NSDictionary*)dic;

+ (NBSpatialData *)spatialDataWithJsonDictionary:(NSDictionary*)dic;

@end
