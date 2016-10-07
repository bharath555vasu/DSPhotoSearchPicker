//
//  loadingView.m
//  FeetApart
//
//  Created by Punith B M on 24/08/16.
//  Copyright © 2016 Feetapart Wellness Pvt Ltd.,. All rights reserved.
//

#import "loadingView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FLAnimatedImage.h"
@implementation loadingView

//+ (loadingView *)instanciateFromNib {
//    NSLog(@"awake from nib");
//
//    return [NSBundle.mainBundle loadNibNamed:@"loadingView" owner:nil options:nil].firstObject;
//    
//    
//}
//-(void)awakeFromNib{
//    NSLog(@"awake from nib");
//   
//}

+(UIView *)instanciateFromNib:(CGRect)frame andGifWithSize:(CGSize)gifSize withExcessAlligner:(float)posiveHeight {
    float width = frame.size.width;
    float height = frame.size.height;
    UIView *spinnerView = [[UIView alloc]initWithFrame:frame];
    spinnerView.backgroundColor = [UIColor whiteColor];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"gif_1" withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
      FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
        FLAnimatedImageView *imageforFace =[[FLAnimatedImageView alloc]init];
    imageforFace.frame = CGRectMake((width/2)-(gifSize.width/2), ((height/2)-(gifSize.height/2)+posiveHeight), gifSize.width, gifSize.height);
    imageforFace.contentMode = UIViewContentModeScaleAspectFit;
        imageforFace.animatedImage = animatedImage;
    [spinnerView removeFromSuperview];
    [spinnerView addSubview:imageforFace];
    [spinnerView bringSubviewToFront:imageforFace];
   
   
    return spinnerView;
}
@end
