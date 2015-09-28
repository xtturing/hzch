//
//  NBTpk.h
//  nbtdt
//
//  Created by xtturing on 14-8-31.
//
//

#import <Foundation/Foundation.h>
#import "NSDictionaryAdditions.h"
@interface NBTpk : NSObject

@property (nonatomic, strong) NSString *tpkid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *updatetime;
@property (nonatomic, strong) NSString *news;
@property (nonatomic, strong) NSString *tpkname;
@property (nonatomic, strong) NSString *url;


- (NBTpk *)initWithJsonDictionary:(NSDictionary*)dic;

+ (NBTpk *)tpkWithJsonDictionary:(NSDictionary*)dic;

@end
