//
//  esriViewController.h
//  RapidReport_P
//
//  Created by hvit-pc on 14-3-13.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "TianDiTuWMTSLayer.h"
#import "NSConfigData.h"
#import <math.h>
#import "QueryParams.h"
@class esriView;
@protocol esriViewDelegate <NSObject>
-(void)esriViewDetails:(esriView *)controller details:(AGSGraphic *)agsGraphic queryParams:(QueryParams *)queryParams;

@end

@interface esriView :UIView<AGSMapViewTouchDelegate,
AGSMapViewLayerDelegate,
AGSCalloutDelegate,
AGSQueryTaskDelegate,
CLLocationManagerDelegate>

@property (weak,nonatomic) id <esriViewDelegate> delegate;

//定位相关属性
@property (nonatomic , strong)CLLocationManager *locationManager;
@property (nonatomic,strong)AGSGraphicsLayer *locationLayer;
@property (nonatomic,strong)AGSGraphic *locationGrp;
@property (assign ,nonatomic)BOOL locationState;


//叠加层
@property (nonatomic,strong)QueryParams *queryParams;
@property (nonatomic,strong)NSConfigData *configData;
@property (nonatomic,strong)NSString *dataType;
@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,strong)AGSGraphicsLayer *ghLayer;
@property (nonatomic,strong)AGSDynamicMapServiceLayer *dmsLayer;
@property (strong,nonatomic) AGSQueryTask *queryTask;
@property (strong,nonatomic) AGSQuery *query;

//@property (nonatomic,weak)NSDictionary *newsCatalog;
@property (nonatomic,weak)NSDictionary *selectCatalog;
@property (nonatomic,strong)AGSEnvelope *envelope;
@property (nonatomic,strong)AGSPoint *beginPoint;
@property (nonatomic,strong)AGSPoint *endPoint;
@property (nonatomic,strong)AGSGraphicsLayer *sketchGhLayer;

@property(nonatomic,weak) IBOutlet UIToolbar *toolView;
@property(nonatomic,weak) IBOutlet UILabel *toolLabel;
@property (nonatomic, strong) AGSSketchGraphicsLayer *sketchLayer;

@property (nonatomic, weak) IBOutlet AGSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
- (IBAction)zoomUpAct:(id)sender;
- (IBAction)zoomDownAct:(id)sender;
- (IBAction)locationAct:(id)sender;
- (IBAction)tool:(id)sender;
-(void)addCustLayer:(NSDictionary *)p_data select:(NSDictionary *)selectDic;
-(void)addEqimLayer:(NSDictionary *)p_data select:(NSDictionary *)selectDic;
-(void)addSketchLayer;
-(void)showToolView;
- (void)hiddenToolView;
-(void)addSubjectLayer:(AGSFeatureSet *)p_features select:(AGSGraphic *)p_selGp queryParams:(QueryParams *) p_queryParams;
@end
