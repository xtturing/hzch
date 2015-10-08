//
//  SketchUtil.h
//  ZjGIS
//
//  Created by 余 林峰 on 2012-07-05.
//  Copyright (c) 2012年 浙江省地理信息中心. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface SketchUtil : NSObject

/**获取默认Graphics Layer
 */
+ (AGSGraphicsLayer*) getDefaultGraphicLayer;

+ (AGSGraphicsLayer*) getPointGraphicLayerWithImage:(NSString*)imageName;

/**获取默认线Graphics Layer
 */
+ (AGSGraphicsLayer*) getDefaultLineGraphicLayer;

/**获取绘图用Graphics Layer
 */
+ (AGSSketchGraphicsLayer*) getSketchGraphicLayer;

@end
