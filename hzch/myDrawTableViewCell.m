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
@implementation myDrawTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)showDraw:(id)sender{
    if(_type == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_DRAW_LAYER" object:nil userInfo:@{@"draw":self.draw}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
    }else if(_type == 1){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_LOCAL_LAYER" object:nil userInfo:@{@"localurl":self.layerUrl}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
    }else if (_type == 2){
        
    }
}

- (IBAction)editDraw:(id)sender{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"修改名称", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    if(_type == 0){
        alert.tag = 70009;
    }else if(_type == 1){
        alert.tag = 80009;
    }else if (_type == 2){
        alert.tag = 90009;
    }
    UITextField *textfield =  [alert textFieldAtIndex: 0];
    textfield.text = self.titleLab.text;
    textfield.clearButtonMode = UITextFieldViewModeAlways;
    [alert show];
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
    if(alertView.tag == 70008){
        if (buttonIndex == 1)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[dataHttpManager getInstance].drawDB deleteDraw:self.titleLab.tag];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([self hasShowDraw:self.titleLab.tag]){
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
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_LOCAL_LAYER" object:nil userInfo:@{@"localurl":self.layerUrl}];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADTABLE" object:nil];
                });
            });
        }
    }
    return;
}

- (BOOL)hasShowDraw:(long)cellTag{
    for (id tag in [dataHttpManager getInstance].drawLayers) {
        if(cellTag == [tag longValue]){
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
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"删除缓存数据？", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 90008;
        [alert show];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
