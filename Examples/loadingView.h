//
//  loadingView.h
//  FeetApart
//
//  Created by Punith B M on 24/08/16.
//  Copyright © 2016 Feetapart Wellness Pvt Ltd.,. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loadingView : UIView
//+ (loadingView *)instanciateFromNib;
+(UIView *)instanciateFromNib:(CGRect)frame andGifWithSize:(CGSize)gifSize withExcessAlligner:(float)posiveHeight ;
@end
