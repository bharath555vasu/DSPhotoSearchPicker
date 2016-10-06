//
//  DSSecondView.m
//  customPhotoPicker
//
//  Created by Ruthwick S Rai on 05/10/16.
//  Copyright © 2016 Ruthwick S Rai. All rights reserved.
//

#import "DSSecondView.h"
#import "AFNetworking.h"
@interface DSSecondView ()
{
    NSIndexPath *currentIndexPath;
    int pageNumber;
}
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isPullToRefresh;
@property (nonatomic)BOOL isPageRefreshing;
@property (nonatomic)BOOL pullRefreshChecker;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) DSImageCollectionViewCell *imageViewCell;
@property (strong,nonatomic) NSArray *imageArray;
@end

@implementation DSSecondView
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"second view: %@",_passedResult);
    //****Register CollectionView class and cell******
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView layoutIfNeeded];
    pageNumber = 0;
     [self getImages:pageNumber];
    
    
    
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
 
    return _imageArray.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView
                 cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    
    [self.collectionView registerClass:[DSImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageView"];
    [self.collectionView registerNib: [UINib nibWithNibName:@"DSImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageView"] ;
    
    
    DSImageCollectionViewCell *imageViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageView"
                                                                                         forIndexPath:indexPath];
    //   _imageViewCell.imageCell.image = [UIImage imageNamed:[productDict objectForKey:@"url"]];
    [imageViewCell.imageCell sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_imageArray[indexPath.item]]]
                               placeholderImage:[UIImage imageNamed:@""]];
    NSLog(@"image url: %@",_imageArray[indexPath.item]);
    
    return imageViewCell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger lastRowIndex = [_collectionView numberOfItemsInSection:0] - 2;
    if ((indexPath.section == 0) && (indexPath.row == lastRowIndex)) {
        // This is the last cell
        NSLog(@"last cell");
        if(_isPageRefreshing==NO && _isRefreshing == NO){
            _isPageRefreshing = YES;
            _isRefreshing = YES;
            [self getImages:pageNumber++];
        }
        
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    NSLog(@"sizeForItemAtIndexPath  %f",screenWidth/4);
    return CGSizeMake(screenWidth/4, screenWidth/4);
}

- (void)getImages:(int)pageId
{
    
    NSString  *pageNumberString = [NSString stringWithFormat:@"%d",pageNumber];
    NSString *value = _passedResult;
    value = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    // Users Sign UP (POST Users/)
    // Create manager
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    NSString * serviceUrl =[NSString stringWithFormat:@"https://api.500px.com/v1/photos?term=%@&consumer_key=Lf9VcQJOAiIObtIKeceK4DG4lOgX8upLboYhFEVM&rpp=44&page=%@",value,pageNumberString];
    NSLog(@"500px getImages url: %@",serviceUrl);
    
    [manager GET:serviceUrl parameters:nil progress:nil success:^(NSURLSessionTask* task, id results) {
        
        _imageArray = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        
        
        _imageArray = [json valueForKeyPath:@"photos.image_url"];
        NSLog(@"JSON 500px getImages printed: %@", _imageArray);
        [self.collectionView reloadData];
        
        // [self.collectionView performBatchUpdates:^{
        //      [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        // } completion:nil];
    }
         failure:^(NSURLSessionTask* operation, NSError* error) {
             
             NSLog(@"Error 500px getImages printed: %@", error);
         }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(
       self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height))
    {
        
        if(_isPageRefreshing==NO && _isRefreshing == NO){
            _isPageRefreshing = YES;
            _isRefreshing = YES;
            NSLog(@"api set again");
            [self getImages:pageNumber++];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isPageRefreshing = NO;
}


@end
