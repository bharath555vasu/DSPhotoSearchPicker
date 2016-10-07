//
//  DSFirstView.m
//  customPhotoPicker
//
//  Created by Ruthwick S Rai on 05/10/16.
//  Copyright © 2016 Ruthwick S Rai. All rights reserved.
//

#import "DSFirstView.h"
#import "AFNetworking.h"
#import "UIScrollView+EmptyDataSet.h"
#import "DSViewController.h"
#import "loadingView.h"
@interface DSFirstView ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    int pageNumber;
    activityLoader *loader;
}
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isPullToRefresh;
@property (nonatomic)BOOL isPageRefreshing;
@property (nonatomic)BOOL pullRefreshChecker;

@property (strong,nonatomic) UIView * loadingView;
@end

@implementation DSFirstView
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  }
- (void)viewDidLoad {
    [super viewDidLoad];
   
    _imageArray = [[NSMutableArray alloc]init];
    NSLog(@"first view: %@",_passedResult);
    //****Register CollectionView class and cell******
    self.collectionView.dataSource = self;
     self.collectionView.delegate = self;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    [self.collectionView registerClass:[DSImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageView"];
    [self.collectionView registerNib: [UINib nibWithNibName:@"DSImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"imageView"] ;
    [self.collectionView registerClass:[activityLoader class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"activityLoader"];
    [self.collectionView registerNib: [UINib nibWithNibName:@"activityLoader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"activityLoader"] ;
    [self.collectionView layoutIfNeeded];
    pageNumber = 0;
    _loadingView = [UIView new];
    _loadingView = [loadingView instanciateFromNib:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) andGifWithSize:CGSizeMake(50, 50) withExcessAlligner:-50];
    [self.view addSubview:_loadingView];
    _loadingView.hidden = YES;
    if (_passedResult.length !=0) {
        _loadingView.hidden = NO;
        [self getImages:pageNumber];
    }
    
    
    
}
-(void)dealloc{
    self.collectionView.emptyDataSetSource = nil;
    self.collectionView.emptyDataSetDelegate = nil;
}



#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Search Gifs here!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -35.0;
}


- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 10.0f;
}
#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
 loader = [_collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                            withReuseIdentifier:@"activityLoader" forIndexPath:indexPath];
    if (_imageArray.count==0) {
         loader.hidden = YES;
    }else{
         loader.hidden = NO;
    }
   
    
        return loader;
       
    
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
   
   
    
  
    DSImageCollectionViewCell *imageViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageView" forIndexPath:indexPath];

    [imageViewCell.imageCell sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://media1.giphy.com/media/%@/100.gif",_imageArray[indexPath.item]]] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageCacheMemoryOnly];
//     NSLog(@"image url: %@",[NSString stringWithFormat:@"https://media1.giphy.com/media/%@/100.gif",_imageArray[indexPath.item]]);
    
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
    return CGSizeMake(screenWidth/4, screenWidth/4);
}

- (void)getImages:(int)pageId
{
    
     NSString  *pageNumberString = [NSString stringWithFormat:@"%d",pageNumber];
    NSString *value = _passedResult;
    value = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    NSString * serviceUrl =[NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?q=%@&api_key=dc6zaTOxFJmzC&limit=44&offset=%@&rating=pg",value,pageNumberString];
    NSLog(@"gify getImages url: %@",serviceUrl);
   
    [manager GET:serviceUrl parameters:nil progress:nil success:^(NSURLSessionTask* task, id results) {
       
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:results options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
        NSLog(@"gif image result: %@",json);
        NSArray * response = [json valueForKeyPath:@"data.id"];
        
        _isRefreshing = NO;
        if (pageNumber == 0) {
            _imageArray =[NSMutableArray arrayWithArray:response];
            _loadingView.hidden = YES;
            [self.collectionView reloadData];
                return;
        }
        [_imageArray addObjectsFromArray:response];
        NSMutableArray *indexArray = [NSMutableArray array];
        for (int i = 1; i<= response.count ; i++) {
            [indexArray addObject:[NSIndexPath indexPathForItem:self.imageArray.count - i inSection:0]];
        }
        
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:indexArray];
            
        }completion:nil];
        _loadingView.hidden = YES;
    }
         failure:^(NSURLSessionTask* operation, NSError* error) {
             _loadingView.hidden = YES;
                        NSLog(@"Error gifphy getImages printed: %@", error);
         }];
}
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"didselect item");
    NSString* passedId =[NSString stringWithFormat:@"http://media4.giphy.com/media/%@//giphy.gif",_imageArray[indexPath.item]];
    if([self.gifDelegate respondsToSelector:@selector(openGif:)]) {
        [self.gifDelegate openGif:passedId];
    }
    
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
