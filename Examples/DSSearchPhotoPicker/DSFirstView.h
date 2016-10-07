//
//  DSFirstView.h
//  customPhotoPicker
//
//  Created by Ruthwick S Rai on 05/10/16.
//  Copyright © 2016 Ruthwick S Rai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSImageCollectionViewCell.h"
#import "activityLoader.h"
#import <SDWebImage/UIImageView+WebCache.h>

@protocol gifSelected<NSObject>

-(void)openGif:(NSString *)passedId;

@end


@interface DSFirstView : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>
@property( strong,nonatomic) NSString * passedResult;
@property (strong,nonatomic) NSMutableArray *imageArray;
@property (nonatomic,retain)id <gifSelected> gifDelegate;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
