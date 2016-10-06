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
    
    NSLog(@"second view: %@",_passedResult);
    //****Register CollectionView class and cell******
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[_imageViewCell class] forCellWithReuseIdentifier:@"imageView"];
    [self.collectionView registerNib: [UINib nibWithNibName:@"DSImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageView"] ;
    pageNumber = 0;
    [self.collectionView layoutIfNeeded];
    [self getImages:pageNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
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
    NSLog(@"image url: %@",_imageArray[indexPath.item]);
    [_imageViewCell.imageCell sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/giphy.gif",_imageArray[indexPath.item]]]
                                placeholderImage:[UIImage imageNamed:@""]
                                         options:SDWebImageRefreshCached];
    return _imageViewCell;}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return CGSizeMake(self.collectionView.frame.size.width/4, self.self.collectionView.frame.size.width/4);
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
- (void)getImages:(int)pageId
{
    
    
    NSString *value = _passedResult;
    value = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    // Users Sign UP (POST Users/)
    // Create manager
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    NSString * serviceUrl =[NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?q=%@&api_key=dc6zaTOxFJmzC&limit=44&page=%d&rating=pg",value,pageId];
    NSLog(@"getImages url: %@",serviceUrl);
    
    [manager GET:serviceUrl parameters:nil progress:nil success:^(NSURLSessionTask* task, id results) {
        
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        NSLog(@"JSON getImages printed: %@", json);
        
        _imageArray = [json valueForKeyPath:@"data.url"];
        
        [_collectionView reloadData];
    }
         failure:^(NSURLSessionTask* operation, NSError* error) {
             
             NSLog(@"Error getImages printed: %@", error);
         }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(
       self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height))
    {
        
        if(_isPageRefreshing==NO && _isRefreshing == NO){
            _isPageRefreshing = YES;
            _isRefreshing = YES;
            [self getImages:pageNumber++];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isPageRefreshing = NO;
}


@end
