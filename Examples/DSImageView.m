//
//  DSImageView.m
//  DSSearchPhotoPicker
//
//  Created by Ruthwick S Rai on 07/10/16.
//  Copyright © 2016 Ruthwick S Rai. All rights reserved.
//

#import "DSImageView.h"
#import "FLAnimatedImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DSImageView ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation DSImageView

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"recievedurl: %@",_recivedUrl);
    [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_recivedUrl]] placeholderImage:[UIImage imageNamed:@"placeHolder"] options:SDWebImageCacheMemoryOnly];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
