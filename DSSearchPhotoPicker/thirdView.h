//
//  thirdView.h
//  customPhotoPicker
//
//  Created by Ruthwick S Rai on 05/10/16.
//  Copyright © 2016 Ruthwick S Rai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface thirdView : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property( strong,nonatomic) NSString * passedResult;
@end
