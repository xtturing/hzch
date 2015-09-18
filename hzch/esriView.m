//
//  esriViewController.m
//  RapidReport_P
//
//  Created by hvit-pc on 14-3-13.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import "esriView.h"

#define ALERT(msg) {UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"杭州档案馆" message:msg delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];[alert show];}


@interface esriView (){
    double _distance;
    double _area;
    AGSSRUnit _distanceUnit;
    AGSAreaUnits _areaUnit;

}

@end

@implementation esriView

- (id)initWithFrame:(CGRect)frame
{
    // Set the client ID
    NSError *error;
    NSString* clientID = @"lsTnqx6kfd0c5Nml";
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
            
            self.configData  = [[NSConfigData alloc]init];
            //NSLog(@"连续加载对象 : %@",self.mapView);
            
            NSError* err;
            /* sr:CGCS2000(4490)*/
            
            
            TianDiTuWMTSLayer* TianDiTuLyr = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_2000 LocalServiceURL:nil error:&err];
            TianDiTuWMTSLayer* TianDiTuLyr_Anno = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_ANNOTATION_CHINESE_2000 LocalServiceURL:nil error:&err];
            TianDiTuWMTSLayer* TianDituLyr_zje=[[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_ZJ_VECTOR LocalServiceURL:nil error:&err];
            
            if(TianDiTuLyr!=nil && TianDiTuLyr_Anno !=nil && TianDituLyr_zje != nil)
            {
                [self.mapView removeMapLayerWithName:@"TianDiTu Layer"];
                [self.mapView removeMapLayerWithName:@"TianDiTu Annotation Layer"];
                [self.mapView removeMapLayerWithName:@"TianDiTu zje Layer"];
                [self.mapView addMapLayer:TianDiTuLyr withName:@"TianDiTu Layer"];
                [self.mapView addMapLayer:TianDiTuLyr_Anno withName:@"TianDiTu Annotation Layer"];
                [self.mapView addMapLayer:TianDituLyr_zje withName:@"TianDiTu zje Layer"];
                
                self.mapView.layerDelegate = self;
                
                AGSPoint *centPoint = [AGSPoint pointWithX:107.3425 y:33.3730 spatialReference:self.mapView.spatialReference];
                [self.mapView zoomToScale:1.0952406432898982E8 withCenterPoint:centPoint animated:YES];
                
                [self locationListenner];
            }else{
                //layer encountered an error
                NSLog(@"Error encountered: %@", err);
            }
        }
        

    }
    return self;
}

//运行崩溃的原因
//- (void)mapViewDidLoad:(AGSMapView *)mapView  {
//    // register for pan notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToEnvChange:) name:AGSMapViewDidEndPanningNotification object:nil];
//    
//    // register for "MapDidEndPanning" notifications
//    
//}

// The method that should be called when the notification arises
- (void)respondToEnvChange: (NSNotification*) notification {
    
//    if(self.locationState){
         self.locationState = NO;
        [self.locationBtn setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
        [self.locationManager stopUpdatingLocation];
       
//    }
    
}


-(void)addSubjectLayer:(AGSFeatureSet *)p_features select:(AGSGraphic *)p_selGp queryParams:(QueryParams *) p_queryParams{
    self.mapView.touchDelegate = self;
    self.mapView.callout.delegate = self;
    self.queryParams = p_queryParams;
    [self removeAllLayer];
    
    NSString *dmsUrl;
    NSString *dmsLayer;
    switch (p_features.geometryType) {
        case AGSGeometryTypePolyline:

            dmsUrl = [self.queryParams.layerUrl substringToIndex:self.queryParams.layerUrl.length-2];
            dmsLayer = [self.queryParams.layerUrl substringFromIndex:self.queryParams.layerUrl.length-1];
             self.dmsLayer = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL: [NSURL URLWithString:dmsUrl]];
            self.dmsLayer.visibleLayers = [NSArray arrayWithObjects:[NSNumber numberWithInt:dmsLayer.intValue], nil];
            [self.mapView addMapLayer:self.dmsLayer withName:@"SubLayer"];
            [self topLocationLayer];
            
            [self.mapView zoomToScale:9234299.95533859 withCenterPoint:[AGSPoint pointWithX:119.896901
                                                                                          y:29.071736
                                                                           spatialReference:self.mapView.spatialReference] animated:YES];
            if (p_selGp==nil) {
                [self.mapView.callout dismiss];
            }else {
                
                AGSPolyline *line = (AGSPolyline *)p_selGp.geometry;
                
                AGSPoint *point = (AGSPoint *)[line pointOnPath:line.numPaths atIndex:([line numPointsInPath:line.numPaths]/2)];
                p_selGp.geometry = point;
                
                [self showCallOut:p_selGp title:[ p_selGp attributeAsStringForKey:[self.queryParams.itemField objectAtIndex:0]] detail:[ p_selGp attributeAsStringForKey:[self.queryParams.itemField objectAtIndex:1]]];
            }
            break;
        default:
            self.ghLayer = [[AGSGraphicsLayer alloc]init];
            [self.ghLayer addGraphics:p_features.features];
            self.ghLayer.selectionColor = [UIColor redColor];
            [self.mapView addMapLayer:self.ghLayer withName:@"SubLayer"];
            [self topLocationLayer];
            
            if ([self.queryParams.layerType isEqualToString:@"bncsLayer"]) {
                [self.mapView zoomToScale:92342.95533859 withCenterPoint:(AGSPoint *)self.locationGrp.geometry animated:YES];
            }else{
                [self.mapView zoomToScale:9234299.95533859 withCenterPoint:[AGSPoint pointWithX:119.896901
                                                                                              y:29.071736
                                                                               spatialReference:self.mapView.spatialReference] animated:YES];
            }
            if (p_selGp==nil) {
                [self.mapView.callout dismiss];
                
            }else {
                [self showCallOut:p_selGp title:[ p_selGp attributeAsStringForKey:[self.queryParams.itemField objectAtIndex:0]] detail:[ p_selGp attributeAsStringForKey:[self.queryParams.itemField objectAtIndex:1]]];
            }

            break;
    }
    
}


//定制地震
-(void)addCustLayer:(NSDictionary *)p_data select:(NSDictionary *)selectDic{
    self.mapView.touchDelegate = self;
    self.mapView.callout.delegate = self;
    
    self.selectCatalog = selectDic;
    
    self.dataDic = p_data;
    self.dataType = @"CustData";
    
     [self removeAllLayer];
    
    self.ghLayer = [[AGSGraphicsLayer alloc]init];
    self.ghLayer.selectionColor = [UIColor redColor];
    [self.mapView addMapLayer:self.ghLayer withName:@"CustomLayer"];
    [self topLocationLayer];
    
    for (int i=self.dataDic.count-1; i>=0; i--) {
        @autoreleasepool{
            NSArray *t_arr = (NSArray *)self.dataDic;
            NSDictionary *t_att = [t_arr objectAtIndex:i];
            NSString *t_imagePath;
            t_imagePath = @"cus_cz.png";
            
            AGSPoint *t_point = [AGSPoint pointWithX:[[t_att objectForKey:@"Lon"] doubleValue]
                                                   y:[[t_att objectForKey:@"Lat"] doubleValue]
                                    spatialReference:self.mapView.spatialReference];
            
            UIImage *t_m;
            t_m =  [self.configData addImageText:[UIImage imageNamed:t_imagePath] text:[[t_att objectForKey:@"M"] stringValue]];
            
            AGSPictureMarkerSymbol *picMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:t_m ];
            
            AGSGraphic *t_gh = [AGSGraphic graphicWithGeometry:t_point symbol:picMarkerSymbol attributes:t_att infoTemplateDelegate:nil];
            
            [self.ghLayer addGraphic:t_gh];
            
            
            if (self.selectCatalog==nil) {
                [self.mapView.callout dismiss];
            }else if(self.selectCatalog == t_att){
                [self showCallOut:t_gh title:[self.configData  jsonDateToDate:[t_gh attributeAsStringForKey:@"Sendtime"] ] detail:nil];
            }
        
        }
        
    }

}


//最新地震
-(void)addEqimLayer:(NSDictionary *)p_data select:(NSDictionary *)selectDic{
    @autoreleasepool{
    self.mapView.touchDelegate = self;
    self.mapView.callout.delegate = self;
    
    self.selectCatalog = selectDic;
    
    self.dataDic = p_data;
    self.dataType = @"EqimData";
    
    [self removeAllLayer];

    
    self.ghLayer = [[AGSGraphicsLayer alloc]init];
    self.ghLayer.selectionColor = [UIColor redColor];
        
    
    [self topLocationLayer];
    [self.mapView addMapLayer:self.ghLayer withName:@"EqimLayer"];
        
    
    NSDictionary *t_att;
    NSString *t_imagePath;
    AGSPoint *t_point;
    UIImage *t_m;
    
    AGSPictureMarkerSymbol *picMarkerSymbol;
    AGSGraphic *t_gh;
    
    
    NSArray *t_arr = (NSArray *)self.dataDic;
    

    for (int i=t_arr.count-1; i>=0; i--) {
        @autoreleasepool{
            t_att = [t_arr objectAtIndex:i];
            
            if (i==0) {
                t_imagePath = @"new_cz.png";
            }else{
                t_imagePath = @"last_cz.png";
            }
            
            t_point = [AGSPoint pointWithX:[[t_att objectForKey:@"Lon"] doubleValue]
                                         y:[[t_att objectForKey:@"Lat"] doubleValue]
                          spatialReference:self.mapView.spatialReference];
            
            
            t_m =  [self.configData addImageText:[UIImage imageNamed:t_imagePath] text:[[t_att objectForKey:@"M"] stringValue]];
            
            picMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:t_m ];
            
            t_gh = [AGSGraphic graphicWithGeometry:t_point symbol:picMarkerSymbol attributes:t_att infoTemplateDelegate:nil];
            
            [self.ghLayer addGraphic:t_gh];
            
            
            if (i==0&&!self.selectCatalog) {
                [self showCallOut:t_gh title:[t_gh attributeAsStringForKey:@"LocationCname"] detail:[t_gh attributeAsStringForKey:@"OTime"]];
            }else if(self.selectCatalog == t_att){
                [self showCallOut:t_gh title:[t_gh attributeAsStringForKey:@"LocationCname"] detail:[t_gh attributeAsStringForKey:@"OTime"]];
            }
        }
        
    }
        NSLog(@"IS NIL TEST %@" ,@"5");

    }
}

//画图
-(void)addSketchLayer{
    self.sketchGhLayer= [[AGSGraphicsLayer alloc]init];
    [self.mapView addMapLayer:self.sketchGhLayer withName:@"Sketch layer"];
    
    self.mapView.touchDelegate = self;

}

- (void)showToolView{
    if(_toolView){
        [_toolView removeFromSuperview];
        _toolView = nil;
        self.sketchLayer = nil;
        self.sketchLayer.geometry = nil;
        self.mapView.touchDelegate = nil;
        [self.mapView removeMapLayerWithName:@"sketchLayer"];
        [self.mapView.callout removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
    }else{
        [self.mapView addSubview:self.toolView];
        self.sketchLayer = [AGSSketchGraphicsLayer graphicsLayer];
        if([self hasLayer:@"sketchLayer"])
        {
            [_mapView removeMapLayerWithName:@"sketchLayer"];
        }
        
        [self.mapView addMapLayer:self.sketchLayer withName:@"sketchLayer"];
        self.mapView.touchDelegate = self.sketchLayer;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToGeomChanged:) name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
        // Set the default measures and units
        _distance = 0;
        _area = 0;
        _distanceUnit = AGSSRUnitKilometer;
        _areaUnit = AGSAreaUnitsSquareKilometers;
    }
}

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics{
    if ([self.ghLayer graphicsCount]>0) {
        AGSGraphic *t_selgh ;
        for (AGSGraphic *t_gh in [self.ghLayer graphics]) {
            
            CGPoint pointVar = [mapView toScreenPoint:(AGSPoint *)[t_gh geometry]];
            if (sqrt((screen.x-pointVar.x)*(screen.x-pointVar.x)+(screen.y-pointVar.y)*(screen.y-pointVar.y))<20) {
                t_selgh = t_gh;
                break;
            }
        }
        if ([self.ghLayer.name isEqualToString:@"EqimLayer"]) {
            [self showCallOut:t_selgh title:[t_selgh attributeAsStringForKey:@"LocationCname"] detail:[t_selgh attributeAsStringForKey:@"OTime"]];
        }else if([self.ghLayer.name isEqualToString:@"CustomLayer"]){
            [self showCallOut:t_selgh title:[self.configData  jsonDateToDate:[t_selgh attributeAsStringForKey:@"Sendtime"] ] detail:nil];
        }else if([self.ghLayer.name isEqualToString:@"SubLayer"]){
            [self showCallOut:t_selgh title:[t_selgh attributeAsStringForKey:[self.queryParams.itemField objectAtIndex:0]] detail:[t_selgh attributeAsStringForKey:[self.queryParams.itemField objectAtIndex:1]]];
        }
        
    }else if (self.dmsLayer !=nil){
        
        AGSEnvelope *t_mapE = [[AGSEnvelope alloc]
                                 initWithXmin:mappoint.x-0.02
                                 ymin:mappoint.y-0.02
                                 xmax:mappoint.x+0.02
                                 ymax:mappoint.y+0.02
                                 spatialReference:[[AGSSpatialReference alloc]initWithWKID:4490]];
        //set up query task against layer, specify the delegate
        self.queryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:self.queryParams.layerUrl]];
        self.queryTask.delegate = self;
        
        //return all fields in query
        self.query = [AGSQuery query];
        self.query.outSpatialReference = self.queryParams.layerSpr;
        self.query.where = self.queryParams.layerWhere;
        self.query.returnGeometry = YES;
        self.query.geometry =t_mapE;
        self.query.outFields = self.queryParams.fieldOut;
        [self.queryTask executeWithQuery:self.query];
    
    }else if (self.sketchGhLayer!=nil)
    {
        if (self.beginPoint==nil) {
            self.beginPoint = mappoint;
            
            AGSGraphic *t_agsGh = [[AGSGraphic alloc]initWithGeometry:self.beginPoint symbol:[AGSSimpleMarkerSymbol simpleMarkerSymbol] attributes:nil infoTemplateDelegate:nil];
            
            [self.sketchGhLayer addGraphic:t_agsGh];
        }else if (self.endPoint == nil&&self.beginPoint!=nil){
            self.endPoint =mappoint;
            AGSGraphic *t_agsGhPoint = [[AGSGraphic alloc]initWithGeometry:self.endPoint symbol:[AGSSimpleMarkerSymbol simpleMarkerSymbol] attributes:nil infoTemplateDelegate:nil];
            
            [self.sketchGhLayer addGraphic:t_agsGhPoint];
            
            self.envelope =  [[AGSEnvelope alloc]initWithXmin:self.beginPoint.x ymin:self.beginPoint.y xmax:self.endPoint.x ymax:self.endPoint.y spatialReference:self.mapView.spatialReference];
            AGSGraphic *t_agsGh = [[AGSGraphic alloc]initWithGeometry:self.envelope symbol:[AGSSimpleFillSymbol simpleFillSymbol] attributes:nil infoTemplateDelegate:nil];
            
            [self.sketchGhLayer addGraphic:t_agsGh];
        }else if (self.endPoint !=nil && self.beginPoint!=nil){
            self.endPoint = nil;
            self.beginPoint = nil;
            [self.sketchGhLayer removeAllGraphics];
        }
        
    }
}

- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation*)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet{
    if (featureSet.features.count>0) {

    AGSGraphic *feature = [featureSet.features objectAtIndex:0];
    AGSPolyline *line = (AGSPolyline *)feature.geometry;
        
        if (line.numPaths>0) {
                AGSPoint *point = (AGSPoint *)[line pointOnPath:line.numPaths atIndex:([line numPointsInPath:line.numPaths]/2)];
            AGSGraphic *t_agsGh = [[AGSGraphic alloc]initWithGeometry:point symbol:nil attributes:feature.allAttributes infoTemplateDelegate:nil];
            
            [self showCallOut:t_agsGh title:[feature attributeAsStringForKey:[self.queryParams.itemField objectAtIndex:0]] detail:[feature attributeAsStringForKey:[self.queryParams.itemField objectAtIndex:1]]];
        }
    }
    
}

//if there's an error with the query display it to the user
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
	[alertView show];
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
    [self.delegate esriViewDetails:self details:(AGSGraphic*)callout.representedObject queryParams:self.queryParams];
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
    
    if (self.locationState) {
        [self.mapView zoomToScale:9017.87105013534 withCenterPoint:[AGSPoint pointWithX:loc.longitude y:loc.latitude spatialReference:self.mapView.spatialReference] animated:YES];
    }
    
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
    if (self.dmsLayer !=nil) {
        [self.mapView removeMapLayer:self.dmsLayer];
        self.dmsLayer = nil;

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


#pragma mark toolview

- (NBToolView *)toolView{
    if(!_toolView){
        _toolView = [[NBToolView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-49-70, CGRectGetWidth(self.frame), 70)];
        _toolView.delegate = self;
    }
    return _toolView;
}
#pragma mark -measure

- (void)respondToGeomChanged:(NSNotification*)notification {
    
    AGSGeometry *sketchGeometry = self.sketchLayer.geometry;
    if (![sketchGeometry isValid]) {
        return;
    }
    // Update the distance and area whenever the geometry changes
    if ([sketchGeometry isKindOfClass:[AGSMutablePolyline class]]) {
        [self updateDistance:_distanceUnit];
    }
    else if ([sketchGeometry isKindOfClass:[AGSMutablePolygon class]]){
        [self updateArea:_areaUnit];
    }else if ([sketchGeometry isKindOfClass:[AGSMutablePoint class]]){
        
    }
}

- (void)updateDistance:(AGSSRUnit)unit {
    
    // Get the sketch layer's geometry
    AGSGeometry *sketchGeometry = self.sketchLayer.geometry;
    AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
    
    // Get the geodesic distance of the current line
    _distance = [geometryEngine geodesicLengthOfGeometry:sketchGeometry inUnit:_distanceUnit];
    if(_distance == 0){
        self.toolView.label.text = @"请在地图上点击画线测量距离";
    }else{
        self.toolView.label.text = [NSString stringWithFormat:@"距离：%.2f 公里", _distance];
    }
}

- (void)updateArea:(AGSAreaUnits)unit {
    
    // Get the sketch layer's geometry
    AGSGeometry *sketchGeometry = self.sketchLayer.geometry;
    AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
    
    // Get the area of the current polygon
    
    _area = [geometryEngine shapePreservingAreaOfGeometry:sketchGeometry inUnit:_areaUnit];
    if(_area == 0){
        self.toolView.label.text = @"请在地图上点击画面测量面积";
    }else{
        self.toolView.label.text = [NSString stringWithFormat:@"面积：%.4f 平方公里", _area];
    }
}
#pragma mark - toolDelegate
- (void)toolButtonClick:(int)buttonTag{
    switch (buttonTag) {
        case 100:
        {
            
        }
            break;
        case 101:
        {
            self.sketchLayer.geometry = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
            self.mapView.touchDelegate = self.sketchLayer;
            
            if([self hasLayer:@"sketchLayer"])
            {
                [_mapView removeMapLayerWithName:@"sketchLayer"];
            }
            [self.mapView addMapLayer:self.sketchLayer withName:@"sketchLayer"];
        }
            break;
            
        case 102:
        {
            self.sketchLayer.geometry = [[AGSMutablePolygon alloc] initWithSpatialReference:self.mapView.spatialReference];
            self.mapView.touchDelegate = self.sketchLayer;
            if([self hasLayer:@"sketchLayer"])
            {
                [_mapView removeMapLayerWithName:@"sketchLayer"];
            }
            [self.mapView addMapLayer:self.sketchLayer withName:@"sketchLayer"];
        }
            break;
            
        case 103:
        {
            
            
        }
            break;
            
        case 104:
        {
            self.sketchLayer.geometry = [[AGSMutablePoint alloc] initWithSpatialReference:self.mapView.spatialReference];
            self.mapView.touchDelegate = self.sketchLayer;
            
            if([self hasLayer:@"sketchLayer"])
            {
                [_mapView removeMapLayerWithName:@"sketchLayer"];
            }
            [self.mapView addMapLayer:self.sketchLayer withName:@"sketchLayer"];
        }
            break;
        case 105:
        {
            [self.sketchLayer clear];
            [self.mapView.callout removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}
- (BOOL)hasLayer:(NSString *)name{
    for(AGSLayer *layer in self.mapView.mapLayers){
        if([layer.name isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}
@end
