//
//  TianDiTuWMTSLayerInfoDelegate.m
//  CustomTiledLayerV10.11
//
//  Created by EsriChina_Mobile_MaY on 13-3-28.
//
//
#import "TianDiTuWMTSLayerInfoDelegate.h"
//proxy
#define KPROXY_URL @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?"
//mecator
#define kURL_VECTOR_MERCATOR @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/vec_w/wmts"
#define kURL_VECTOR_ANNOTATION_CHINESE_MERCATOR @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/cva_w/wmts"
#define kURL_VECTOR_ANNOTATION_ENGLISH_MERCATOR @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/eva_w/wmts"
#define kURL_IMAGE_MERCATOR @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/img_w/wmts"
#define kURL_IMAGE_ANNOTATION_CHINESE_MERCATOR @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/cia_w/wmts"
#define kURL_IMAGE_ANNOTATION_ENGLISH_MERCATOR @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/cia_w/wmts"
#define kURL_TERRAIN_MERCATOR @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/ter_w/wmts"
#define kURL_TERRAIN_ANNOTATION_CHINESE_MERCATOR @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/cta_w/wmts"
//cgcs2000
#define kURL_VECTOR_2000 @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/vec_c/wmts"
#define kURL_VECTOR_ANNOTATION_CHINESE_2000 @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/cva_c/wmts"
#define kURL_VECTOR_ANNOTATION_ENGLISH_2000 @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/eva_c/wmts"
#define kURL_IMAGE_2000 @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/img_c/wmts"
#define kURL_IMAGE_ANNOTATION_CHINESE_2000 @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/cia_c/wmts"
#define kURL_IMAGE_ANNOTATION_ENGLISH_2000 @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/cia_c/wmts"
#define kURL_TERRAIN_2000 @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/ter_c/wmts"
#define kURL_TERRAIN_ANNOTATION_CHINESE_2000 @"http://61.164.34.9:8002/EarthquakeIINet/EarthquakeII/proxy.ashx?http://t0.tianditu.cn/cta_c/wmts"

//services
#define kLAYER_NAME_VECTOR @"vec"
#define kLAYER_NAME_VECTOR_ANNOTATION_CHINESE @"cva"
#define kLAYER_NAME_VECTOR_ANNOTATION_ENGLISH @"eva"
#define kLAYER_NAME_IMAGE @"img"
#define kLAYER_NAME_IMAGE_ANNOTATION_CHINESE @"cia"
#define kLAYER_NAME_IMAGE_ANNOTATION_ENGLISH @"eia"
#define kLAYER_NAME_TERRAIN @"ter"
#define kLAYER_NAME_TERRAIN_ANNOTATION_CHINESE @"cta"

//sr
#define kTILE_MATRIX_SET_MERCATOR @"w"
#define kTILE_MATRIX_SET_2000 @"c"

//
#define SRID_2000 4490
#define SRID_MERCATOR 102100

#define X_MIN_2000 -180.0
#define Y_MIN_2000 -90.0
#define X_MAX_2000 180.0
#define Y_MAX_2000 90.0

#define X_MIN_MERCATOR -20037508.3427892
#define Y_MIN_MERCATOR -20037508.3427892
#define X_MAX_MERCATOR 20037508.3427892
#define Y_MAX_MERCATOR 20037508.3427892

#define _minZoomLevel 0
#define _maxZoomLevel 16
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
    layerInfo.minZoomLevel =_minZoomLevel;
    layerInfo.maxZoomLevel =_maxZoomLevel;
    //sr 
    if (tiandituType < 8) {//sr:webmecator
        layerInfo.srid = SRID_MERCATOR;
        layerInfo.xMax = X_MAX_MERCATOR;
        layerInfo.xMin = X_MIN_MERCATOR;
        layerInfo.yMax = Y_MAX_MERCATOR;
        layerInfo.yMin = Y_MIN_MERCATOR;
        layerInfo.tileMatrixSet = kTILE_MATRIX_SET_MERCATOR;
        layerInfo.origin = [AGSPoint pointWithX:X_MIN_MERCATOR y:Y_MAX_MERCATOR spatialReference:[[AGSSpatialReference alloc]initWithWKID:SRID_MERCATOR]];
        
        //wgs84:*(0.0254000508/96)/111194.872221777
        //mecator:*(0.0254000508/96)
        layerInfo.lods = [NSMutableArray arrayWithObjects:
                          [[AGSLOD alloc] initWithLevel:2 resolution:39135.83675440267 scale: 1.479146777272828E8],
                          [[AGSLOD alloc] initWithLevel:3 resolution:19567.918377201335 scale: 7.39573388636414E7],
                          [[AGSLOD alloc] initWithLevel:4 resolution:9783.959188600667 scale: 3.69786694318207E7],
                          [[AGSLOD alloc] initWithLevel:5 resolution:4891.979594300334 scale: 1.848933471591035E7],
                          [[AGSLOD alloc] initWithLevel:6 resolution:2445.989797150167 scale: 9244667.357955175],
                          [[AGSLOD alloc] initWithLevel:7 resolution:1222.9948985750834 scale: 4622333.678977588],
                          [[AGSLOD alloc] initWithLevel:8 resolution:611.4974492875417 scale: 2311166.839488794],
                          [[AGSLOD alloc] initWithLevel:9 resolution:305.7487246437696 scale: 1155583.419744397],
                          [[AGSLOD alloc] initWithLevel:10 resolution:152.87436232188531 scale: 577791.7098721985],
                          [[AGSLOD alloc] initWithLevel:11 resolution:76.43718116094266 scale: 288895.85493609926],
                          [[AGSLOD alloc] initWithLevel:12 resolution:38.21859058047133 scale: 144447.92746804963],
                          [[AGSLOD alloc] initWithLevel:13 resolution:19.109295290235693 scale: 72223.96373402482],
                          [[AGSLOD alloc] initWithLevel:14 resolution:9.554647645117846 scale: 36111.98186701241],
                          [[AGSLOD alloc] initWithLevel:15 resolution:4.777323822558923 scale: 18055.990933506204],
                          [[AGSLOD alloc] initWithLevel:16 resolution:2.3886619112794585 scale:9027.995466753102],
                          [[AGSLOD alloc] initWithLevel:17 resolution:1.1943309556397292 scale: 4513.997733376551],
                          [[AGSLOD alloc] initWithLevel:18 resolution:0.597165477819866 scale: 2256.998866688275],
                          nil ];

    }else{//sr:cgcs2000
        layerInfo.srid = SRID_2000;
        layerInfo.xMax = X_MAX_2000;
        layerInfo.xMin = X_MIN_2000;
        layerInfo.yMax = Y_MAX_2000;
        layerInfo.yMin = Y_MIN_2000;
        layerInfo.tileMatrixSet = kTILE_MATRIX_SET_2000;
        layerInfo.origin = [AGSPoint pointWithX:X_MIN_2000 y:Y_MAX_2000 spatialReference:[[AGSSpatialReference alloc]initWithWKID:SRID_2000]];
        
        layerInfo.lods = [NSMutableArray arrayWithObjects:
                          //                          [[AGSLOD alloc] initWithLevel:1 resolution:
                          //                           0.70391442 scale: 2.958293554545656E8],
                          [[AGSLOD alloc] initWithLevel:2 resolution:0.3515625 scale: 147748799.285417],
                          [[AGSLOD alloc] initWithLevel:3 resolution:0.17578125 scale: 73874399.6427087],
                          [[AGSLOD alloc] initWithLevel:4 resolution:0.087890625 scale: 36937199.8213544],
                          [[AGSLOD alloc] initWithLevel:5 resolution:0.0439453125 scale: 18468599.9106772],
                          [[AGSLOD alloc] initWithLevel:6 resolution:0.02197265625 scale: 9234299.95533859],
                          [[AGSLOD alloc] initWithLevel:7 resolution:0.010986328125 scale: 4617149.97766929],
                          [[AGSLOD alloc] initWithLevel:8 resolution:0.0054931640625 scale: 2308574.98883465],
                          [[AGSLOD alloc] initWithLevel:9 resolution:0.00274658203125 scale: 1155583.419744397],
                          [[AGSLOD alloc] initWithLevel:10 resolution:0.001373291015625 scale: 577143.747208662],
                          [[AGSLOD alloc] initWithLevel:11 resolution:0.0006866455078125 scale: 288571.873604331],
                          [[AGSLOD alloc] initWithLevel:12 resolution:0.00034332275390625 scale: 144285.936802165],
                          [[AGSLOD alloc] initWithLevel:13 resolution:0.000171661376953125 scale: 72142.9684010827],
                          [[AGSLOD alloc] initWithLevel:14 resolution:8.58306884765629E-05 scale: 36071.4842005414],
                          [[AGSLOD alloc] initWithLevel:15 resolution:4.29153442382814E-05 scale: 18035.7421002707],
                          [[AGSLOD alloc] initWithLevel:16 resolution:2.14576721191407E-05 scale:9017.87105013534],
                          [[AGSLOD alloc] initWithLevel:17 resolution:1.07288360595703E-05 scale: 4508.93552506767],
                          [[AGSLOD alloc] initWithLevel:18 resolution:5.36441802978515E-06 scale: 2254.467762533835],
                          nil ];
//        layerInfo.lods = [NSMutableArray arrayWithObjects:
////                          [[AGSLOD alloc] initWithLevel:1 resolution:
////                           0.70391442 scale: 2.958293554545656E8],
//                          [[AGSLOD alloc] initWithLevel:2 resolution:0.35195721 scale: 1.479146777272828E8],
//                          [[AGSLOD alloc] initWithLevel:3 resolution:0.17597861 scale: 7.39573388636414E7],
//                          [[AGSLOD alloc] initWithLevel:4 resolution:0.087989305 scale: 3.69786694318207E7],
//                          [[AGSLOD alloc] initWithLevel:5 resolution:0.043994652 scale: 1.848933471591035E7],
//                          [[AGSLOD alloc] initWithLevel:6 resolution:0.021997426 scale: 9244667.357955175],
//                          [[AGSLOD alloc] initWithLevel:7 resolution:0.010998663 scale: 4622333.678977588],
//                          [[AGSLOD alloc] initWithLevel:8 resolution:0.0054993315 scale: 2311166.839488794],
//                          [[AGSLOD alloc] initWithLevel:9 resolution:0.0027496658 scale: 1155583.419744397],
//                          [[AGSLOD alloc] initWithLevel:10 resolution:0.0013748329 scale: 577791.7098721985],
//                          [[AGSLOD alloc] initWithLevel:11 resolution:0.00068741643 scale: 288895.85493609926],
//                          [[AGSLOD alloc] initWithLevel:12 resolution:0.00034370822 scale: 144447.92746804963],
//                          [[AGSLOD alloc] initWithLevel:13 resolution:0.00017185411 scale: 72223.96373402482],
//                          [[AGSLOD alloc] initWithLevel:14 resolution:8.5927055E-05 scale: 36111.98186701241],
//                          [[AGSLOD alloc] initWithLevel:15 resolution:4.2963527E-05 scale: 18055.990933506204],
//                          [[AGSLOD alloc] initWithLevel:16 resolution:2.1481764E-05 scale:9027.995466753102],
//                          [[AGSLOD alloc] initWithLevel:17 resolution:1.0740882E-05 scale: 4513.997733376551],
//                          [[AGSLOD alloc] initWithLevel:18 resolution:5.370441E-06 scale: 2256.998866688275],
//                          nil ];
    }
    //other parameters
    switch (tiandituType) {
        case 0:
            layerInfo.url = kURL_VECTOR_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_VECTOR;
            break;
        case 1:
            layerInfo.url = kURL_VECTOR_ANNOTATION_CHINESE_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_VECTOR_ANNOTATION_CHINESE;
            break;
        case 2:
            layerInfo.url = kURL_VECTOR_ANNOTATION_ENGLISH_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_VECTOR_ANNOTATION_ENGLISH;
            break;
        case 3:
            layerInfo.url = kURL_IMAGE_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_IMAGE;
            break;
        case 4:
            layerInfo.url = kURL_IMAGE_ANNOTATION_CHINESE_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_IMAGE_ANNOTATION_CHINESE;
            break;
        case 5:
            layerInfo.url = kURL_IMAGE_ANNOTATION_ENGLISH_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_IMAGE_ANNOTATION_ENGLISH;
            break;
        case 6:
            layerInfo.url = kURL_TERRAIN_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_TERRAIN;
            break;
        case 7:
            layerInfo.url = kURL_TERRAIN_ANNOTATION_CHINESE_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_TERRAIN_ANNOTATION_CHINESE;
            break;
        case 8:
            layerInfo.url = kURL_VECTOR_2000;
            layerInfo.layerName = kLAYER_NAME_VECTOR;
            break;
        case 9:
            layerInfo.url = kURL_VECTOR_ANNOTATION_CHINESE_2000;
            layerInfo.layerName = kLAYER_NAME_VECTOR_ANNOTATION_CHINESE;
            break;
        case 10:
            layerInfo.url = kURL_VECTOR_ANNOTATION_ENGLISH_2000;
            layerInfo.layerName = kLAYER_NAME_VECTOR_ANNOTATION_ENGLISH;
            break;
        case 11:
            layerInfo.url = kURL_IMAGE_2000;
            layerInfo.layerName = kLAYER_NAME_IMAGE;
            break;
        case 12:
            layerInfo.url = kURL_IMAGE_ANNOTATION_CHINESE_2000;
            layerInfo.layerName = kLAYER_NAME_IMAGE_ANNOTATION_CHINESE;
            break;
        case 13:
            layerInfo.url = kURL_IMAGE_ANNOTATION_ENGLISH_2000;
            layerInfo.layerName = kLAYER_NAME_IMAGE_ANNOTATION_ENGLISH;
            break;
        case 14:
            layerInfo.url = kURL_TERRAIN_2000;
            layerInfo.layerName = kLAYER_NAME_TERRAIN;
            break;
        case 15:
            layerInfo.url = kURL_TERRAIN_ANNOTATION_CHINESE_2000;
            layerInfo.layerName = kLAYER_NAME_TERRAIN_ANNOTATION_CHINESE;
            break;
        default:
            break;
    }
    
    return layerInfo;
}
@end
