//
//  SectionedContact.h
//  PiChat
//
//  Created by pi on 16/5/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

/**
 *  模仿系统联系人界面,按用户首字母分Section
 */
@interface SectionedContact : NSObject

-(void)addUser:(User*)u;

-(NSInteger)numberOfSection;

-(NSInteger)numberOfRowsInSection:(NSInteger)section;

-(User*)userForIndexPath:(NSIndexPath*)indexPath;

-(NSString*)titleForHeaderInSection:(NSInteger)section;

-(NSArray<NSString *> *)sectionIndexTitles;

-(void)clearContacts;
@end
