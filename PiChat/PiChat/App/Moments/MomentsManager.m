//
//  MomentsManager.m
//  PiChat
//
//  Created by pi on 16/3/21.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MomentsManager.h"
#import "Moment.h"
#import <AVOSCloud.h>
#import "User.h"
#import "UserManager.h"


@interface MomentsManager ()
@property (strong,nonatomic) NSMutableArray *momentImageFile;
@property (strong,nonatomic) NSOperationQueue *uploadImageFileQueue;
@end

@implementation MomentsManager

-(NSMutableArray *)momentImageFile{
    if(!_momentImageFile){
        _momentImageFile=[NSMutableArray array];
    }
    return _momentImageFile;
}

-(NSOperationQueue *)uploadImageFileQueue{
    if(!_uploadImageFileQueue){
        _uploadImageFileQueue=[[NSOperationQueue alloc]init];
    }
    return _uploadImageFileQueue;
}
#pragma mark -

-(void)postMomentWithContent:(NSString*)content images:(NSArray*)images{
    [self.momentImageFile removeAllObjects];
    [self.uploadImageFileQueue cancelAllOperations];
    
    //纯文字朋友圈
    if(!images){
        Moment *m= [self newMoment:content images:nil];
        [m saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                [NSNotification postPostMomentFailedNotification:self error:error];
            }else{
                [NSNotification postPostMomentCompleteNotification:self moment:m];
            }
        }];
        return;
    }
    
    //有图片的朋友圈,先上传图片
    NSInteger uploadImageCount=images.count;
    
    [images enumerateObjectsUsingBlock:^(NSURL *imgUrl, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.uploadImageFileQueue addOperationWithBlock:^{
            AVFile *image=[AVFile fileWithData:[NSData dataWithContentsOfURL:imgUrl]];
            
            [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error){
                    [NSNotification postPostMomentFailedNotification:self error:error];
                    [self.uploadImageFileQueue cancelAllOperations];
                    return ;
                }
                [self.momentImageFile addObject:image];
                //全部上传完毕
                if(self.momentImageFile.count==uploadImageCount){
                    Moment *m= [self newMoment:content images:self.momentImageFile];
                    NSError *error;
                    [m save:&error];
                    
                    [NSNotification postPostMomentCompleteNotification:self moment:m];
                }
            } progressBlock:^(NSInteger percentDone) {
                [NSNotification postPostMomentProgressNotification:self progress:percentDone];
            }];
            
        }];
        
    }];
    
}

-(Moment*)newMoment:(NSString*)content images:(NSArray*)images{
    Moment *m=[Moment objectWithClassName:NSStringFromClass([Moment class])];
    if(images){
        m.images =self.momentImageFile;
    }
    m.texts=content;
    m.postUser=[User currentUser];
    return m;
}

+(void)getCurrentUserMoments:(ArrayResultBlock)callback{
    [[UserManager sharedUserManager]fetchFriendsWithCallback:^(NSArray *friends, NSError *error) {
        //查找我发送的或者我的好友发送的朋友圈
        AVQuery *myMomentQuery= [AVQuery queryWithClassName:NSStringFromClass([Moment class])];
        [myMomentQuery whereKey:kPostUser equalTo:[User currentUser]];
        
        AVQuery *friendsMomentQuery= [AVQuery queryWithClassName:NSStringFromClass([Moment class])];
        [friendsMomentQuery whereKey:kPostUser containedIn:friends];
    
        AVQuery *query=[AVQuery orQueryWithSubqueries:@[myMomentQuery,friendsMomentQuery]];
        [query includeKey:@"images"];
        [query findObjectsInBackgroundWithBlock:callback];
        //    [query includeKey:@"createUserID"];
        //    [query includeKey:@"texts"];
    }];
}
@end
