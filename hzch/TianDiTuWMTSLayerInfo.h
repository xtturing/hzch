//
//  TianDiTuWMTSLayerInfo.h
//  CustomTiledLayerV10.11
//
//  Created by EsriChina_Mobile_MaY on 13-3-28.
//
//

#import <Foundation/Foundation.h>
@class AGSPoint;

@interface TianDiTuWMTSLayerInfo : NSObject
{
    @private
    NSString __unsafe_unretained *_url;
    NSString __unsafe_unretained *_layerName;
    int _minZoomLevel;
    int _maxZoomLevel;
    double _xMin;
    double _yMin;
    double _xMax;
    double _yMax;
    int _tileWidth;
    int _tileHeight;
    NSMutableArray __unsafe_unretained *_lods;
    int _dpi;
    int _srid;
    AGSPoint __unsafe_unretained *_origin;
    NSString __unsafe_unretained *_tileMatrixSet;
}
@property (nonatomic,assign) NSString *url;
@property (nonatomic,assign) NSString *layerName;
@property (nonatomic,assign) int minZoomLevel;
@property (nonatomic,assign) int maxZoomLevel;
@property (nonatomic,assign) double xMin;
@property (nonatomic,assign) double yMin;
@property (nonatomic,assign) double xMax;
@property (nonatomic,assign) double yMax;
@property (nonatomic,assign) int tileWidth;
@property (nonatomic,assign) int tileHeight;
@property (nonatomic,assign) NSMutableArray *lods;
@property (nonatomic,assign) int dpi;
@property (nonatomic,assign) int srid;
@property (nonatomic,assign) AGSPoint *origin;
@property (nonatomic,assign) NSString *tileMatrixSet;

@end
