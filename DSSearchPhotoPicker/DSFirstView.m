//
//  DSFirstView.m
//  customPhotoPicker
//
//  Created by Ruthwick S Rai on 05/10/16.
//  Copyright © 2016 Ruthwick S Rai. All rights reserved.
//

#import "DSFirstView.h"
#import "AFNetworking.h"
@interface DSFirstView ()
{
   // NSIndexPath *currentIndexPath;
    int pageNumber;
    NSArray *imageArray;
}
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isPullToRefresh;
@property (nonatomic)BOOL isPageRefreshing;
@property (nonatomic)BOOL pullRefreshChecker;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DSFirstView
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  }
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"first view: %@",_passedResult);
    //****Register CollectionView class and cell******
    imageArray = @[@"http://giphy.com/gifs/funny-school-fails-BTK92zTVQZopq",
                   @"http://giphy.com/gifs/SQiQu6lbG8bn2",
                   @"http://giphy.com/gifs/geozuBY5Y6cXm",
                   @"http://giphy.com/gifs/test-testing-expected-7MZ0v9KynmiSA",
                   @"http://giphy.com/gifs/archiecomics-archie-comics-archies-weird-mysteries-brain-of-terror-xT1XGWGd90BrYwnTl6"];
    self.collectionView.dataSource = self;
     self.collectionView.delegate = self;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    pageNumber = 0;
   /// [self getImages:pageNumber];

    

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
    NSLog(@"imageArray count %lu",(unsigned long)imageArray.count);
    return imageArray.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView
                 cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
   
    [self.collectionView registerClass:[DSImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageView"];
    [self.collectionView registerNib: [UINib nibWithNibName:@"DSImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageView"] ;
    
  
    DSImageCollectionViewCell *imageViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageView"
                                                               forIndexPath:indexPath];
    //   _imageViewCell.imageCell.image = [UIImage imageNamed:[productDict objectForKey:@"url"]];
   
    [imageViewCell.imageCell sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/giphy.gif",imageArray[indexPath.item]]]
                                placeholderImage:[UIImage imageNamed:@""]];
     NSLog(@"image url: %@",[NSString stringWithFormat:@"%@/giphy.gif",imageArray[indexPath.item]]);
    
    return imageViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    NSLog(@"sizeForItemAtIndexPath  %f",screenWidth/4);
    return CGSizeMake(screenWidth/4, screenWidth/4);
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
       
        imageArray = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        
        
        imageArray = [json valueForKeyPath:@"data.url"];
        NSLog(@"JSON getImages printed: %@", imageArray);
                  [self.collectionView reloadData];
      
       // [self.collectionView performBatchUpdates:^{
      //      [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
       // } completion:nil];
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
