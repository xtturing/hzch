//
//  SketchUtil.m
//  ZjGIS
//
//  Created by 余 林峰 on 2012-07-05.
//  Copyright (c) 2012年 浙江省地理信息中心. All rights reserved.
//

#import "SketchUtil.h"

@implementation SketchUtil

+(AGSGraphicsLayer*) getDefaultGraphicLayer
{
	AGSGraphicsLayer* graphicsLayer = [AGSGraphicsLayer graphicsLayer];
    
	AGSCompositeSymbol* composite = [AGSCompositeSymbol compositeSymbol];
	AGSSimpleMarkerSymbol* markerSymbol = [[AGSSimpleMarkerSymbol alloc] init] ;
	markerSymbol.style = AGSSimpleMarkerSymbolStyleCircle;
	markerSymbol.color = [UIColor greenColor];
	[composite addSymbol:markerSymbol];
	AGSSimpleLineSymbol* lineSymbol = [[AGSSimpleLineSymbol alloc] init] ;
	lineSymbol.color= [UIColor yellowColor];
	lineSymbol.width = 2;
	[composite addSymbol:lineSymbol];
	AGSSimpleFillSymbol* fillSymbol = [[AGSSimpleFillSymbol alloc] init] ;
	fillSymbol.color = [UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] ;
	[composite addSymbol:fillSymbol];
	AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:composite];
	graphicsLayer.renderer = renderer;
    
    return graphicsLayer;
}

+ (AGSGraphicsLayer*) getPointGraphicLayerWithImage:(NSString*)imageName;
{
    AGSGraphicsLayer* graphicsLayer = [AGSGraphicsLayer graphicsLayer];
    
	AGSCompositeSymbol* composite = [AGSCompositeSymbol compositeSymbol];
	AGSPictureMarkerSymbol* markerSymbol = [[AGSPictureMarkerSymbol alloc] initWithImage:[UIImage imageNamed:imageName]] ;
	[composite addSymbol:markerSymbol];
	AGSSimpleLineSymbol* lineSymbol = [[AGSSimpleLineSymbol alloc] init] ;
	lineSymbol.color= [UIColor yellowColor];
	lineSymbol.width = 2;
	[composite addSymbol:lineSymbol];
	AGSSimpleFillSymbol* fillSymbol = [[AGSSimpleFillSymbol alloc] init] ;
	fillSymbol.color = [UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] ;
	[composite addSymbol:fillSymbol];
	AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:composite];
	graphicsLayer.renderer = renderer;
    
    return graphicsLayer;
}

+ (AGSGraphicsLayer*) getDefaultLineGraphicLayer
{
    AGSGraphicsLayer* graphicsLayer = [AGSGraphicsLayer graphicsLayer];
    
	AGSCompositeSymbol* composite = [AGSCompositeSymbol compositeSymbol];
	AGSSimpleLineSymbol* lineSymbol = [[AGSSimpleLineSymbol alloc] init] ;
	lineSymbol.color= [UIColor blackColor];
	lineSymbol.width = 1;
	[composite addSymbol:lineSymbol];

	AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:composite];
	graphicsLayer.renderer = renderer;
    
    return graphicsLayer;
}

+(AGSSketchGraphicsLayer*) getSketchGraphicLayer
{
	AGSSketchGraphicsLayer* sketchLayer = [[AGSSketchGraphicsLayer alloc] initWithGeometry:nil] ;
    
	AGSCompositeSymbol* composite = [AGSCompositeSymbol compositeSymbol];
	AGSSimpleMarkerSymbol* markerSymbol = [[AGSSimpleMarkerSymbol alloc] init]  ;
	markerSymbol.style = AGSSimpleMarkerSymbolStyleSquare;
	markerSymbol.color = [UIColor greenColor];
	[composite addSymbol:markerSymbol];
	AGSSimpleLineSymbol* lineSymbol = [[AGSSimpleLineSymbol alloc] init] ;
	lineSymbol.color= [UIColor grayColor];
	lineSymbol.width = 4;
	[composite addSymbol:lineSymbol];
	AGSSimpleFillSymbol* fillSymbol = [[AGSSimpleFillSymbol alloc] init] ;
	fillSymbol.color = [UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:0.5] ;
	[composite addSymbol:fillSymbol];
	AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:composite];
	sketchLayer.renderer = renderer;
    
    return sketchLayer;
}

@end
