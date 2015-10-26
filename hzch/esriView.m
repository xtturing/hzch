//
//  esriViewController.m
//  RapidReport_P
//
//  Created by hvit-pc on 14-3-13.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import "esriView.h"
#import "LineSearchTableViewController.h"
#import "CanvasView.h"
#import "MapUtil.h"
#import "dataHttpManager.h"
#import "Draw.h"
#import "GTMBase64.h"
#import "MapUtil.h"
#import "SpatialDatabase.h"

@interface esriView ()<AGSLayerDelegate>{
    double _distance;
    double _area;
    AGSSRUnit _distanceUnit;
    AGSAreaUnits _areaUnit;
    NSInteger _drawWidth;
    UIColor *_drawColor;
    NSInteger _drawIndex;
    double minx;
    double miny;
    double maxx;
    double maxy;
    BOOL isGetStartPoint;
    BOOL isGetEndPoint;
    AGSGraphic * startGra;
    AGSGraphic * endGra;
}
@property (nonatomic, strong) NSMutableArray *coordinates;
@property (nonatomic, strong) NSMutableArray *polygonPoints;
@property (nonatomic) NSInteger toolTag;
@property (nonatomic, strong) CanvasView *canvasView;

@end

@implementation esriView

- (id)initWithFrame:(CGRect)frame
{
    // Set the client ID
    NSError *error;
//    NSString* clientID = @"lsTnqx6kfd0c5Nml";
//   [AGSRuntimeEnvironment setClientID:clientID error:&error];
    if(error){
        // We had a problem using our client ID
        NSLog(@"Error using client ID : %@",[error localizedDescription]);
    }else if (self) {
        // Initialization code
        //NSLog(@"连续加载 : %@",@"测试333");
        //NSLog(@"连续加载对象 : %@",self);
        @autoreleasepool{
            NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"esriView" owner:self options: nil];
            if(arrayOfViews.count < 1){
                return nil;
            }
            self = [arrayOfViews objectAtIndex:0];
            
            CGRect r1 = CGRectMake(0, 0, frame.size.width, frame.size.height);
            
            self.frame = r1;
            isGetStartPoint = NO;
            isGetEndPoint = NO;
            //NSLog(@"连续加载对象 : %@",self.mapView);
            [self changeMap:0];
            self.mapView.layerDelegate = self;
             [self.mapView zoomToEnvelope:[AGSEnvelope envelopeWithXmin:118.02252449 ymin:27.04527654 xmax:123.1561344 ymax:31.18247145 spatialReference:self.mapView.spatialReference] animated:YES];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDrawLayer:) name:@"ADD_DRAW_LAYER" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLocalLayer:) name:@"ADD_LOCAL_LAYER" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStartPointInMap) name:@"START_POINT_IN_MAP" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEndPointInMap) name:@"END_POINT_IN_MAP" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRouteInMap:) name:@"ADD_ROUTE_IN_MAP" object:nil];
            [self locationListenner];
        }
        

    }
    return self;
}

- (void)changeMap:(NSInteger)index{
    [self clearMap:NO index:index];
    [self clearMap:YES index:index];
}

- (void)clearMap:(BOOL)show index:(NSInteger)index{
    if(show){
        NSError* err;
        TianDiTuWMTSLayer* TianDiTuLyr = [[TianDiTuWMTSLayer alloc]initWithLayerType:index?TIANDITU_IMAGE_2000:TIANDITU_VECTOR_2000 LocalServiceURL:nil error:&err];
        TianDiTuWMTSLayer* TianDiTuLyr_Anno = [[TianDiTuWMTSLayer alloc]initWithLayerType:index?TIANDITU_IMAGE_ANNOTATION_CHINESE_2000:TIANDITU_VECTOR_ANNOTATION_CHINESE_2000 LocalServiceURL:nil error:&err];
        TianDiTuWMTSLayer* TianDituLyr_zje=[[TianDiTuWMTSLayer alloc]initWithLayerType:index?TIANDITU_ZJ_IMAGE:TIANDITU_ZJ_VECTOR LocalServiceURL:nil error:&err];
        TianDiTuWMTSLayer* TianDituLyr_Anno_zje=[[TianDiTuWMTSLayer alloc]initWithLayerType:index?TIANDITU_ZJ_IMAGE_ANNOTATION:TIANDITU_ZJ_VECTOR_ANNOTATION LocalServiceURL:nil error:&err];
        [self.mapView insertMapLayer:TianDiTuLyr withName:@"TianDiTu Layer" atIndex:0];
        [self.mapView insertMapLayer:TianDiTuLyr_Anno withName:@"TianDiTu Annotation Layer" atIndex:1];
        [self.mapView insertMapLayer:TianDituLyr_zje withName:@"TianDiTu zje Layer" atIndex:2];
        if(index){
            [self.mapView insertMapLayer:TianDituLyr_Anno_zje withName:@"TianDiTu Anno zje Layer" atIndex:3];
        }
    }else{
        [self.mapView removeMapLayerWithName:@"TianDiTu Layer"];
        [self.mapView removeMapLayerWithName:@"TianDiTu Annotation Layer"];
        [self.mapView removeMapLayerWithName:@"TianDiTu zje Layer"];
        [self.mapView removeMapLayerWithName:@"TianDiTu Anno zje Layer"];
    }
}

- (void)addWMTSLayer:(NSNotification *)info{
    NSString *wmtsurl = [info.userInfo objectForKey:@"wmtsurl"];
    NSString *wmtsname = [info.userInfo objectForKey:@"wmtsname"];
    NSString *wmtsID = [info.userInfo objectForKey:@"wmtsID"];
    NSString *name = [info.userInfo objectForKey:@"name"];
    [self removeAllLayer];
    if([MapUtil hasLayerName:wmtsID mapView:self.mapView]){
        [self.mapView removeMapLayerWithName:wmtsID];
        [[dataHttpManager getInstance].resourceLayers removeObjectForKey:wmtsID];
    }else{
         NSInteger type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SHOWRESOURCETYPE"] integerValue];
        if(type == 0){
            if([dataHttpManager getInstance].resourceLayers.count > 0){
                NSArray *array = [NSArray arrayWithArray:[dataHttpManager getInstance].resourceLayers.allKeys];
                for(NSString *key in array){
                    if([MapUtil hasLayerName:key mapView:self.mapView]){
                        [self.mapView removeMapLayerWithName:key];
                        [[dataHttpManager getInstance].resourceLayers removeObjectForKey:key];
                    }
                }
                
            }
        }
        TianDiTuWMTSLayer* layer=[[TianDiTuWMTSLayer alloc]initWithLocalServiceURL:wmtsurl withLayerName:wmtsID];
        [self.mapView addMapLayer:layer withName:wmtsID];
        [[dataHttpManager getInstance].resourceLayers setObject:@[wmtsurl,wmtsname,name] forKey:wmtsID];
    }
}

- (void)addAllWmtsLayers{
    for(NSInteger i = 0; i<[dataHttpManager getInstance].resourceLayers.count ; i++){
        NSString *wmtsid = [[[dataHttpManager getInstance].resourceLayers allKeys] objectAtIndex:i];
        NSString *wmtsurl = [[dataHttpManager getInstance].resourceLayers objectForKey:wmtsid];
        TianDiTuWMTSLayer* layer=[[TianDiTuWMTSLayer alloc]initWithLocalServiceURL:wmtsurl withLayerName:wmtsid];
        [self.mapView addMapLayer:layer withName:wmtsid];
    }
    if([dataHttpManager getInstance].drawGhLayer){
        [self.mapView addMapLayer:[dataHttpManager getInstance].drawGhLayer];
    }    
}


- (void)deleteMap{
    [self clearToolAll];
    if(self.lineLayer){
        [self.mapView removeMapLayerWithName:@"lineLayer"];
        self.lineLayer = nil;
    }
//    NSArray* mapLayers = [self.mapView mapLayers];
//    for (AGSLayer* layer in mapLayers)
//    {
//        [self.mapView removeMapLayerWithName:[layer name]];
//    }
}
- (void)layerMap{
    
}

// The method that should be called when the notification arises
- (void)respondToEnvChange: (NSNotification*) notification {
    
//    if(self.locationState){
         self.locationState = NO;
        [self.locationBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
        [self.locationManager stopUpdatingLocation];
       
//    }
    
}



- (void)mapViewDidLoad:(AGSMapView *)mapView{
    if(_delegate && [_delegate respondsToSelector:@selector(mapViewDidLoad)]){
        [_delegate mapViewDidLoad];
    }
}

-(void)addCustLayer:(NSArray *)p_data withType:(NSInteger)searchType{
    self.mapView.touchDelegate = self;
    self.mapView.callout.delegate = self;
    
    self.dataDic = p_data;
    
//    [self removeAllLayer];
    if(self.ghLayer == nil){
        self.ghLayer = [[AGSGraphicsLayer alloc]init];
        [self.mapView addMapLayer:self.ghLayer withName:@"CustomLayer"];
    }
    self.ghLayer.selectionColor = [UIColor redColor];
    [self topLocationLayer];
    
    for (NSInteger i=0; i<self.dataDic.count; i++) {
        @autoreleasepool{
            NSArray *t_arr = (NSArray *)self.dataDic;
            double x = 0;
            double y = 0;
            NSString *name = @"";
            NSString *address = @"";
            NSString *t_imagePath;
            if(searchType == 0){
                NBSearch *t_att = [t_arr objectAtIndex:i];
                x = [t_att.centerx doubleValue];
                y = [t_att.centery doubleValue];
                address = t_att.address;
                name = t_att.name;
                t_imagePath = @"new_cz.png";
            }else if(searchType == 1){
                NBSearchCatalog *t_att = [t_arr objectAtIndex:i];
                x = [t_att.labelx doubleValue];
                y = [t_att.labely doubleValue];
                address = t_att.address;
                name = t_att.name;
                t_imagePath = @"cus_cz.png";
            }
            
            
            
            AGSPoint *t_point = [AGSPoint pointWithX:x
                                                   y:y
                                    spatialReference:self.mapView.spatialReference];
            
//            UIImage *t_m;
//            t_m =  [self.configData addImageText:[UIImage imageNamed:t_imagePath] text:t_att.name];
            
            AGSPictureMarkerSymbol *picMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:t_imagePath]];
            NSArray *tipkey=[[NSArray alloc]initWithObjects:@"detail",@"title",@"type",@"object",nil];
            NSArray *tipvalue=[[NSArray alloc]initWithObjects:address,name,@(searchType),[t_arr objectAtIndex:i],nil];
            NSMutableDictionary * tips=[[NSMutableDictionary alloc]initWithObjects:tipvalue forKeys:tipkey];
            AGSGraphic *t_gh = [AGSGraphic graphicWithGeometry:t_point symbol:picMarkerSymbol attributes:tips infoTemplateDelegate:nil];
            
            [self.ghLayer addGraphic:t_gh];
            [self showCallOut:t_gh title:name detail:address];
        }
    }
    [self.ghLayer refresh];
    ALERT(@"已添加到地图");

}
-(void)addOneSearchCustLayer:(NBSearch *)search{
    self.mapView.touchDelegate = self;
    self.mapView.callout.delegate = self;
    
    [self removeAllLayer];
    
    self.ghLayer = [[AGSGraphicsLayer alloc]init];
    self.ghLayer.selectionColor = [UIColor redColor];
    [self.mapView addMapLayer:self.ghLayer withName:@"CustomLayer"];
    [self topLocationLayer];
    NSString *t_imagePath;
    t_imagePath = @"new_cz.png";
    
    AGSPoint *t_point = [AGSPoint pointWithX:[search.centerx doubleValue]
                                           y:[search.centery doubleValue]
                            spatialReference:self.mapView.spatialReference];
    
    //            UIImage *t_m;
    //            t_m =  [self.configData addImageText:[UIImage imageNamed:t_imagePath] text:t_att.name];
    
    AGSPictureMarkerSymbol *picMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:[UIImage imageNamed:t_imagePath]];
    NSArray *tipkey=[[NSArray alloc]initWithObjects:@"detail",@"title",@"object",nil];
    NSArray *tipvalue=[[NSArray alloc]initWithObjects:search.address,search.name,search,nil];
    NSMutableDictionary * tips=[[NSMutableDictionary alloc]initWithObjects:tipvalue forKeys:tipkey];
    AGSGraphic *t_gh = [AGSGraphic graphicWithGeometry:t_point symbol:picMarkerSymbol attributes:tips infoTemplateDelegate:nil];
    
    [self.ghLayer addGraphic:t_gh];
    [self showCallOut:t_gh title:search.name detail:search.address];
    
}
//画图
-(void)addSketchGhLayer{
    
    if(![self hasLayer:@"sketchGhLayer"])
    {
        self.sketchGhLayer= [[AGSGraphicsLayer alloc]init];
        [[dataHttpManager getInstance].drawLayers removeAllObjects];
        [self.mapView addMapLayer:self.sketchGhLayer withName:@"sketchGhLayer"];
        
    }
}

- (void)addSketchLayer{
    
    if(![self hasLayer:@"sketchLayer"])
    {
        self.sketchLayer = [AGSSketchGraphicsLayer graphicsLayer];
         [self.mapView addMapLayer:self.sketchLayer withName:@"sketchLayer"];
    }
    self.mapView.touchDelegate = self.sketchLayer;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToGeomChanged:) name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
}

- (void)hiddenToolView{
    if(_toolView && (!_toolView.hidden || !_toolLabel.hidden)){
        [_toolView setHidden:YES];
        [_toolLabel setHidden:YES];
        [_drawTool setHidden:YES];
        [_colorTool setHidden:YES];
        [_widthTool setHidden:YES];
    }
}

- (void)clearToolAll{
    self.sketchLayer = nil;
    self.sketchGhLayer = nil;
    [dataHttpManager getInstance].drawGhLayer=nil;
    [[dataHttpManager getInstance].drawLayers removeAllObjects];
    self.canvasView.image = nil;
    [self.canvasView removeFromSuperview];
    [self.coordinates removeAllObjects];
    self.sketchLayer.geometry = nil;
    self.mapView.touchDelegate = nil;
    if([self hasLayer:@"sketchLayer"])
    {
        [_mapView removeMapLayerWithName:@"sketchLayer"];
    }
    if([self hasLayer:@"sketchGhLayer"])
    {
        [_mapView removeMapLayerWithName:@"sketchGhLayer"];
    }
    [self.mapView.callout removeFromSuperview];
    [self removeAllLayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
}

- (void)showToolView{
    if(!_toolView.hidden || !_toolLabel.hidden){
        [self hiddenToolView];
    }else{
        [_toolView setHidden:NO];
        [_toolLabel setHidden:NO];
        self.toolLabel.text = @"请选择使用工具";
        // Set the default measures and units
        _distance = 0;
        _area = 0;
        _drawWidth = 2.0;
        _drawIndex = 4001;
        _drawColor = [UIColor redColor];
        _distanceUnit = AGSSRUnitKilometer;
        _areaUnit = AGSAreaUnitsSquareKilometers;
    }
}

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics{
    if(isGetEndPoint || isGetStartPoint){
        [self addLineStartEndPoint:mappoint];
    }else{
        if ([self.ghLayer graphicsCount]>0) {
            AGSGraphic *t_selgh ;
            for (AGSGraphic *t_gh in [self.ghLayer graphics]) {
                
                CGPoint pointVar = [mapView toScreenPoint:(AGSPoint *)[t_gh geometry]];
                if (sqrt((screen.x-pointVar.x)*(screen.x-pointVar.x)+(screen.y-pointVar.y)*(screen.y-pointVar.y))<20) {
                    t_selgh = t_gh;
                    break;
                }
            }
            if([self.ghLayer.name isEqualToString:@"CustomLayer"]){
                [self showCallOut:t_selgh title:[t_selgh attributeAsStringForKey:@"title"] detail:[t_selgh attributeAsStringForKey:@"detail"]];
            }
            
        }
        for (NSString *name in [dataHttpManager getInstance].sqliteLayers) {
            AGSGraphicsLayer *localLayer = (AGSGraphicsLayer *)[self.mapView mapLayerForName:name];
            if( localLayer && [localLayer graphicsCount] > 0){
                AGSGraphic *t_selgh ;
                for (AGSGraphic *t_gh in [localLayer graphics]) {
                    
                    CGPoint pointVar = [mapView toScreenPoint:(AGSPoint *)[t_gh geometry]];
                    if (sqrt((screen.x-pointVar.x)*(screen.x-pointVar.x)+(screen.y-pointVar.y)*(screen.y-pointVar.y))<15) {
                        t_selgh = t_gh;
                        break;
                    }
                }
                [self showCallOut:t_selgh title:[t_selgh attributeAsStringForKey:@"title"] detail:[t_selgh attributeAsStringForKey:@"detail"]];
            }
        }
    }
    
}

-(void)showCallOut:(AGSGraphic *)p_selectGp title:(NSString *)p_title detail:(NSString *)p_detail{
    
    [self.ghLayer clearSelection];

    if (p_selectGp) {
        if (p_title.length> 10) {
            self.mapView.callout.title = [[p_title substringToIndex:10] stringByAppendingString:@"..."];
        }else{
            self.mapView.callout.title = p_title;
        }
        if (p_detail.length> 17) {
            self.mapView.callout.detail = [[p_detail substringToIndex:17] stringByAppendingString:@"..."];
        }else{
            self.mapView.callout.detail = p_detail;
        }


        self.mapView.callout.accessoryButtonType = UIButtonTypeCustom;
        self.mapView.callout.accessoryButtonImage = [UIImage imageNamed:@"callRight.png"];
        self.mapView.callout.accessoryButtonHidden = NO;
        
        [self.mapView.callout showCalloutAtPoint:(AGSPoint *)p_selectGp.geometry forGraphic:p_selectGp animated:YES];
        [self.ghLayer setSelected:YES forGraphic:p_selectGp];
        [self.mapView centerAtPoint:(AGSPoint *)[p_selectGp geometry] animated:YES];
    }
    
}

- (void) didClickAccessoryButtonForCallout:(AGSCallout *)callout{

}



//定位监听
-(void)locationListenner{
    if([CLLocationManager locationServicesEnabled]){
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorized:
            case kCLAuthorizationStatusNotDetermined:
                // 创建并初始化location manager对象
                self.locationManager = [[CLLocationManager alloc] init];
                
                // 完成下面一行以后出现警告提示，暂时不用管它
                self.locationManager.delegate = self;
                
                // 设定location manager的监测距离为最小距离
                [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
                
                //设定location manager 的精确度
                [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
                
                // 立即开始定位当前位置
                [self.locationManager startUpdatingLocation];
                self.locationState = NO;
                
                break;
            case kCLAuthorizationStatusDenied:
                ALERT(@"定位服务被使用者禁止了。");
                break;
            case kCLAuthorizationStatusRestricted:
                ALERT(@"家长控制限制了定位服务");
                break;
            default:
                break;
        }
    }else{
        
        ALERT(@"IOS系统的定位服务被禁止!");
    }
    
}

//协议中的方法，作用是每当位置发生更新时会调用的委托方法
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //结构体，存储位置坐标
    CLLocationCoordinate2D loc = [newLocation coordinate];

    //NSLog(@"IS NIL TEST %@" ,@"位置发生变化");
    //NSLog(@"x位置 %f",loc.longitude);
    //NSLog(@"x位置 %f",loc.latitude);
    
    
    self.locationLayer = [self getLocationLayer:self.mapView x:loc.longitude y:loc.latitude];
    [self.mapView removeMapLayerWithName:@"GPS Location Layer"];
    [self.mapView addMapLayer:self.locationLayer withName:@"GPS Location Layer"];
}
-(void)topLocationLayer{
    if (self.locationLayer !=nil) {
        //NSLog(@"IS NIL TEST %@" ,@"3.0");
        //NSLog(@"IS NIL TEST %@" ,self.locationLayer);
        //[self.mapView removeMapLayerWithName:@"GPS Location Layer"];
        
        //[self.mapView addMapLayer:self.locationLayer withName:@"GPS Location Layer"];
        
    }
}

-(void)removeAllLayer{
    if (self.ghLayer !=nil) {
        [self.mapView removeMapLayer:self.ghLayer];
        self.ghLayer = nil;
    }
}

//活的定位图层
-(AGSGraphicsLayer*)getLocationLayer:(AGSMapView *)p_mapView x:(double)p_x y:(double)p_y{
    
    @autoreleasepool {
        AGSGraphicsLayer *locationLayer = [[AGSGraphicsLayer alloc]init];
        AGSPoint *locationPoint = [AGSPoint pointWithX:p_x y:p_y spatialReference:p_mapView.spatialReference];
        AGSPictureMarkerSymbol *picMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"locMark.png"];
        
        
        // A symbol for the buffer
        AGSSimpleFillSymbol *innerSymbol = [AGSSimpleFillSymbol simpleFillSymbol];
        innerSymbol.color = [[UIColor blueColor] colorWithAlphaComponent:0.20];
        innerSymbol.outline.color = [UIColor darkGrayColor];
        
        // Create the buffer graphics using the geometry engine
        AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
        AGSGeometry *newGeometry = [geometryEngine bufferGeometry:locationPoint byDistance:0.0005];
        AGSGraphic *newGraphic = [AGSGraphic graphicWithGeometry:newGeometry symbol:innerSymbol attributes:nil infoTemplateDelegate:nil];
        
        self.locationGrp = [AGSGraphic graphicWithGeometry:locationPoint symbol:picMarkerSymbol attributes:nil infoTemplateDelegate:nil];
        [locationLayer removeAllGraphics];
        
        [locationLayer addGraphic:newGraphic];
        [locationLayer addGraphic:self.locationGrp];
        
        return locationLayer;
    }
    
}

-(double)degressTodouble:(double *)degress{

    return *degress;
}

- (IBAction)zoomUpAct:(id)sender {
    [self.mapView zoomOut:YES];
}

- (IBAction)zoomDownAct:(id)sender {
    [self.mapView zoomIn:YES];
}

- (IBAction)locationAct:(id)sender {
    if (!self.locationState) {
        [self.locationBtn setImage:[UIImage imageNamed:@"locActive"] forState:UIControlStateNormal];
        [self.locationManager startUpdatingLocation];
        self.locationState = YES;
    }else{
        [self.locationBtn setImage:[UIImage imageNamed:@"location_click"] forState:UIControlStateNormal];
        [self.locationManager stopUpdatingLocation];
        self.locationState = NO;
    }
    
}

#pragma mark -measure

- (void)respondToGeomChanged:(NSNotification*)notification {
    
    AGSGeometry *sketchGeometry = self.sketchLayer.geometry;
    if (![sketchGeometry isValid]) {
        return;
    }
    // Update the distance and area whenever the geometry changes
    if ([sketchGeometry isKindOfClass:[AGSMutablePolyline class]] && self.toolTag == 1001 ) {
        [self updateDistance:_distanceUnit];
    }
    else if ([sketchGeometry isKindOfClass:[AGSMutablePolygon class]]){
        [self updateArea:_areaUnit];
    }
}

- (void)updateDistance:(AGSSRUnit)unit {
    
    // Get the sketch layer's geometry
    AGSGeometry *sketchGeometry = self.sketchLayer.geometry;
    AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
    
    // Get the geodesic distance of the current line
    _distance = [geometryEngine geodesicLengthOfGeometry:sketchGeometry inUnit:_distanceUnit];
    if(_distance == 0){
        self.toolLabel.text = @"请在地图上点击画线测量距离";
    }else{
        self.toolLabel.text = [NSString stringWithFormat:@"测量距离：%.2f 公里", _distance];
    }
}

- (void)updateArea:(AGSAreaUnits)unit {
    
    // Get the sketch layer's geometry
    AGSGeometry *sketchGeometry = self.sketchLayer.geometry;
    AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
    
    // Get the area of the current polygon
    
    _area = [geometryEngine shapePreservingAreaOfGeometry:sketchGeometry inUnit:_areaUnit];
    if(_area == 0){
        self.toolLabel.text = @"请在地图上点击画面测量面积";
    }else{
        self.toolLabel.text = [NSString stringWithFormat:@"测量区域面积：%.4f 平方公里", _area];
    }
}
#pragma mark - toolDelegate
- (IBAction)tool:(id)sender{
    [self clearToolAll];
    UIBarButtonItem *btnItem = (UIBarButtonItem *)sender;
    self.toolTag = btnItem.tag;
    self.drawTool.hidden = YES;
    switch (self.toolTag) {
        case 1001:
        {
            [self addSketchLayer];
            self.toolLabel.text = @"请在地图上点击画线测量距离";
            self.sketchLayer.geometry = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
            self.mapView.touchDelegate = self.sketchLayer;
        }
            break;
            
        case 1002:
        {
            [self addSketchLayer];
            self.toolLabel.text = @"请在地图上点击画面测量面积";
            self.sketchLayer.geometry = [[AGSMutablePolygon alloc] initWithSpatialReference:self.mapView.spatialReference];
            self.mapView.touchDelegate = self.sketchLayer;
        }
            break;
            
        case 1003:
        {
            [self addSketchLayer];
            [self addSketchGhLayer];
            self.toolLabel.text = @"请在地图上点击开始标绘";
            self.drawTool.hidden = NO;
            self.sketchLayer.geometry = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
            self.mapView.touchDelegate = self.sketchLayer;
            [self.sketchLayer.undoManager removeAllActions];
        }
            break;
            
        case 1004:
        {
            if([dataHttpManager getInstance].resourceLayers.count > 0){
                self.toolLabel.text = @"请在地图上用手势画框查询";
                [self.coordinates removeAllObjects];
                [self.mapView addSubview:self.canvasView];
                [self addSketchGhLayer];
            }else{
                ALERT(@"请先添加专题图层！");
            }
            
        }
            break;
        case 1005:
        {
            self.toolLabel.text = @"请在地图上点击两点路径查询";
            isGetStartPoint = NO;
            isGetEndPoint = NO;
            if(_delegate && [_delegate respondsToSelector:@selector(didSelectLineSearch)]){
                [_delegate didSelectLineSearch];
            }
        }
            break;
        case 1006:
        {
            self.toolLabel.text = @"清空所有工具栏操作";
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)toolDraw:(id)sender{
    UIBarButtonItem *btnItem = (UIBarButtonItem *)sender;
    switch (btnItem.tag) {
        case 2001:
        {
            self.widthTool.hidden = NO;
            self.toolLabel.text = @"请选择标绘的线条宽度";
            [self bringSubviewToFront:self.widthTool];
        }
            break;
            
        case 2002:
        {
            self.colorTool.hidden = NO;
            self.toolLabel.text = @"请选择标绘的线条颜色";
            [self bringSubviewToFront:self.colorTool];
        }
            break;
            
        case 2003:
        {
            if([self.sketchLayer.undoManager canUndo]) //extra check, just to be sure
                [self.sketchLayer.undoManager undo];
        }
            break;
            
        case 2004:
        {
            if([self.sketchLayer.undoManager canRedo]) //extra check, just to be sure
                [self.sketchLayer.undoManager redo];
        }
            break;
        case 2005:
        {
            [self didSaveDrawing];
        }
            break;
        case 2006:
        {
            [self didSaveDrawing];
            self.drawTool.hidden = YES;
        }
            break;
        case 2007:
        {
            self.drawTool.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (IBAction)colorTool:(id)sender{
    UIBarButtonItem *btnItem = (UIBarButtonItem *)sender;
    switch (btnItem.tag) {
        case 4001:
        {
            _drawColor = [UIColor redColor];
            _drawIndex = btnItem.tag;
        }
            break;
            
        case 4002:
        {
            _drawColor = [UIColor blueColor];
            _drawIndex = btnItem.tag;
        }
            break;
            
        case 4003:
        {
            _drawColor = [UIColor greenColor];
            _drawIndex = btnItem.tag;
        }
            break;
            
        case 4004:
        {
            _drawColor = [UIColor purpleColor];
            _drawIndex = btnItem.tag;
        }
            break;
        case 4005:
        {
            self.colorTool.hidden = YES;
            self.toolLabel.text = @"请在地图上点击开始标绘";
        }
            break;
        default:
            break;
    }
}
- (IBAction)widthTool:(id)sender{
    UIBarButtonItem *btnItem = (UIBarButtonItem *)sender;
    switch (btnItem.tag) {
            
        case 3002:
        {
            self.widthTool.hidden = YES;
            self.toolLabel.text = @"请在地图上点击开始标绘";
        }
            break;
        default:
            break;
    }
}

- (IBAction)widthChange:(id)sender{
    UISlider *slider = (UISlider *)sender;
    _drawWidth = slider.value;
}

- (void)didTouchUpInsideDrawButton
{
    NSInteger numberOfPoints = [self.coordinates count];
    
    if (numberOfPoints > 2)
    {
        AGSSimpleFillSymbol
        *outerSymbol = [AGSSimpleFillSymbol simpleFillSymbol];
        outerSymbol.color
        = [[UIColor yellowColor] colorWithAlphaComponent:0.25];
        outerSymbol.outline.color
        = [UIColor darkGrayColor];
        AGSMutablePolygon *polyon =  [[AGSMutablePolygon alloc] initWithSpatialReference:self.mapView.spatialReference];
        [polyon addRingToPolygon];
        for (AGSPoint *point in self.coordinates) {
            [polyon addPointToRing:point];
        }
        
        AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:polyon symbol:outerSymbol attributes:nil];
        [self.sketchGhLayer addGraphic:graphic];
        [self.sketchGhLayer refresh];
        [self doTouchDrawSearch];
    }
    self.canvasView.image = nil;
    [self.coordinates removeAllObjects];
    [self.canvasView removeFromSuperview];
}

- (void)didSaveDrawing
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"标绘名称", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 70009;
    UITextField *textfield =  [alert textFieldAtIndex: 0];
    textfield.placeholder = @"请输入标绘名称";
    textfield.clearButtonMode = UITextFieldViewModeAlways;
    [alert show];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 70009)
    {
        if (buttonIndex == 1)
        {
            UITextField *textfield =  [alertView textFieldAtIndex: 0];
            if(textfield.text.length > 1){
                AGSGeometry* sketchGeometry = [self.sketchLayer.geometry copy];
                AGSSimpleLineSymbol
                *outerSymbol = [AGSSimpleLineSymbol simpleLineSymbol];
                outerSymbol.color
                = _drawColor;
                outerSymbol.width = _drawWidth;
                AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:sketchGeometry symbol:outerSymbol attributes:nil];
                [self.sketchGhLayer addGraphic:graphic];
                [self.sketchGhLayer refresh];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    Draw *draw = [[Draw alloc] init];
                    draw.name = textfield.text;
                    draw.createDate = [[NSDate date] timeIntervalSince1970]*1000;
                    NSDictionary *dic = @{@"color":@(_drawIndex),@"width":@(_drawWidth),@"geometry":[[sketchGeometry encodeToJSON] ags_JSONRepresentation]};
                    NSError *error;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                         error:&error];
                    draw.sourceData = jsonData;
                    [[dataHttpManager getInstance].drawDB insertDraw:draw];
                    [[dataHttpManager getInstance].drawLayers addObject:[NSString stringWithFormat:@"%ld",draw.createDate]];
                });
                [self.sketchLayer clear];
                [self.sketchLayer.undoManager removeAllActions];
            }
            
        }
    }
    return;
}

- (void)addLocalLayer:(NSNotification *)info{
    NSString *layerurl = [info.userInfo objectForKey:@"localurl"];
    NSString *layername = [info.userInfo objectForKey:@"name"];
    NSArray *array = [[layerurl description] componentsSeparatedByString:@"/"];
    NSString *name = [array objectAtIndex:(array.count-1)];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *desPath=[[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"] stringByAppendingPathComponent:name];
    if([[name pathExtension] isEqualToString:@"tpk"]){
        if(![self hasAddLocalLayer:layerurl]){
            NSInteger type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SHOWRESOURCETYPE"] integerValue];
            if(type == 0){
                for(NSString *url in [dataHttpManager getInstance].localLayers){
                    NSArray *arrayurl = [[url description] componentsSeparatedByString:@"/"];
                    NSString *layername = [arrayurl objectAtIndex:(arrayurl.count-1)];
                    [self.mapView removeMapLayerWithName:layername];
                }
                [[dataHttpManager getInstance].localLayers removeAllObjects];
            }
            AGSLocalTiledLayer *localTileLayer = [[AGSLocalTiledLayer alloc] initWithPath:desPath];
            localTileLayer.delegate =self;
            if(localTileLayer != nil){
                [self.mapView addMapLayer:localTileLayer withName:name];
                [self.mapView zoomIn:YES];
            }
            [[dataHttpManager getInstance].localLayers addObject:layerurl];
        }else{
            [self.mapView removeMapLayerWithName:name];
            [[dataHttpManager getInstance].localLayers removeObject:layerurl];
            ALERT(@"离线数据已从地图移除");
        }
    }
    
    if([[name pathExtension] isEqualToString:@"sqlite"] ){
        if(![self hasShowSqlite:layername]){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SpatialDatabase *db = [SpatialDatabase databaseWithPath:desPath];
                [db open];
                FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select *, AsGeoJSON(Geometry) AS GEOJSON FROM %@",layername]];
                NSMutableArray *list = [NSMutableArray arrayWithCapacity:0];
                NSDictionary *column = nil;
                while ([rs next]) {
                    column = [rs resultDictionary];
                    [list addObject:column];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(list.count > 0){
                        [self addLocalGeomery:list layerName:layername];
                        [[dataHttpManager getInstance].sqliteLayers addObject:layername];
                        ALERT(@"离线数据已添加到地图");
                    }else{
                        ALERT(@"离线数据为空");
                    }
                });
            });
        }else{
            [[dataHttpManager getInstance].sqliteLayers removeObject:layername];
            [self.mapView removeMapLayerWithName:layername];
            [self.mapView.callout removeFromSuperview];
            ALERT(@"离线数据已从地图移除");
        }
        
    }
}

- (void)addLocalGeomery:(NSMutableArray *)list layerName:(NSString *)name{
    self.mapView.touchDelegate = self;
    self.mapView.callout.delegate = self;
     NSInteger type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SHOWRESOURCETYPE"] integerValue];
    if(type == 0){
        for(NSString *name in [dataHttpManager getInstance].sqliteLayers){
            [self.mapView removeMapLayerWithName:name];
        }
        [[dataHttpManager getInstance].sqliteLayers removeAllObjects];
        [self.mapView.callout removeFromSuperview];
    }
    AGSGraphicsLayer *localLayer = [[AGSGraphicsLayer alloc]init];
    [self.mapView addMapLayer:localLayer withName:name];
    localLayer.selectionColor = [UIColor redColor];
    
    for (NSDictionary *dic in list) {
        @autoreleasepool{
            NSString *name = [dic objectForKey:@"NAME"];
            NSString *address = [dic objectForKey:@"ADDRESS"];
            NSString *jsonString  = [dic objectForKey:@"GEOJSON"];
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *geoDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            if([[geoDic objectForKey:@"type"] isEqualToString:@"Point"]){
                NSArray *array = [geoDic objectForKey:@"coordinates"];
                if(array.count == 2){
                    AGSPoint *point = [AGSPoint pointWithX:[[array objectAtIndex:0] doubleValue] y:[[array objectAtIndex:1] doubleValue] spatialReference:self.mapView.spatialReference];
                    AGSSimpleMarkerSymbol* generalPointSymbol = [[AGSSimpleMarkerSymbol alloc] init];
                    generalPointSymbol.style = AGSSimpleMarkerSymbolStyleCross;
                    generalPointSymbol.color = [UIColor redColor];
                    generalPointSymbol.size = CGSizeMake(15, 15);
                    NSArray *tipkey=[[NSArray alloc]initWithObjects:@"detail",@"title",@"object",nil];
                    NSArray *tipvalue=[[NSArray alloc]initWithObjects:address,name,dic,nil];
                    NSMutableDictionary * tips=[[NSMutableDictionary alloc]initWithObjects:tipvalue forKeys:tipkey];
                    AGSGraphic *gra = [AGSGraphic graphicWithGeometry:point symbol:generalPointSymbol attributes:tips infoTemplateDelegate:nil];
                    [localLayer addGraphic:gra];
                    [self showCallOut:gra title:name detail:address];
                }
                
            }
            
        }
    }
    [localLayer refresh];
}

-(void)layerDidLoad:(AGSLayer *)layer{
    if([layer isKindOfClass:[AGSLocalTiledLayer class]]){
        ALERT(@"离线数据已添加到地图");
    }
}


-(void)layer:(AGSLayer *)layer didFailToLoadWithError:(NSError *)error{
    if([layer isKindOfClass:[AGSLocalTiledLayer class]]){
        ALERT(@"加载离线数据失败");
    }
}

- (void)addLocalTileLayerWithName:(NSString *)fileName{
    NSString *name = [fileName stringByDeletingPathExtension];
    NSString *extension = @"tpk";
    if(![self hasAddLocalLayer:name] && [[fileName pathExtension] isEqualToString:extension]){
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *desPath=[[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"]  stringByAppendingPathComponent:fileName];
        AGSLocalTiledLayer *localTileLayer = [[AGSLocalTiledLayer alloc] initWithPath:desPath];
        localTileLayer.delegate =self;
        if(localTileLayer != nil){
            [self.mapView reset];
            [self.mapView addMapLayer:localTileLayer withName:name];
            [self.mapView zoomIn:YES];
            // Do any additional setup after loading the view from its nib.
            
        }
    }else{
        [self.mapView removeMapLayerWithName:name];
    }
}

- (void)removeLocalTileLayer:(NSNotification *)notification{
    NSString *fileName = [notification.userInfo objectForKey:@"name"];
    NSString *name = [fileName stringByDeletingPathExtension];
    [self.mapView removeMapLayerWithName:name];
}


- (void)addDrawLayer:(NSNotification *)info{
    [self addSketchGhLayer];
    Draw *draw = [info.userInfo objectForKey:@"draw"];
    if(![self hasShowDraw:[NSString stringWithFormat:@"%ld",draw.createDate]]){
        [[dataHttpManager getInstance].drawLayers addObject:[NSString stringWithFormat:@"%ld",draw.createDate]];
        ALERT(@"标绘已添加到地图");
    }else{
        [[dataHttpManager getInstance].drawLayers removeObject:[NSString stringWithFormat:@"%ld",draw.createDate]];
        ALERT(@"标绘已从地图移除");
    }
    NSArray *allDraws = [[dataHttpManager getInstance].drawDB getAllDraws];
    for(NSString *createDate in [dataHttpManager getInstance].drawLayers){
        for(Draw *newdraw in allDraws){
            if(newdraw.createDate == [createDate longLongValue]){
                NSDictionary *dic = [newdraw.sourceData ags_JSONValue];
                AGSGeometry* sketchGeometry = AGSGeometryWithJSON([[dic objectForKey:@"geometry"] ags_JSONValue]);
                AGSSimpleLineSymbol
                *outerSymbol = [AGSSimpleLineSymbol simpleLineSymbol];
                switch ([[dic objectForKey:@"color"] integerValue]) {
                    case 4001:
                    {
                        outerSymbol.color = [UIColor redColor];
                    }
                        break;
                        
                    case 4002:
                    {
                        outerSymbol.color = [UIColor blueColor];
                    }
                        break;
                        
                    case 4003:
                    {
                        outerSymbol.color = [UIColor greenColor];
                    }
                        break;
                        
                    case 4004:
                    {
                        outerSymbol.color = [UIColor purpleColor];
                    }
                        break;
                    default:
                        outerSymbol.color = [UIColor redColor];
                        break;
                }
                outerSymbol.width = [[dic objectForKey:@"width"] floatValue];
                AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:sketchGeometry symbol:outerSymbol attributes:nil];
                
                [self.sketchGhLayer addGraphic:graphic];
                [self.sketchGhLayer refresh];
            }
        }
    }
    
}

- (BOOL)hasShowSqlite:(NSString *)cellTag{
    for (id tag in [dataHttpManager getInstance].sqliteLayers) {
        if([cellTag isEqualToString: tag]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasShowDraw:(NSString *)cellTag{
    for (id tag in [dataHttpManager getInstance].drawLayers) {
        if([cellTag isEqualToString: tag]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasAddLocalLayer:(NSString *)name{
    for(NSString *layerurl in [dataHttpManager getInstance].localLayers){
        if([layerurl isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasLayer:(NSString *)name{
    for(AGSLayer *layer in self.mapView.mapLayers){
        if([layer.name isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}
- (NSMutableArray*)coordinates
{
    if(_coordinates == nil) _coordinates = [[NSMutableArray alloc] init];
    return _coordinates;
}


- (CanvasView*)canvasView
{
    if(_canvasView == nil) {
        _canvasView = [[CanvasView alloc] initWithFrame:self.mapView.frame];
        _canvasView.userInteractionEnabled = YES;
        _canvasView.delegate = self;
    }
    return _canvasView;
}
- (void)touchesBegan:(UITouch*)touch
{
    CGPoint location = [touch locationInView:self.mapView];
    AGSPoint *point = [self.mapView toMapPoint:location];
    [self.coordinates addObject:point];
    minx = point.x;
    miny = point.y;
    maxx = point.x;
    maxy = point.y;
}

- (void)touchesMoved:(UITouch*)touch
{
    CGPoint location = [touch locationInView:self.mapView];
    AGSPoint *point = [self.mapView toMapPoint:location];
    [self.coordinates addObject:point];
    [self getMinMax:point];
}

- (void)touchesEnded:(UITouch*)touch
{
    CGPoint location = [touch locationInView:self.mapView];
    AGSPoint *point = [self.mapView toMapPoint:location];
    [self.coordinates addObject:point];
    [self getMinMax:point];
    if(self.toolTag == 1004){
        [self didTouchUpInsideDrawButton];
    }
}

- (void)getMinMax:(AGSPoint *)point{
    double x = point.x;
    double y = point.y;
    if(x < minx){
        minx = x;
    }
    if(x > maxx){
        maxx = x;
    }
    
    if(y < miny){
        miny = y;
    }
    if(y > maxy){
        maxy = y;
    }
}

- (void)doTouchDrawSearch{
    [dataHttpManager getInstance].drawPoints = @[@(minx),@(miny),@(maxx),@(maxy)];
    [dataHttpManager getInstance].drawGhLayer = self.sketchGhLayer;
    if(_delegate && [_delegate respondsToSelector:@selector(didDrawSearch)]){
        [_delegate didDrawSearch];
    }
}

- (void)getStartPointInMap{
    self.mapView.touchDelegate = self;
    isGetStartPoint = YES;
    self.toolLabel.adjustsFontSizeToFitWidth = YES;
    self.toolLabel.text = @"请在地图上选择起始点，完成后继续点击路径查询";
}

- (void)getEndPointInMap{
    self.mapView.touchDelegate = self;
    isGetEndPoint = YES;
    self.toolLabel.adjustsFontSizeToFitWidth = YES;
    self.toolLabel.text = @"请在地图上选择终止点，完成后继续点击路径查询";
}

-(void)addLineStartEndPoint:(AGSPoint *)mappoint{
    
    if(startGra && isGetStartPoint){
        [self.lineLayer removeGraphic:startGra];
        startGra = nil;
    }
    if(endGra && isGetEndPoint){
        [self.lineLayer removeGraphic:endGra];
        endGra = nil;
    }
    if(self.lineLayer == nil){
        self.lineLayer = [[AGSGraphicsLayer alloc]init];
        [self.mapView addMapLayer:self.lineLayer withName:@"lineLayer"];
    }
    AGSPictureMarkerSymbol * dian = nil;
    if(isGetStartPoint){
        dian = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"qidian"];
    }
    if(isGetEndPoint){
        dian = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"zhongdian"];
    }
    dian.size = CGSizeMake(32,47);
    dian.offset = CGPointMake(0, 24);
    if(mappoint.x == 0 || mappoint.y == 0 ){
        return;
    }
    if(isGetStartPoint){
        startGra = [AGSGraphic graphicWithGeometry:mappoint symbol:nil attributes:nil];
        startGra.symbol = dian;
        [self.lineLayer addGraphic:startGra];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ADD_START_POINT" object:nil userInfo:@{@"point":[NSString stringWithFormat:@"%f,%f",mappoint.x,mappoint.y]}];
    }
    if(isGetEndPoint){
        endGra = [AGSGraphic graphicWithGeometry:mappoint symbol:nil attributes:nil];
        endGra.symbol = dian;
        [self.lineLayer addGraphic:endGra];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ADD_END_POINT" object:nil userInfo:@{@"point":[NSString stringWithFormat:@"%f,%f",mappoint.x,mappoint.y]}];
    }
    [self.lineLayer refresh];
}
-(void)doRouteInMap:(NSNotification *)info{
    NBRoute *route = [info.userInfo objectForKey:@"route"];
    AGSPictureMarkerSymbol * jingguo = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"last_cz"];
    AGSSimpleLineSymbol* lineSymbol = [AGSSimpleLineSymbol simpleLineSymbol];
    lineSymbol.color =[UIColor colorWithRed:45.0/255.0 green:140.0/255.0  blue:58.0/255.0 alpha:1.0];
    lineSymbol.width = 4;
    
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *lines = [[NSMutableArray alloc] initWithCapacity:0];
    [self.lineLayer removeAllGraphics];
    [self.lineLayer refresh];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for(NBSimpleRoute *item in route.simpleRouteList){
            if(item.turnlatlon.length > 0 && item.streetLatLon.length > 0){
                AGSGraphic * pointgra= nil;
                AGSGraphic * linegra=nil;
                AGSMutablePolyline* poly = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
                [poly addPathToPolyline];
                
                NSArray *array = [item.turnlatlon componentsSeparatedByString:@","];
                if(array.count == 2){
                    AGSPoint *point = [AGSPoint pointWithX:[[array objectAtIndex:0] doubleValue] y:[[array objectAtIndex:1] doubleValue] spatialReference:self.mapView.spatialReference];
                    pointgra = [AGSGraphic graphicWithGeometry:point symbol:nil attributes:nil infoTemplateDelegate:nil];
                    pointgra.symbol = jingguo;
                    [points addObject:pointgra];
                }
                
                NSArray *latlon=[item.streetLatLon componentsSeparatedByString:@";"];
                for (int i=0; i<latlon.count; i++) {
                    NSString *str=[latlon objectAtIndex:i];
                    NSArray *coor=[str componentsSeparatedByString:@","];
                    if(coor.count==2){
                        AGSPoint *point =	[AGSPoint pointWithX:[[coor objectAtIndex:0] doubleValue]  y: [[coor objectAtIndex:1] doubleValue] spatialReference:nil];
                        [poly addPointToPath:point];
                    }
                }
                linegra = [AGSGraphic graphicWithGeometry:poly symbol:lineSymbol attributes:nil infoTemplateDelegate:nil];
                [lines addObject:linegra];
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.lineLayer addGraphics:lines];
            [self.lineLayer addGraphics:points];
            NSArray *array = [route.orig componentsSeparatedByString:@","];
            if(array.count == 2){
                isGetStartPoint = YES;
                [self addLineStartEndPoint:[AGSPoint pointWithX:[[array objectAtIndex:0] doubleValue] y:[[array objectAtIndex:1] doubleValue] spatialReference:nil]];
                isGetStartPoint = NO;
            }
            array = [route.dest componentsSeparatedByString:@","];
            if(array.count == 2){
                isGetEndPoint = YES;
                [self addLineStartEndPoint:[AGSPoint pointWithX:[[array objectAtIndex:0] doubleValue] y:[[array objectAtIndex:1] doubleValue] spatialReference:nil]];
                isGetEndPoint = NO;
            }
            [self.lineLayer refresh];
            if(route.scale.length>0 && route.center.length > 0){
                array = [route.center componentsSeparatedByString:@","];
            }
        });
    });
}
@end
