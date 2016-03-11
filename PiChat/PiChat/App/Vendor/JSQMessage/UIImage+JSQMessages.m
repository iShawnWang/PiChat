#import "UIImage+JSQMessages.h"
#import <NSBundle+JSQMessages.h>

@implementation UIImage (JSQMessages)

+ (UIImage *)jsq_bubbleImageFromBundleWithName:(NSString *)name
{
    NSBundle *bundle = [NSBundle jsq_messagesAssetBundle];
    NSString *path = [bundle pathForResource:name ofType:@"png" inDirectory:@"Images"];
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)jsq_defaultPlayImage
{
    return [UIImage imageNamed:@"play"];
}

+ (UIImage *)jsq_defaultPauseImage
{
    return [UIImage imageNamed:@"pause"];
}

@end
