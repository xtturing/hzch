//
//  MapUtil.h
//  ZjGIS
//
//  Created by 林峰 余 on 12-8-6.
//  Copyright (c) 2012年 zjgis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface MapUtil : NSObject

+ (BOOL)isSameEnvelope:(AGSEnvelope*)envelopeA andEnvelope:(AGSEnvelope*)envelopeB;

+ (id)getMapLayerByName:(NSString*)layerName mapView:(AGSMapView*)mapView;

+ (void) clearMapLayers:(AGSMapView*)mapView;

+ (NSMutableArray*)queryGraphicsByAttributes:(NSMutableArray*)graphicList conditionList:(NSMutableArray*)conditionList;

+ (NSMutableArray*)queryGraphicsBySpatial:(NSMutableArray*)graphicList geometry:(AGSGeometry*)geometry;

@end
