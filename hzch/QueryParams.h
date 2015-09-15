//
//  QueryParams.h
//  EarthQuake
//
//  Created by hvit-pc on 14-4-28.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface QueryParams : NSObject
@property (nonatomic,strong) NSString *layerName;           //图层名称
@property (nonatomic,strong) NSString *layerType;           //图层类型
@property (nonatomic,strong) NSString *layerUrl;            //图层Url
@property (nonatomic,strong) NSString *layerWhere;          //ArcGis SQL
@property (nonatomic,strong) NSMutableArray *fieldOrder;    //字段排序
@property (nonatomic,strong) NSMutableArray *fieldFormat;   //单位处理
@property (nonatomic,strong) NSMutableArray *fieldOut;      //需要现实的字段名
@property (nonatomic,strong) NSMutableArray *fieldAlias;    //字段对应的中文名称
@property (nonatomic,strong) NSMutableArray *itemField;     //列表行需要展示的两个关键属性
@property (nonatomic, assign) BOOL layerQuery;              //是否进行空间查询
@property (nonatomic,strong) AGSGeometry *layerGeometry;    //查询空间属性
@property (nonatomic, strong) AGSSpatialReference *layerSpr;//地图坐标系


@end
