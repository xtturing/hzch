//
//  DBDraws.h
//  hzch
//
//  Created by xtturing on 15/10/9.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Draw.h"

@interface DBDraws : NSObject{
    FMDatabase    * database;
}

-(void)openDatabase;
-(void)closeDatabase;
-(void)createTable;
-(void)dropTable;
-(void)beginTransaction;
-(void)commit;
-(void)insertDraw:(Draw *)theDraw;
-(NSMutableArray *)getAllDraws;
-(void)deleteDraw:(long)createDate;
-(int)getCount;


@end
