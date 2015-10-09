//
//  DBDraws.m
//  hzch
//
//  Created by xtturing on 15/10/9.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "DBDraws.h"
#import "Utility.h"
@implementation DBDraws

-(id)init
{
    if (self = [super init])
    {
        [self openDatabase];
    }
    
    return (self);
}

- (void)dealloc
{
    [self closeDatabase];
    database = nil;
}

-(void)openDatabase
{
    NSString * documentDir = [Utility databaseDirectory];
    documentDir = [documentDir stringByAppendingPathComponent:@"mydraws.db"];
    
    database = [FMDatabase databaseWithPath:documentDir];
    if ([database open])
    {
        [database setShouldCacheStatements:YES];
    }
    else
    {
        NSLog(@"Failed to open database.");
        [self closeDatabase];
    }
}

-(void)closeDatabase
{
    [database close];
}

-(void)createTable
{
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS DRAWS (ROW INTEGER PRIMARY KEY, CREATE_DATE INTEGER,NAME TEXT, SOURCE_DATA BLOB);";
    BOOL bSucceed = [database executeUpdate:createSQL];
    if(!bSucceed)
    {
        NSLog(@"Failed to creating table. Error: %@",[database lastErrorMessage]);
        [self closeDatabase];
    }
}

-(void)dropTable
{
    NSString *createSQL = @"DROP TABLE IF EXISTS DRAWS";
    BOOL bSucceed = [database executeUpdate:createSQL];
    if(!bSucceed)
    {
        NSLog(@"Failed to creating table. Error: %@",[database lastErrorMessage]);
        [self closeDatabase];
    }
    
}

-(void)beginTransaction
{
    [database beginTransaction];
}

-(void)commit
{
    [database commit];
}

-(void)insertDraw:(Draw *)theDraw{
    if(theDraw == NULL)
        return;
    NSString *update = @"INSERT OR REPLACE INTO DRAWS (NAME,CREATE_DATE,SOURCE_DATA) VALUES (?,?,?);";
    BOOL bSecceed = [database executeUpdate:update,theDraw.name,[NSNumber numberWithLong:theDraw.createDate],theDraw.sourceData];
    if (!bSecceed)
    {
        NSLog(@"DBSchedule insertRecord Faild to update table. Error:%@",[database lastErrorMessage]);
    }
}

-(NSMutableArray *)getAllDraws{
    NSMutableArray * recordList = [NSMutableArray arrayWithCapacity:1];
    
    NSString *query = @"SELECT NAME, CREATE_DATE, SOURCE_DATA FROM DRAWS;";
    
    FMResultSet *rs = [database executeQuery:query];
    while ([rs next])
    {
        Draw * record = [[Draw alloc]init];
        record.name = [rs stringForColumn:@"NAME"];
        record.createDate = [rs longForColumn:@"CREATE_DATE"];
        record.sourceData = [rs dataForColumn:@"SOURCE_DATA"];
        [recordList addObject:record];
    }
    
    [rs close];
    
    return recordList;
}

-(void)deleteDraw:(long)createDate{
    NSString * query = @"DELETE FROM DRAWS WHERE CREATE_DATE=\"";
    query = [query stringByAppendingString:[NSString stringWithFormat:@"%ld",createDate]];
    query = [query stringByAppendingString:@"\""];
    BOOL bSucceed = [database executeUpdate:query];
    if(!bSucceed)
    {
        NSLog(@"DBPhoto deleteRecord Failed to update table. Error: %@",[database lastErrorMessage]);
    }
}

-(int)getCount{
    int nCount = 0;
    NSString *query = @"SELECT ROW FROM DRAWS ORDER BY ROW";
    FMResultSet *rs = [database executeQuery:query];
    while ([rs next])
    {
        nCount++;
    }
    
    [rs close];
    
    return nCount;
}

@end
