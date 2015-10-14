//
//  TiandituWMTSLayer_Vec.h
//  CustomTiledLayerSample
//
//  Created by EsriChina_Mobile_MaY on 13-3-27.
//
//
#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "TianDiTuWMTSLayerInfo.h"
typedef enum {
    TIANDITU_VECTOR_2000 = 8,     /*!< 天地图矢量国家2000坐标系地图服务 */
    TIANDITU_VECTOR_ANNOTATION_CHINESE_2000,     /*!< 天地图矢量国家2000坐标系中文标注 */
    TIANDITU_IMAGE_2000,     /*!< 天地图影像国家2000坐标系地图服务 */
    TIANDITU_IMAGE_ANNOTATION_CHINESE_2000,     /*!< 天地图影像国家2000坐标系中文标注 */
    TIANDITU_ZJ_VECTOR,     /*!< 天地图矢量浙江2000坐标系地图服务 */
    TIANDITU_ZJ_VECTOR_ANNOTATION,  /*!< 天地图矢量浙江2000坐标系中文标注 */
    TIANDITU_ZJ_IMAGE,     /*!< 天地图影像浙江2000坐标系地图服务 */
    TIANDITU_ZJ_IMAGE_ANNOTATION,   /*!< 天地图影像浙江2000坐标系中文标注 */
} TianDiTuLayerTypes;

@interface TianDiTuWMTSLayer : AGSTiledServiceLayer
{
    @protected
	AGSTileInfo* _tileInfo;
	AGSEnvelope* _fullEnvelope;
	AGSUnits _units;
    TianDiTuWMTSLayerInfo* layerInfo;
    NSOperationQueue* requestQueue;
}
/* ogc wmts url,like ""
//LocalServiceURL can be nil if use "http://t0.tianditu.cn/vec_c/wmts",otherwise input your local service url.
 */
-(id)initWithLayerType:(TianDiTuLayerTypes) tiandituType LocalServiceURL:(NSString *)url error:(NSError**) outError;

- (id)initWithLocalServiceURL:(NSString *)url withLayerName:(NSString *)layerName;
@end
