//
//  SettingTableController.m
//  PiChat
//
//  Created by pi on 16/5/5.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "SettingTableController.h"
#import "CommenUtil.h"
#import "ClearCacheCell.h"

@implementation SettingTableController
-(void)viewDidLoad{
    [super viewDidLoad];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            cell=(ClearCacheCell*)[tableView dequeueReusableCellWithIdentifier:kClearCacheCellID];
            ClearCacheCell *clearCacheCell=(ClearCacheCell*)cell;
            [clearCacheCell calcCacheSize];
            break;
    }
    return cell;
}
@end
