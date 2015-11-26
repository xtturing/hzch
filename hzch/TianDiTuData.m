//
//  TianDiTuData.m
//  EarthQuake
//
//  Created by hvit-pc on 14-5-9.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import "TianDiTuData.h"
#import "DBCache.h"
#import "dataHttpManager.h"
#import "TianDiTuWMTSLayerInfoDelegate.h"

@implementation TianDiTuData

- (NSString*)getTilePath:(NSString*)t x:(NSInteger)x y:(NSInteger)y l:(NSInteger)l
{
    //获取到Documents的目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //拿到Documents的路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *tlayer = t;
    NSString *llayer = [NSString stringWithFormat: @"%ld", (long)l];
    NSString *xname = [NSString stringWithFormat: @"%ld", (long)x];
    NSString *yname = [NSString stringWithFormat: @"%ld", (long)y];
    //建立文件操作对象
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    //文件命名为Map
    NSString *mapDir = [documentsDirectory stringByAppendingPathComponent:@"map"];
    if (![fileManage fileExistsAtPath:mapDir]) {
        //创建文件夹
        [fileManage createDirectoryAtPath:mapDir attributes:nil];
    }
    
    //文件命名为Ver
    NSString *layerTypeDir = [mapDir stringByAppendingPathComponent:tlayer];
    if (![fileManage fileExistsAtPath:layerTypeDir]) {
        //创建文件夹
        [fileManage createDirectoryAtPath:layerTypeDir attributes:nil];
    }
    
    NSString *layerLevelDir = [layerTypeDir stringByAppendingPathComponent:llayer];
    if (![fileManage fileExistsAtPath:layerLevelDir]) {
        //创建文件夹
        [fileManage createDirectoryAtPath:layerLevelDir attributes:nil];
    }

    //切片
    NSString *tilePath =  [layerLevelDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.png",xname,yname]];
    
    return tilePath;
}
-(NSData *)getTileData:(NSString *)tilePath{
    NSData *tileData;
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:tilePath]) {
        NSLog(@"%@",tilePath);
        tileData = [NSData dataWithContentsOfFile:tilePath];
    }else{
        tileData = nil;
    }
    return tileData;
}


-(NSData *)QueryTile:(NSString*)t x:(NSInteger)x y:(NSInteger)y l:(NSInteger)l
{
    if([self needToShowCache:t level:l x:x y:y]){
        NSString *tilePath = [self getTilePath:t x:x y:y l:l];
        return [self getTileData:tilePath];
    }
    return nil;
}

- (BOOL)InsertTile:(NSString*)t x:(NSInteger)x y:(NSInteger)y l:(NSInteger)l tiels:(NSData *)tiels{
    BOOL _result = NO;
    if([self needToCache:t]){
        NSString *tilePath = [self getTilePath:t x:x y:y l:l];
        NSFileManager *fileManage = [NSFileManager defaultManager];
        [fileManage createFileAtPath:tilePath contents:tiels attributes:nil];
        if ([fileManage fileExistsAtPath:tilePath]) {
            _result = YES;
        }
    }    
    return _result;
}

- (BOOL)needToCache:(NSString *)layername{
    NSArray *layerArray = @[@"vec",@"cva",@"img",@"cia",@"zjemap",@"zjemapanno",@"imgmap",@"imgmap_lab"];
    for (NSString *name in  layerArray) {
        if([name isEqualToString:layername]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)needToShowCache:(NSString *)layername level:(NSInteger)level x:(NSInteger)x y:(NSInteger)y{
    for (DBCache *cache in  [dataHttpManager getInstance].cacheList) {
        if(cache.isShow && [cache.layerName isEqualToString:layername] && level >= cache.minLevel && level <= cache.maxLevel){
            NSArray *array = [NSArray arrayWithArray:[cache.rangeBox componentsSeparatedByString:@","]];
            if([cache.range isEqualToString:@"当前可视范围"] || !array){
                return YES;
            }
            NSInteger minc = [self getMinC:[(NSNumber *)[array objectAtIndex:0] doubleValue] level:level];
            NSInteger maxc = [self getMaxC:[(NSNumber *)[array objectAtIndex:2] doubleValue] level:level];
            NSInteger minr = [self getMinR:[(NSNumber *)[array objectAtIndex:3] doubleValue] level:level];
            NSInteger maxr = [self getMaxR:[(NSNumber *)[array objectAtIndex:1] doubleValue] level:level];
            if(minc <= y && y <= maxc && x >= minr && x <= maxr){
                return YES;
            }
        }
    }
    return NO;
}

- (NSInteger)getMinC:(double)minx  level:(NSInteger)level{
    TianDiTuWMTSLayerInfo *layerInfo = [[TianDiTuWMTSLayerInfoDelegate alloc] getLayerInfo];
    AGSLOD *lod  = (AGSLOD *)[layerInfo.lods objectAtIndex:(level-2)];
    NSInteger minc = floor(fabs((layerInfo.origin.x - minx) / (layerInfo.tileWidth * lod.resolution)));
    return minc;
}

- (NSInteger)getMaxC:(double)maxx  level:(NSInteger)level{
    TianDiTuWMTSLayerInfo *layerInfo = [[TianDiTuWMTSLayerInfoDelegate alloc] getLayerInfo];
    AGSLOD *lod  = (AGSLOD *)[layerInfo.lods objectAtIndex:(level-2)];
    NSInteger maxc = round(fabs((layerInfo.origin.x - maxx) / (layerInfo.tileWidth * lod.resolution)));
    return maxc;
}

- (NSInteger)getMinR:(double)maxy  level:(NSInteger)level{
    TianDiTuWMTSLayerInfo *layerInfo = [[TianDiTuWMTSLayerInfoDelegate alloc] getLayerInfo];
    AGSLOD *lod  = (AGSLOD *)[layerInfo.lods objectAtIndex:(level-2)];
    NSInteger minr = floor(fabs((layerInfo.origin.y - maxy) / (layerInfo.tileHeight * lod.resolution)));
    return minr;
}

- (NSInteger)getMaxR:(double)miny  level:(NSInteger)level{
    TianDiTuWMTSLayerInfo *layerInfo = [[TianDiTuWMTSLayerInfoDelegate alloc] getLayerInfo];
    AGSLOD *lod  = (AGSLOD *)[layerInfo.lods objectAtIndex:(level-2)];
    long maxr = round(fabs((layerInfo.origin.y - miny) / (layerInfo.tileHeight * lod.resolution)));
    return maxr;
}

@end
