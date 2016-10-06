//
//  DSThirdView.m
//  customPhotoPicker
//
//  Created by Ruthwick S Rai on 05/10/16.
//  Copyright © 2016 Ruthwick S Rai. All rights reserved.
//

#import "DSThirdView.h"

@interface DSThirdView (){

}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) DSImageCollectionViewCell *imageViewCell;
@property (strong,nonatomic) NSArray *imageArray;

@end

@implementation DSThirdView
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"third view: %@",_passedResult);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //*************ARRAY********************
    _imageArray = @[@"http://media0.giphy.com/media/CYdCjeJIjuVO/200_s.gif",@"http://media0.giphy.com/media/CYdCjeJIjuVO/200_d.gif",@"http://media0.giphy.com/media/CYdCjeJIjuVO/200w.gif",@"http://media0.giphy.com/media/CYdCjeJIjuVO/200w_s.gif",@"http://media0.giphy.com/media/CYdCjeJIjuVO/200w_d.gif"];
    
    
    
    
    //****Register CollectionView class and cell******
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[_imageViewCell class] forCellWithReuseIdentifier:@"imageView"];
    [self.collectionView registerNib: [UINib nibWithNibName:@"DSImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageView"] ;
    [self.collectionView layoutIfNeeded];

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
  
    _imageViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageView"
                                                               forIndexPath:indexPath];
    //   _imageViewCell.imageCell.image = [UIImage imageNamed:[productDict objectForKey:@"url"]];
    
    [_imageViewCell.imageCell sd_setImageWithURL:[NSURL URLWithString:_imageArray[indexPath.item]]
                                placeholderImage:[UIImage imageNamed:@""]
                                         options:SDWebImageRefreshCached];
    return _imageViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return CGSizeMake(self.collectionView.frame.size.width/4, self.self.collectionView.frame.size.width/4);
}



@end
