//
//  ShpHelper.m
//  TestShp
//
//  Created by baocai zhang on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShpHelper.h"
#import "shapefil.h"
//#import "dbfopen.c"
#include "stdlib.h"

#define ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
//#define ENCODING NSUTF8StringEncoding

NSMutableArray * shp2AGSGraphics(NSString * shpPath,NSString * shpName)
{
    SHPHandle	hSHP;
    DBFHandle   hDBF;
    int		nShapeType, nEntities, i;
    int		nWidth, nDecimals;
    double 	adfMinBound[4], adfMaxBound[4];
    /*
     NSString *shpPath = [[NSBundle mainBundle] pathForResource:@"XianCh_point" ofType:@"shp" inDirectory:@"res4_4m"];
     */
    /* -------------------------------------------------------------------- */
    /*      Open the passed shapefile.                                      */
    /* -------------------------------------------------------------------- */
    NSString * shpFile = [NSString stringWithFormat:@"%@/%@.shp",shpPath,shpName];
    NSString * dbfFile = [NSString stringWithFormat:@"%@/%@.dbf",shpPath,shpName];
    hSHP = SHPOpen([shpFile cStringUsingEncoding:ENCODING], "rb" );
    hDBF  = DBFOpen([dbfFile cStringUsingEncoding:ENCODING], "rb");
    if( hSHP == NULL  || hDBF == NULL)
    {
        return nil;
    }
    
    /* -------------------------------------------------------------------- */
    /*      Print out the file bounds.                                      */
    /* -------------------------------------------------------------------- */
    SHPGetInfo( hSHP, &nEntities, &nShapeType, adfMinBound, adfMaxBound );
    
    /* -------------------------------------------------------------------- */
    /*	Skim over the list of shapes, printing all the vertices.	*/
    /* -------------------------------------------------------------------- */
    NSMutableArray * data=[[NSMutableArray alloc] initWithCapacity:1000];
    for( i = 0; i < nEntities; i++ )
    {
        SHPObject	*psShape;		
        psShape = SHPReadObject( hSHP, i );	
        AGSGraphic * gra= nil;
        switch (nShapeType) {
            case SHPT_POINT:
            {
                AGSPoint *point =	[AGSPoint pointWithX:psShape->padfX[0] y:psShape->padfY[0] spatialReference:nil];
                gra = [AGSGraphic graphicWithGeometry:point symbol:nil attributes:nil];
            }
                break;
            case SHPT_ARC:
            {
                AGSMutablePolyline * line = [[AGSMutablePolyline alloc] init];
                
                for( int partNumber = 0; partNumber < psShape->nParts; partNumber++ )
                {                      
                    int start = psShape->nParts > 1 ? psShape->panPartStart[partNumber] : 0;
                    int end = psShape->nParts > 1 ? psShape->panPartStart[ partNumber + 1 ] : psShape->nVertices;
                    [line addPathToPolyline];
                    if( partNumber == psShape->nParts-1 )
                    {
                        end = psShape->nVertices;
                    }
                    
                    for( int v = start; v < end; v++ )
                    {
                        AGSPoint *point =	[AGSPoint pointWithX:psShape->padfX[v] y:psShape->padfY[v] spatialReference:nil];
                        [line addPoint:point toPath:partNumber];
                    }
                }
                gra = [AGSGraphic graphicWithGeometry:line symbol:nil attributes:nil];
            }
                break;
            case SHPT_POLYGON:
            {
                AGSMutablePolygon * polygon = [[AGSMutablePolygon alloc] init];
                
                for( int partNumber = 0; partNumber < psShape->nParts; partNumber++ )
                {                      
                    int start = psShape->nParts > 1 ? psShape->panPartStart[partNumber] : 0;
                    int end = psShape->nParts > 1 ? psShape->panPartStart[ partNumber + 1 ] : psShape->nVertices;
                    
                    if( partNumber == psShape->nParts-1 )
                    {
                        end = psShape->nVertices;
                    }
                    [polygon addRingToPolygon];
                    for( int v = start; v < end; v++ )
                    {
                        AGSPoint *point =	[AGSPoint pointWithX:psShape->padfX[v] y:psShape->padfY[v] spatialReference:nil];
                        [polygon addPointToRing:point];
                    }
                }
                gra = [AGSGraphic graphicWithGeometry:polygon symbol:nil attributes:nil];
            }
                break;
            default:
                break;
        }
        SHPDestroyObject( psShape );
        //read att
        int fCount = DBFGetFieldCount(hDBF);
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:10];
        for( int fIndex = 0; fIndex < fCount; fIndex++ )
        {
            char		szTitle[12];
            DBFFieldType	eType = DBFGetFieldInfo( hDBF, fIndex, szTitle, &nWidth, &nDecimals );            
            
            switch (eType ) 
            {
                case FTString:
                {
                    if (szTitle != NULL) 
                    {
                        NSString* fName = [NSString stringWithCString:szTitle encoding:ENCODING];
                        const char * value = DBFReadStringAttribute(hDBF, i, fIndex);
                        NSString * fValue = value == NULL ? @"" : [NSString stringWithCString: value encoding:ENCODING];
                        
                        NSLog(@"%@---%@",fName,fValue);
                        
                        [dict setObject:fValue forKey: fName];
                    }
                }
                    break;
                    
                case FTInteger:
                {
                    NSString* key = [NSString stringWithCString:szTitle encoding:ENCODING];
                    [dict setObject:[NSNumber numberWithInt: DBFReadIntegerAttribute(hDBF, i, fIndex)] forKey:key ];
                }
                    break;
                    
                case FTDouble:
                {
                    NSString* key = [NSString stringWithCString:szTitle encoding:ENCODING];
                    if (key != nil)
                    {
                        [dict setObject:[NSNumber numberWithDouble: DBFReadDoubleAttribute(hDBF, i, fIndex)] forKey: key];
                    }
                }
                    break;
                    
                case FTInvalid:
                    //   strcpy (ftype, "invalid/unsupported");
                    break;
                    
                default:
                    //   strcpy (ftype, "unknown");
                    break;			
            }
            
        }
        gra.attributes = dict;
        
        [data addObject:gra];
        
    }
    SHPClose( hSHP );	
    DBFClose( hDBF );
    return  data;
}

void createPointShapefile(NSArray* graphicList, NSString * shpPath,NSString* shpName)
{
    NSString * shpFile = [NSString stringWithFormat:@"%@/%@.shp",shpPath,shpName];
    NSString * dbfFile = [NSString stringWithFormat:@"%@/%@.dbf",shpPath,shpName];
    NSString * shxFile = [NSString stringWithFormat:@"%@/%@.shx",shpPath,shpName];
    
    SHPHandle hSHP;
    DBFHandle hDBF;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //若存在shp数据 先删除
    if ([fileManager fileExistsAtPath:shpFile] || [fileManager fileExistsAtPath:dbfFile])
    {
        [fileManager removeItemAtPath:shpFile error:nil];
        [fileManager removeItemAtPath:shxFile error:nil];
        [fileManager removeItemAtPath:dbfFile error:nil];
    }
    
    hSHP = SHPCreate([shpFile cStringUsingEncoding:ENCODING], SHPT_POINT);
    hDBF = DBFCreate([dbfFile cStringUsingEncoding:ENCODING]);
    
    //添加属性字段 并写属性值
    AGSGraphic* graphic0 = [graphicList objectAtIndex:0];
    for (NSString* key in [graphic0.allAttributes allKeys])
    {
        DBFAddField(hDBF, [key cStringUsingEncoding:ENCODING], FTString, 200, 0);
    }
    
    //添加图形数据
    for(int i=0;i<[graphicList count];i++)
    {
        AGSGraphic* graphic = [graphicList objectAtIndex:i];
        
        AGSPoint* point = (AGSPoint*)graphic.geometry;
        double px[1];
        double py[1];
        px[0] = point.x;
        py[0] = point.y;
        
        SHPObject* pObject = SHPCreateSimpleObject(SHPT_POINT, 1, px, py, NULL);
        if (pObject != NULL)
        {
            SHPWriteObject(hSHP, -1, pObject);
            SHPDestroyObject(pObject);
        }
        
        for (NSString* key in [graphic.allAttributes allKeys])
        {
            NSString* fieldValue = [graphic.allAttributes objectForKey:key];
            int index = DBFGetFieldIndex(hDBF, [key cStringUsingEncoding:ENCODING]);
            DBFWriteStringAttribute(hDBF, i, index, [[fieldValue isEqualToString:@""]?@"":fieldValue cStringUsingEncoding:ENCODING]);
        }
    }
    SHPClose( hSHP );
    DBFClose( hDBF );
}

void graphics2shp(NSArray* graphicList, NSString* shpPath,NSString* shpName)
{
    //判断要素类型
    if (graphicList == nil || [graphicList count] <= 0)
    {
        return;
    }
    
    AGSGraphic* graphic = [graphicList objectAtIndex:0];
    AGSGeometry* geometry = graphic.geometry;
    if ([geometry isKindOfClass:[AGSPoint class]])
    {
        createPointShapefile(graphicList, shpPath, shpName);
    }
    else if ([geometry isKindOfClass:[AGSPolyline class]])
    {
    }
    else if ([geometry isKindOfClass:[AGSPolygon class]])
    {
    }
}


void addPoint2shp(AGSGraphic* graphic,SHPHandle hSHP,DBFHandle hDBF)
{
    AGSPoint* point = (AGSPoint*)graphic.geometry;
    double px[1];
    double py[1];
    px[0] = point.x;
    py[0] = point.y;
    
    SHPObject* pObject = SHPCreateSimpleObject(SHPT_POINT, 1, px, py, NULL);
    if (pObject != NULL)
    {
        SHPWriteObject(hSHP, -1, pObject);
        SHPDestroyObject(pObject);
    }
    
    int num = DBFGetRecordCount(hDBF);
    for (NSString* key in [graphic.allAttributes allKeys])
    {
        NSString* fieldValue = [graphic.allAttributes objectForKey:key];
        int index = DBFGetFieldIndex(hDBF, [key cStringUsingEncoding:ENCODING]);
        DBFWriteStringAttribute(hDBF, num, index, [[fieldValue isEqualToString:@""]?@"NONE":fieldValue cStringUsingEncoding:ENCODING]);
    }
}

void addGraphic2shp(AGSGraphic* graphic,NSString* shpPath,NSString* shpName)
{
    if (graphic == nil)
        return;
    
    AGSGeometry* geometry = graphic.geometry;
    
    SHPHandle	hSHP;
    DBFHandle   hDBF;
    int		nShapeType, nEntities;
    double 	adfMinBound[4], adfMaxBound[4];

    NSString * shpFile = [NSString stringWithFormat:@"%@/%@.shp",shpPath,shpName];
    NSString * dbfFile = [NSString stringWithFormat:@"%@/%@.dbf",shpPath,shpName];
    hSHP = SHPOpen([shpFile cStringUsingEncoding:ENCODING], "rb+" );
    hDBF  = DBFOpen([dbfFile cStringUsingEncoding:ENCODING], "rb+");
    if( hSHP == NULL  || hDBF == NULL)
    {
        return;
    }
  
    SHPGetInfo( hSHP, &nEntities, &nShapeType, adfMinBound, adfMaxBound );
    
    SHPObject	*psShape;		
    psShape = SHPReadObject( hSHP, 0 );	
    switch (nShapeType)
    {
        case SHPT_POINT:
        {
            if (![geometry isKindOfClass:[AGSPoint class]])
                return;
            addPoint2shp(graphic,hSHP,hDBF);
        }
            break;
        case SHPT_ARC:
        {
            if (![geometry isKindOfClass:[AGSPolyline class]])
                return;
        }
            break;
        case SHPT_POLYGON:
        {
            if (![geometry isKindOfClass:[AGSPolygon class]])
                return;
        }
            break;
        default:
            break;
    }
    
    SHPDestroyObject( psShape );
    SHPClose( hSHP );
    DBFClose( hDBF );
}



