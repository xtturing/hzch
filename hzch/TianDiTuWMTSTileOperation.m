//
//  TiandituTileOperation.m
//  CustomTiledLayerSample
//
//  Created by EsriChina_Mobile_MaY on 13-3-27.
//
//

#import "TianDiTuWMTSTileOperation.h"

#define kURLGetTile @"%@?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=%@&FORMAT=%@&TILEMATRIXSET=%@&TILECOL=%ld&TILEROW=%ld&TILEMATRIX=%ld&STYLE=%@"

@implementation TianDiTuWMTSTileOperation
@synthesize tileKey=_tileKey;
@synthesize target=_target;
@synthesize action=_action;
@synthesize imageData = _imageData;
@synthesize layerInfo = _layerInfo;

- (id)initWithTileKey:(AGSTileKey *)tileKey TiledLayerInfo:(TianDiTuWMTSLayerInfo *)layerInfo target:(id)target action:(SEL)action{
	
	if (self = [super init]) {
		self.target = target;
		self.action = action;
		self.tileKey = tileKey;
		self.layerInfo = layerInfo;
        self.configData = [[NSConfigData alloc]init];
        self.tianDiTuData = [[TianDiTuData alloc] init];
	}
    return self;
}

-(void)main {
	//Fetch the tile for the requested Level, Row, Column
	@try {
        if (self.tileKey.level > self.layerInfo.maxZoomLevel ||self.tileKey.level < self.layerInfo.minZoomLevel) {
            return;
        }
        NSString *baseUrl= [NSString stringWithFormat:kURLGetTile,self.layerInfo.url,self.layerInfo.layerName,self.layerInfo.format,self.layerInfo.tileMatrixSet,self.tileKey.column,self.tileKey.row,(self.tileKey.level + 1),self.layerInfo.style];
        //NSString *baseUrl= [NSString stringWithFormat:self.layerInfo.requestURL,self.layerInfo.url,self.layerInfo.layerName,self.layerInfo.format,self.layerInfo.tileMatrixSet,self.tileKey.column,self.tileKey.row,(self.tileKey.level + 1),self.layerInfo.style];
        NSLog(@"%@",baseUrl);
        NSData *data = [[NSData alloc] init];
        
        data =  [self.tianDiTuData QueryTile:self.layerInfo.layerName x:self.tileKey.row y:self.tileKey.column l:self.tileKey.level + 2];
        
        if (data == nil || data.length == 0)
        {
            NSLog(@"获取网络切片");
            data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:baseUrl]];
            
            [self.tianDiTuData InsertTile:self.layerInfo.layerName x:self.tileKey.row y:self.tileKey.column l:self.tileKey.level + 2 tiels:data];
            
        }
        else
        {
            NSLog(@"获取本地切片");
        }
        
        self.imageData = data;
        data = nil;
	}
	@catch (NSException *exception) {
		NSLog(@"main: Caught Exception %@: %@", [exception name], [exception reason]);
	}
	@finally {
		//Invoke the layer's action method
		[_target performSelector:_action withObject:self];
	}
    
}
@end
