//
//  ImageCollectionViewCell.m
//  SearchApp
//
//  Created by Designstring on 10/5/16.
//  Copyright © 2016 Designstring. All rights reserved.
//

#import "DSImageCollectionViewCell.h"

@implementation DSImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    [self setNeedsLayout];
    // Initialization code
}
- (void)didMoveToSuperview {
    [self layoutIfNeeded];
    [self setNeedsLayout];
}
@end
