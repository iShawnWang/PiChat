//
//  BubbleImgFactory.m
//  PiChat
//
//  Created by pi on 16/2/20.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "BubbleImgFactory.h"
#import "UserManager.h"

@implementation BubbleImgFactory
+(instancetype)sharedBubbleImgFactory{
    static id _bubbleImgFactory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bubbleImgFactory=[[BubbleImgFactory alloc]init];
    });
    return _bubbleImgFactory;
}

-(JSQMessagesBubbleImage *)bubbleImgForMessage:(JSQMessage *)msg{
    if([msg.senderId isEqualToString:[UserManager sharedUserManager].currentUser.clientID]){
        return [self outGoingImg];
    }else{
        return [self inComingImg];
    }
}

-(JSQMessagesBubbleImage *)outGoingImg{
    static id _outGoingImg;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _outGoingImg=[self outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    });
    return _outGoingImg;
}

-(JSQMessagesBubbleImage *)inComingImg{
    static id _inComingImg;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _inComingImg=[self incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    });
    return _inComingImg;
}
@end
