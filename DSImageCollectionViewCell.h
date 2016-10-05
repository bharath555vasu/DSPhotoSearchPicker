//
//  DSImageCollectionViewCell.h
//  SearchApp
//
//  Created by Designstring on 10/5/16.
//  Copyright © 2016 Designstring. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol photoHandeler<NSObject>
@optional
-(void)url:(NSString*)selectedUrl withImage:(UIImage *)selectedImage;

@end

@interface DSImageCollectionViewCell : UICollectionViewCell
    @property (strong, nonatomic) IBOutlet UIImageView *imageCell;
@property (nonatomic,retain)id <photoHandeler> photoDelegate;
@end
