//
//  DSCollectionView.m
//  SearchApp
//
//  Created by Designstring on 10/5/16.
//  Copyright © 2016 Designstring. All rights reserved.
//

#import "DSCollectionView.h"

@interface DSCollectionView (){
    NSIndexPath *currentIndexPath;
}
    @property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
    @property (strong, nonatomic) DSImageCollectionViewCell *imageViewCell;
    @property (strong,nonatomic) NSArray *imageArray;
@end

@implementation DSCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //*************ARRAY********************
    _imageArray = @[@{@"title":@"fixed_height_still",@"url":@"http://media0.giphy.com/media/CYdCjeJIjuVO/200_s.gif"},@{@"title":@"fixed_height_downsampled",@"url":@"http://media0.giphy.com/media/CYdCjeJIjuVO/200_d.gif"},@{@"title":@"fixed_width",@"url":@"http://media0.giphy.com/media/CYdCjeJIjuVO/200w.gif"},@{@"title":@"fixed_width_still",@"url":@"http://media0.giphy.com/media/CYdCjeJIjuVO/200w_s.gif"},@{@"title":@"fixed_width_downsampled",@"url":@"http://media0.giphy.com/media/CYdCjeJIjuVO/200w_d.gif"}];
    
    
    
    
    //****Register CollectionView class and cell******
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[_imageViewCell class] forCellWithReuseIdentifier:@"imageView"];
    [self.collectionView registerNib: [UINib nibWithNibName:@"DSImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageView"] ;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//************COLLECTION VIEW****************//
- (NSInteger)numberOfSectionsInCollectionView:
(UICollectionView*)collectionView
    {
        return 1;
    }
- (NSInteger)collectionView:(UICollectionView*)collectionView
     numberOfItemsInSection:(NSInteger)section
    {
        return self.imageArray.count;
    }
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView
                 cellForItemAtIndexPath:(NSIndexPath*)indexPath
    {
        NSDictionary *productDict = _imageArray[indexPath.item];
        currentIndexPath= [NSIndexPath indexPathForItem:indexPath.item inSection:0];
        _imageViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageView"
                                                                     forIndexPath:indexPath];
     //   _imageViewCell.imageCell.image = [UIImage imageNamed:[productDict objectForKey:@"url"]];
        
        [_imageViewCell.imageCell sd_setImageWithURL:[NSURL URLWithString:[productDict objectForKey:@"url"]]
                     placeholderImage:[UIImage imageNamed:@""]
                              options:SDWebImageRefreshCached];
        return _imageViewCell;
    }
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }
-(int)getCurrentIndexItem:(int)toAppend{
    NSIndexPath *indexPath = nil;
    int currentIndex = 0;
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        indexPath = [self.collectionView indexPathForCell:cell];
        NSLog(@"%@",indexPath);
    }
    currentIndex = (int)indexPath.item + toAppend;
    return currentIndex;
}

@end
