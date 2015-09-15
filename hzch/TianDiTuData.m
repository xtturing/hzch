//
//  TianDiTuData.m
//  EarthQuake
//
//  Created by hvit-pc on 14-5-9.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import "TianDiTuData.h"

@implementation TianDiTuData

- (NSString*)getTilePath:(NSString*)t x:(NSInteger)x y:(NSInteger)y l:(NSInteger)l
{
    //获取到Documents的目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //拿到Documents的路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *tlayer = t;
    NSString *llayer = [NSString stringWithFormat: @"%d", l];
    NSString *xname = [NSString stringWithFormat: @"%d", x];
    NSString *yname = [NSString stringWithFormat: @"%d", y];
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
        tileData = [NSData dataWithContentsOfFile:tilePath];
    }else{
        tileData = nil;
    }
    
    return tileData;
}


-(NSData *)QueryTile:(NSString*)t x:(NSInteger)x y:(NSInteger)y l:(NSInteger)l
{
    
    NSString *tilePath = [self getTilePath:t x:x y:y l:l];
    
    return [self getTileData:tilePath];
}

- (BOOL)InsertTile:(NSString*)t x:(NSInteger)x y:(NSInteger)y l:(NSInteger)l tiels:(NSData *)tiels{
    BOOL _result = NO;
    NSString *tilePath = [self getTilePath:t x:x y:y l:l];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    [fileManage createFileAtPath:tilePath contents:tiels attributes:nil];
    
    if ([fileManage fileExistsAtPath:tilePath]) {
        _result = YES;
    }
    return _result;
}

@end
