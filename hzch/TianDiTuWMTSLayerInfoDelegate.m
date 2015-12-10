//
//  TianDiTuWMTSLayerInfoDelegate.m
//  CustomTiledLayerV10.11
//
//  Created by EsriChina_Mobile_MaY on 13-3-28.
//
//
#import "TianDiTuWMTSLayerInfoDelegate.h"

//cgcs2000
#define kURL_VECTOR_2000 @"http://t0.tianditu.com/vec_c/wmts"
#define kURL_VECTOR_ANNOTATION_CHINESE_2000 @"http://t0.tianditu.com/cva_c/wmts"
#define kURL_IMAGE_ANNOTATION_CHINESE_2000 @"http://t0.tianditu.com/cia_c/wmts"
#define kURL_IMAGE_2000 @"http://t0.tianditu.com/img_c/wmts"
/*浙江*/
#define kURL_ZJ_VECTOR @"http://ditu.zj.cn/services/wmts/zjemap"
#define kURL_ZJ_VECTOR_ANNOTATION @"http://srv.zjditu.cn/ZJEMAPANNO_2D/wmts"
#define kURL_ZJ_IMAGE @"http://ditu.zj.cn//services/wmts/imgmap"
#define kURL_ZJ_IMAGE_ANNOTATION @"http://ditu.zj.cn/services/wmts/imgmap_lab"

//services
#define kLAYER_NAME_VECTOR @"vec"
#define kLAYER_NAME_VECTOR_ANNOTATION_CHINESE @"cva"
#define kLAYER_NAME_IMAGE @"img"
#define kLAYER_NAME_IMAGE_ANNOTATION_CHINESE @"cia"
/*浙江*/
#define kLAYER_NAME_ZJ_VECTOR @"zjemap"
#define kLAYER_NAME_ZJ_VECTOR_ANNOTATION @"zjemapanno"
#define kLAYER_NAME_ZJ_IMAGE @"imgmap"
#define kLAYER_NAME_ZJ_IMAGE_ANNOTATION @"imgmap_lab"

//sr
#define kTILE_MATRIX_SET_2000 @"c"
/*浙江*/
#define kTILE_MATRIX_SET_ZJ_VECTOR @"esritilematirx"
#define kTILE_MATRIX_SET_ZJ_VECTOR_ANNOTATION @"TileMatrixSet0"
#define kTILE_MATRIX_SET_ZJ_IMAGE @"esritilematirx"
#define kTILE_MATRIX_SET_ZJ_IMAGE_ANNOTATION @"esritilematirx"


//
#define SRID_2000 4490

#define X_MIN_2000 -180.0
#define Y_MIN_2000 -90.0
#define X_MAX_2000 180.0
#define Y_MAX_2000 90.0

#define _minZoomLevel 6
#define _maxZoomLevel 18
#define _tileWidth 256
#define _tileHeight 256
#define _dpi 96


@implementation TianDiTuWMTSLayerInfoDelegate

-(TianDiTuWMTSLayerInfo*)getLayerInfo:(TianDiTuLayerTypes) tiandituType{
    
    TianDiTuWMTSLayerInfo *layerInfo = [[TianDiTuWMTSLayerInfo alloc]init];
    //normal parameters
    layerInfo.dpi = _dpi;
    layerInfo.tileHeight = _tileHeight;
    layerInfo.tileWidth = _tileWidth;
    layerInfo.minZoomLevel =1;
    layerInfo.maxZoomLevel =20;
    //sr
    layerInfo.srid = SRID_2000;
    layerInfo.xMax = X_MAX_2000;
    layerInfo.xMin = X_MIN_2000;
    layerInfo.yMax = Y_MAX_2000;
    layerInfo.yMin = Y_MIN_2000;
    layerInfo.tileMatrixSet = kTILE_MATRIX_SET_2000;
    layerInfo.style = @"default";
    layerInfo.format = @"tiles";
    layerInfo.origin = [AGSPoint pointWithX:X_MIN_2000 y:Y_MAX_2000 spatialReference:[[AGSSpatialReference alloc]initWithWKID:SRID_2000]];
    layerInfo.lods = [NSMutableArray arrayWithObjects:
                      [[AGSLOD alloc] initWithLevel:1 resolution: 0.7031249999891485 scale: 2.958293554545656E8],
                      [[AGSLOD alloc] initWithLevel:2 resolution:0.35156249999999994 scale: 1.479146777272828E8],
                      [[AGSLOD alloc] initWithLevel:3 resolution:0.17578124999999997 scale: 7.39573388636414E7],
                      [[AGSLOD alloc] initWithLevel:4 resolution:0.08789062500000014 scale: 3.69786694318207E7],
                      [[AGSLOD alloc] initWithLevel:5 resolution:0.04394531250000007 scale: 1.848933471591035E7],
                      [[AGSLOD alloc] initWithLevel:6 resolution:0.021972656250000007 scale: 9244667.357955175],
                      [[AGSLOD alloc] initWithLevel:7 resolution:0.01098632812500002 scale: 4622333.678977588],
                      [[AGSLOD alloc] initWithLevel:8 resolution:0.00549316406250001 scale: 2311166.839488794],
                      [[AGSLOD alloc] initWithLevel:9 resolution:0.0027465820312500017 scale: 1155583.419744397],
                      [[AGSLOD alloc] initWithLevel:10 resolution:0.0013732910156250009 scale: 577791.7098721985],
                      [[AGSLOD alloc] initWithLevel:11 resolution:0.000686645507812499 scale: 288895.85493609926],
                      [[AGSLOD alloc] initWithLevel:12 resolution:0.0003433227539062495 scale: 144447.92746804963],
                      [[AGSLOD alloc] initWithLevel:13 resolution:0.00017166137695312503 scale: 72223.96373402482],
                      [[AGSLOD alloc] initWithLevel:14 resolution:0.00008583068847656251 scale: 36111.98186701241],
                      [[AGSLOD alloc] initWithLevel:15 resolution:0.000042915344238281406 scale: 18055.990933506204],
                      [[AGSLOD alloc] initWithLevel:16 resolution:0.000021457672119140645 scale:9027.995466753102],
                      [[AGSLOD alloc] initWithLevel:17 resolution:0.000010728836059570307 scale: 4513.997733376551],
                      [[AGSLOD alloc] initWithLevel:18 resolution:0.000005364418029785169 scale: 2256.998866688275],
                      [[AGSLOD alloc] initWithLevel:19 resolution:0.00000268220901489258 scale: 1128.49943334],
                      [[AGSLOD alloc] initWithLevel:20 resolution:0.00000134110450744629 scale: 564.249716672],
                      nil
                      ];
    //other parameters
    switch (tiandituType) {
        case 8:
            layerInfo.url = kURL_VECTOR_2000;
            layerInfo.layerName = kLAYER_NAME_VECTOR;
            break;
        case 9:
            layerInfo.url = kURL_VECTOR_ANNOTATION_CHINESE_2000;
            layerInfo.layerName = kLAYER_NAME_VECTOR_ANNOTATION_CHINESE;
            break;
        case 10:
            layerInfo.url = kURL_IMAGE_2000;
            layerInfo.layerName = kLAYER_NAME_IMAGE;
            break;
        case 11:
            layerInfo.url = kURL_IMAGE_ANNOTATION_CHINESE_2000;
            layerInfo.layerName = kLAYER_NAME_IMAGE_ANNOTATION_CHINESE;
            break;
        case 12:
            layerInfo.url = kURL_ZJ_VECTOR;
            layerInfo.layerName = kLAYER_NAME_ZJ_VECTOR;
            layerInfo.tileMatrixSet = kTILE_MATRIX_SET_ZJ_VECTOR;
            layerInfo.format = @"image/png";
            layerInfo.minZoomLevel = 3;
            layerInfo.maxZoomLevel = 17;
            break;
        case 13:
            layerInfo.url = kURL_ZJ_VECTOR_ANNOTATION;
            layerInfo.layerName = kLAYER_NAME_ZJ_VECTOR_ANNOTATION;
            layerInfo.tileMatrixSet = kTILE_MATRIX_SET_ZJ_VECTOR_ANNOTATION;
            layerInfo.format = @"image/png";
            layerInfo.minZoomLevel = 3;
            layerInfo.maxZoomLevel = 17;
            break;
        case 14:
            layerInfo.url = kURL_ZJ_IMAGE;
            layerInfo.layerName = kLAYER_NAME_ZJ_IMAGE;
            layerInfo.tileMatrixSet = kTILE_MATRIX_SET_ZJ_IMAGE;
            layerInfo.style = @"zjdom2w1";
            layerInfo.format = @"image/jpeg";
            layerInfo.minZoomLevel = 3;
            layerInfo.maxZoomLevel = 17;
            break;
        case 15:
            layerInfo.url = kURL_ZJ_IMAGE_ANNOTATION;
            layerInfo.layerName = kLAYER_NAME_ZJ_IMAGE_ANNOTATION;
            layerInfo.tileMatrixSet = kTILE_MATRIX_SET_ZJ_IMAGE_ANNOTATION;
            layerInfo.format = @"image/png";
            layerInfo.minZoomLevel = 3;
            layerInfo.maxZoomLevel = 17;
            break;
        default:
            break;
    }
    
    return layerInfo;
}
-(TianDiTuWMTSLayerInfo*)getLayerInfo{
    
    TianDiTuWMTSLayerInfo *layerInfo = [[TianDiTuWMTSLayerInfo alloc]init];
    //normal parameters
    layerInfo.dpi = _dpi;
    layerInfo.tileHeight = _tileHeight;
    layerInfo.tileWidth = _tileWidth;
    layerInfo.minZoomLevel =_minZoomLevel;
    layerInfo.maxZoomLevel =_maxZoomLevel;
    //sr
    layerInfo.srid = SRID_2000;
    layerInfo.xMax = X_MAX_2000;
    layerInfo.xMin = X_MIN_2000;
    layerInfo.yMax = Y_MAX_2000;
    layerInfo.yMin = Y_MIN_2000;
    layerInfo.tileMatrixSet = kTILE_MATRIX_SET_2000;
    layerInfo.style = @"default";
    layerInfo.format = @"PNG32";
    layerInfo.origin = [AGSPoint pointWithX:X_MIN_2000 y:Y_MAX_2000 spatialReference:[[AGSSpatialReference alloc]initWithWKID:SRID_2000]];
    layerInfo.lods = [NSMutableArray arrayWithObjects:
                      [[AGSLOD alloc] initWithLevel:1 resolution: 0.7031249999891485 scale: 2.958293554545656E8],
                      [[AGSLOD alloc] initWithLevel:2 resolution:0.35156249999999994 scale: 1.479146777272828E8],
                      [[AGSLOD alloc] initWithLevel:3 resolution:0.17578124999999997 scale: 7.39573388636414E7],
                      [[AGSLOD alloc] initWithLevel:4 resolution:0.08789062500000014 scale: 3.69786694318207E7],
                      [[AGSLOD alloc] initWithLevel:5 resolution:0.04394531250000007 scale: 1.848933471591035E7],
                      [[AGSLOD alloc] initWithLevel:6 resolution:0.021972656250000007 scale: 9244667.357955175],
                      [[AGSLOD alloc] initWithLevel:7 resolution:0.01098632812500002 scale: 4622333.678977588],
                      [[AGSLOD alloc] initWithLevel:8 resolution:0.00549316406250001 scale: 2311166.839488794],
                      [[AGSLOD alloc] initWithLevel:9 resolution:0.0027465820312500017 scale: 1155583.419744397],
                      [[AGSLOD alloc] initWithLevel:10 resolution:0.0013732910156250009 scale: 577791.7098721985],
                      [[AGSLOD alloc] initWithLevel:11 resolution:0.000686645507812499 scale: 288895.85493609926],
                      [[AGSLOD alloc] initWithLevel:12 resolution:0.0003433227539062495 scale: 144447.92746804963],
                      [[AGSLOD alloc] initWithLevel:13 resolution:0.00017166137695312503 scale: 72223.96373402482],
                      [[AGSLOD alloc] initWithLevel:14 resolution:0.00008583068847656251 scale: 36111.98186701241],
                      [[AGSLOD alloc] initWithLevel:15 resolution:0.000042915344238281406 scale: 18055.990933506204],
                      [[AGSLOD alloc] initWithLevel:16 resolution:0.000021457672119140645 scale:9027.995466753102],
                      [[AGSLOD alloc] initWithLevel:17 resolution:0.000010728836059570307 scale: 4513.997733376551],
                      [[AGSLOD alloc] initWithLevel:18 resolution:0.000005364418029785169 scale: 2256.998866688275],
                      [[AGSLOD alloc] initWithLevel:19 resolution:0.00000268220901489258 scale: 1128.49943334],
                      [[AGSLOD alloc] initWithLevel:20 resolution:0.00000134110450744629 scale: 564.249716672],
                      nil
                      ];
    
    return layerInfo;
}

@end
