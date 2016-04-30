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
#import "UIImage+ScaleSize.h"

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
    NSAssert(content!=nil, @"发送朋友圈内容不能为空");
    NSAssert(content.length>0, @"发送朋友圈内容不能为空");
    
    [self.momentImageFile removeAllObjects];
    [self.uploadImageFileQueue cancelAllOperations];
    
    //纯文字朋友圈
    if(!images || images.count == 0){
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
    CGSize screenSize=CGSizeApplyAffineTransform([UIScreen mainScreen].nativeBounds.size, CGAffineTransformMakeScale(0.5, 0.5)); //屏幕像素的一半
    
    [images enumerateObjectsUsingBlock:^(NSURL *imgUrl, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.uploadImageFileQueue addOperationWithBlock:^{
            
            UIImage *image= [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
            //图片太大就缩放一下...(width = 4288, height = 2848)
            if(image.size.width > screenSize.width || image.size.height > screenSize.height){
                image=[image scaledAspectFitImageToSize:screenSize];
            }
            AVFile *imageFile=[AVFile fileWithData:UIImagePNGRepresentation(image)];
            
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error){
                    [NSNotification postPostMomentFailedNotification:self error:error];
                    [self.uploadImageFileQueue cancelAllOperations];
                    return ;
                }
                [self.momentImageFile addObject:imageFile];
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
//    Moment *m=[Moment object];
    Moment *m=[Moment objectWithClassName:@"Moment"];
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
        [query orderByDescending:kCreatedAt];
        [query includeKey:kPostImages];
        [query includeKey:kFavourUsers];
        [query includeKey:kComments];
        [query findObjectsInBackgroundWithBlock:callback];
    }];
}

+(void)getMomentWithID:(NSString*)momentID callback:(MomentResultBlock)callback{
    AVQuery *momentQuery= [AVQuery queryWithClassName:NSStringFromClass([Moment class])];
    [momentQuery whereKey:kObjectIdKey equalTo:momentID];
    [momentQuery includeKey:kPostImages];
    [momentQuery includeKey:kFavourUsers];
    [momentQuery includeKey:kComments];
    [momentQuery getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        Moment *m=object ? (Moment*)object : nil;
        callback(m,error);
            
    }];
}
@end
