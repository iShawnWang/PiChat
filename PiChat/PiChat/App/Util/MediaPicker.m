//
//  MediaPicker.m
//  PiChat
//
//  Created by pi on 16/2/22.
//  Copyright © 2016年 pi. All rights reserved.
//

#import "MediaPicker.h"
#import "CommenUtil.h"

@interface MediaPicker ()<QBImagePickerControllerDelegate>
@property (strong,nonatomic) NSMutableArray *images;
@property (copy,nonatomic) ArrayResultBlock pickImageCallback;
@property (copy,nonatomic) UrlResultBlock pickVideoCallback;
@property (assign,nonatomic) BOOL needImageUrl; //返回 UIImage 数组还是图片Url 数组
@end

@implementation MediaPicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initPrivate];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initPrivate];
    }
    return self;
}

-(void)initPrivate{
    self.needImageUrl=NO;
    self.delegate=self;
    self.showsNumberOfSelectedAssets=YES;
}

-(NSMutableArray *)images{
    if(!_images){
        _images=[NSMutableArray array];
    }
    return _images;
}

#pragma mark - Public

-(void)showImagePickerIn:(UIViewController*)vc multipleSelectionCount:(NSInteger)count callback:(ArrayResultBlock)callback{
    [self.images removeAllObjects];
    self.needImageUrl=NO;
    self.pickImageCallback=callback;
    self.allowsMultipleSelection= count>1;
    self.maximumNumberOfSelection=count;
    self.mediaType=QBImagePickerMediaTypeImage;
    [vc presentViewController:self animated:YES completion:nil];
}

-(void)showImagePickerIn:(UIViewController *)vc multipleSelectionCount:(NSInteger)count imgUrlsCallback:(ArrayResultBlock)callback{
    
    [self showImagePickerIn:vc multipleSelectionCount:count callback:callback];
    self.needImageUrl=YES;
}

-(void)showVideoPickerIn:(UIViewController*)vc callback:(UrlResultBlock)callback{
    [self.images removeAllObjects];
    self.allowsMultipleSelection=NO;
    self.maximumNumberOfSelection=1;
    self.pickVideoCallback=callback;
    self.mediaType=QBImagePickerMediaTypeVideo;
    [vc presentViewController:self animated:YES completion:nil];
}

#pragma mark - QBImagePickerControllerDelegate

-(void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    PHAsset *firstAsset= [assets firstObject];
    
    if(firstAsset.mediaType ==PHAssetMediaTypeImage){
        PHImageRequestOptions *options=[PHImageRequestOptions new];
        options.resizeMode=PHImageRequestOptionsResizeModeFast;
        options.deliveryMode=PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        CGSize targetSize=[UIScreen mainScreen].bounds.size;
        [assets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                if(self.needImageUrl){
                    NSString *imgPath= [CommenUtil saveDataToCache:UIImagePNGRepresentation(result) fileName:[CommenUtil randomFileName]];
                    [self.images addObject:[NSURL fileURLWithPath:imgPath]];
                }else{
                    [self.images addObject:result];
                }
                
                if(assets.count==self.images.count){
                    self.needImageUrl=NO;
                    self.pickImageCallback(self.images,nil);
                }
            }];
        }];
    }
    else if(firstAsset.mediaType==PHAssetMediaTypeVideo){
        PHVideoRequestOptions *options=[PHVideoRequestOptions new];
        options.networkAccessAllowed=NO;
        [[PHImageManager defaultManager]requestAVAssetForVideo:firstAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            NSURL *url = [(AVURLAsset *)asset URL];
            self.pickVideoCallback(url,nil);
        }];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end