//
//  myDrawTableViewCell.m
//  hzch
//
//  Created by xtturing on 15/10/9.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "myDrawTableViewCell.h"
#import "dataHttpManager.h"
#import "DBDraws.h"
#import "DownloadManager.h"
#import "SpatialDatabase.h"
@implementation myDrawTableViewCell

- (void)awakeFromNib {
    
}

- (IBAction)showDraw:(id)sender{
    if(_type == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_DRAW_LAYER" object:nil userInfo:@{@"draw":self.draw}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
    }else if(_type == 1 || _type == 2){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_LOCAL_LAYER" object:nil userInfo:@{@"localurl":self.layerUrl,@"name":self.titleLab.text}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
    }else{
        BOOL show = !self.cache.isShow;
        self.cache.isShow = show;
        [[dataHttpManager getInstance].cacheDB updateCache:self.cache];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
    }
}

- (IBAction)editDraw:(id)sender{
    if(_type == 0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"修改名称", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 70009;
        UITextField *textfield =  [alert textFieldAtIndex: 0];
        textfield.text = self.titleLab.text;
        textfield.clearButtonMode = UITextFieldViewModeAlways;
        [alert show];
    }else if (_type == 2){
        if(self.editSqlitBlock){
            self.editSqlitBlock();
        }
    }else{
        if(self.editSqlitBlock){
            self.editSqlitBlock();
        }
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"修改名称", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        alert.tag = 90009;
//        UITextField *textfield =  [alert textFieldAtIndex: 0];
//        textfield.text = self.titleLab.text;
//        textfield.clearButtonMode = UITextFieldViewModeAlways;
//        [alert show];
    }
    
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 70009)
    {
        if (buttonIndex == 1)
        {
            UITextField *textfield =  [alertView textFieldAtIndex: 0];
            if(textfield.text.length > 1){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.draw.name = textfield.text;
                    [[dataHttpManager getInstance].drawDB updateDraw:self.draw];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
                    });
                });
            }
            
        }
    }
    if (alertView.tag == 90009)
    {
        if (buttonIndex == 1)
        {
            UITextField *textfield =  [alertView textFieldAtIndex: 0];
            if(textfield.text.length > 1){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.cache.name = textfield.text;
                    [[dataHttpManager getInstance].cacheDB updateCache:self.cache];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
                    });
                });
            }
            
        }
    }
    if (alertView.tag == 60008)
    {
        if (buttonIndex == 1)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSFileManager *fileManage = [NSFileManager defaultManager];
                NSString *mapDir = [documentsDirectory stringByAppendingPathComponent:@"map"];
                NSString *layerDir = [mapDir stringByAppendingPathComponent:self.cache.layerName];
                if ([fileManage fileExistsAtPath:layerDir]) {
                    [fileManage removeItemAtPath:layerDir error:NULL];
                }
                [[dataHttpManager getInstance].cacheDB deleteCache:self.cache.createDate];
                [[NSUserDefaults standardUserDefaults]  setInteger:0 forKey:[NSString stringWithFormat:@"%@_%@",self.cache.name,@"FINISH"]];
                [[NSUserDefaults standardUserDefaults]  setInteger:0 forKey:[NSString stringWithFormat:@"%@_%@",_cache.name,@"TOTAL"]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
                });
            });
        }
    }
    if(alertView.tag == 70008){
        if (buttonIndex == 1)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[dataHttpManager getInstance].drawDB deleteDraw:self.titleLab.tag];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([self hasShowDraw:[NSString stringWithFormat:@"%ld",(long)self.titleLab.tag]]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_DRAW_LAYER" object:nil userInfo:@{@"draw":self.draw}];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
                });
            });
        }        
    }
    if(alertView.tag == 80008){
        if(buttonIndex == 1){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[DownloadManager sharedInstance]cancelDownload:self.layerUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([self hasAddLocalLayer:self.layerUrl]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_LOCAL_LAYER" object:nil userInfo:@{@"localurl":self.layerUrl,@"name":self.titleLab.text}];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
                });
            });
        }
    }
    if(alertView.tag == 90008){
        if(buttonIndex == 1){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                [[DownloadManager sharedInstance]cancelDownload:self.layerUrl];
                NSArray *array = [self.layerUrl componentsSeparatedByString:@"/"];
                NSString *name = [array objectAtIndex:(array.count-1)];
                NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                NSString *desPath=[[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"] stringByAppendingPathComponent:name];
                if([[name pathExtension] isEqualToString:@"sqlite"]){
                    SpatialDatabase *db = [SpatialDatabase databaseWithPath:desPath];
                    [db open];
                    
                    NSString *sql = [NSString stringWithFormat:@"DELETE FROM geometry_columns where f_table_name = \"%@\"",self.titleLab.text];
                    if([db executeUpdate:sql]){
                        sql = [NSString stringWithFormat:@"DROP TABLE %@",self.titleLab.text];
                        if(![db executeUpdate:sql]){
                            NSLog(@"删除sqlite失败！");
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if([self hasShowSqliteLayer:self.titleLab.text] && [self hasShowSqliteValue:self.layerUrl]){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_LOCAL_LAYER" object:nil userInfo:@{@"localurl":self.layerUrl,@"name":self.titleLab.text}];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
                });
            });
        }
    }
    return;
}

- (BOOL)hasShowSqliteLayer:(NSString *)cellTag{
    for (id tag in [dataHttpManager getInstance].sqliteLayers.allKeys) {
        if([cellTag isEqualToString: tag]){
            return YES;
        }
    }
    return NO;
}
- (BOOL)hasShowSqliteValue:(NSString *)layerurl{
    for (id tag in [dataHttpManager getInstance].sqliteLayers.allValues) {
        if([layerurl isEqualToString: tag]){
            return YES;
        }
    }
    return NO;
}
- (BOOL)hasShowDraw:(NSString *)cellTag{
    for (id tag in [dataHttpManager getInstance].drawLayers) {
        if([cellTag isEqualToString: tag]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasAddLocalLayer:(NSString *)name{
    for(NSString *layerurl in [dataHttpManager getInstance].localLayers){
        if([layerurl isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}

- (IBAction)deleteDraw:(id)sender{
    if(_type == 0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"删除标绘？", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 70008;
        [alert show];
    }else if(_type == 1){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"删除离线数据？", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 80008;
        [alert show];
    }else if (_type == 2){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"删除离线数据库？", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 90008;
        [alert show];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"删除缓存文件？", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 60008;
        [alert show];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
