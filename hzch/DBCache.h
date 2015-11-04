//
//  DBCache.h
//  
//
//  Created by xtturing on 15/11/4.
//
//

#import <Foundation/Foundation.h>

@interface DBCache : NSObject

@property(nonatomic,assign) NSInteger typeID;
@property(nonatomic,strong) NSString *range;
@property(nonatomic,assign) NSInteger minLevel;
@property(nonatomic,assign) NSInteger maxLevel;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *layerName;
@property(nonatomic,assign) BOOL isShow;

@end
