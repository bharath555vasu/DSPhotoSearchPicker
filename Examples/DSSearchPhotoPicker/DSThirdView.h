//
//  DSThirdView.h
//  customPhotoPicker
//
//  Created by Ruthwick S Rai on 05/10/16.
//  Copyright © 2016 Ruthwick S Rai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "activityLoader.h"
#import "DSImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@protocol imageSelected<NSObject>
@optional
-(void)openImage:(NSString *)passedURL;
@end
@interface DSThirdView : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property( strong,nonatomic) NSString * passedResult;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *imageArray;
@property (strong,nonatomic) NSMutableArray *contentArray;
@property (nonatomic,retain)id <imageSelected> imageDelegate;
@end
