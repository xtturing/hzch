//
//  ShpHelper.h
//  TestShp
//
//  Created by baocai zhang on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef TestShp_ShpHelper_h
#define TestShp_ShpHelper_h

#import <ArcGIS/ArcGIS.h>

/**读取shapefile 文件
 */
NSMutableArray * shp2AGSGraphics(NSString * shpPath,NSString * shpName);

/**将agsgraohics 保存为shapefile
 */
void graphics2shp(NSArray* graphicList, NSString * shpPath,NSString* shpName);

/**向shapefile中添加graphic
 */
void addGraphic2shp(AGSGraphic* graphic,NSString* shpPath,NSString* shpName);

#endif
