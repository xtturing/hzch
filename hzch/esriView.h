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
#import "NBSearchCatalog.h"
#import "NBSearch.h"
@class esriView;
@protocol esriViewDelegate <NSObject>
@optional
-(void)esriViewDetails:(esriView *)controller details:(AGSGraphic *)agsGraphic queryParams:(QueryParams *)queryParams;
-(void)didSelectLineSearch;
- (void)didDrawSearch;
-(void)mapViewDidLoad;

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
@property (nonatomic,strong)AGSGraphicsLayer *ghLayer;
@property (nonatomic,strong)AGSGraphicsLayer *lineLayer;
@property (nonatomic,strong)AGSGraphicsLayer *sketchGhLayer;

@property(nonatomic,weak) IBOutlet UIToolbar *toolView;
@property(nonatomic,weak) IBOutlet UIToolbar *drawTool;
@property(nonatomic,weak) IBOutlet UIToolbar *widthTool;
@property(nonatomic,weak) IBOutlet UIToolbar *colorTool;
@property(nonatomic,weak) IBOutlet UILabel *toolLabel;
@property (nonatomic, strong) AGSSketchGraphicsLayer *sketchLayer;

@property (nonatomic, weak) IBOutlet AGSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (nonatomic,copy) void(^ClickCalloutBlock)(NSDictionary *dic);
- (IBAction)zoomUpAct:(id)sender;
- (IBAction)zoomDownAct:(id)sender;
- (IBAction)locationAct:(id)sender;
- (IBAction)tool:(id)sender;
- (IBAction)toolDraw:(id)sender;
- (IBAction)widthTool:(id)sender;
- (IBAction)colorTool:(id)sender;
- (IBAction)widthChange:(id)sender;
-(void)addCustLayer:(NSArray *)p_data withType:(NSInteger)searchType;
-(void)addSketchLayer;
-(void)showToolView;
- (void)hiddenToolView;
- (void)changeMap:(NSInteger)index;
- (void)clearMap:(BOOL)show index:(NSInteger)index;
- (void)deleteMap;
- (void)layerMap;
- (void)addWMTSLayer:(NSNotification *)info;
- (void)addAllWmtsLayers;
- (void)touchesBegan:(UITouch*)touch;
- (void)touchesMoved:(UITouch*)touch;
- (void)touchesEnded:(UITouch*)touch;



@end
