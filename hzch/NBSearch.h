//
//  NBSearch.h
//  hzch
//
//  Created by xtturing on 15/10/2.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionaryAdditions.h"

@interface NBSearch : NSObject

@property (nonatomic, strong) NSString *tableid;
@property (nonatomic, strong) NSString *tablename;
@property (nonatomic, strong) NSString *objectid;
@property (nonatomic, strong) NSString *entiid;
@property (nonatomic, strong) NSString *industrycode;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *classtype;
@property (nonatomic, strong) NSString *divisiontype;
@property (nonatomic, strong) NSString *sectiontype;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *town;
@property (nonatomic, strong) NSString *county;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *labelx;
@property (nonatomic, strong) NSString *labely;
@property (nonatomic, strong) NSString *minx;
@property (nonatomic, strong) NSString *miny;
@property (nonatomic, strong) NSString *maxx;
@property (nonatomic, strong) NSString *maxy;
@property (nonatomic, strong) NSString *centerx;
@property (nonatomic, strong) NSString *centery;
@property (nonatomic, strong) NSString *geometry;

- (NBSearch *)initWithJsonDictionary:(NSDictionary*)dic;

+ (NBSearch *)searchWithJsonDictionary:(NSDictionary*)dic;
@end
