//
//  DBTpkManager.h
//  hzch
//
//  Created by xtturing on 15/11/26.
//  Copyright © 2015年 xtturing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "NBTpk.h"

@interface DBTpkManager : NSObject{
    FMDatabase    * database;
}

-(void)openDatabase;
-(void)closeDatabase;
-(void)createTable;
-(void)dropTable;
-(void)beginTransaction;
-(void)commit;
-(void)insertTpk:(NBTpk *)theTpk;
-(NSMutableArray *)getAllTpk;
-(void)deleteTpk:(NSString *)url;
-(void)deleteTpks;
- (void)updateTpk:(NBTpk *)theTpk;
-(int)getCount;

@end
