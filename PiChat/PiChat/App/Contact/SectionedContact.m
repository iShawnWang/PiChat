//
//  SectionedContact.m
//  PiChat
//
//  Created by pi on 16/5/11.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "SectionedContact.h"
#import "User.h"

@interface SectionedContact ()
@property (strong,nonatomic) NSMutableDictionary *sectionedContact;
@end

@implementation SectionedContact

-(NSMutableDictionary *)sectionedContact{
    if(!_sectionedContact){
        _sectionedContact=[NSMutableDictionary dictionary];
    }
    return _sectionedContact;
}
#pragma mark - Public

-(void)addUser:(User*)u{
    __block BOOL firstLetterExistInSectionedContacts=NO;
    NSString *userFirstLetter= [u.displayName substringToIndex:1];
    [self.sectionedContact enumerateKeysAndObjectsUsingBlock:^(NSString *firstLetter, NSMutableArray *contacts, BOOL * _Nonnull stop) {
        if([userFirstLetter isEqualToString:firstLetter]){
            [contacts addObject:u];
            *stop=YES;
            firstLetterExistInSectionedContacts=YES;
        }
    }];
    
    if(!firstLetterExistInSectionedContacts){
        NSMutableArray *contacts=[NSMutableArray arrayWithObject:u];
        [self.sectionedContact  setObject:contacts forKey:userFirstLetter];
    }
}

-(NSInteger)numberOfSection{
    return self.sectionedContact.allKeys.count;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    NSArray *array= (NSMutableArray*)self.sectionedContact.allValues[section];
    return array.count;
}

-(User*)userForIndexPath:(NSIndexPath*)indexPath{
    NSArray *contacts= self.sectionedContact.allValues[indexPath.section];
    User *u=contacts[indexPath.row];
    return u;
}

-(NSString*)titleForHeaderInSection:(NSInteger)section{
    return self.sectionedContact.allKeys[section];
}

-(NSArray<NSString *> *)sectionIndexTitles{
    return self.sectionedContact.allKeys;
}

-(void)clearContacts{
    [self.sectionedContact removeAllObjects];
}

@end
