//
//  ADLCommentImageView.m
//  lockboss
//
//  Created by adel on 2019/9/25.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLCommentImageView.h"
#import <UIImageView+WebCache.h>
#import "ADLImagePreView.h"


#define HWStatusPhotoWH (SCREEN_WIDTH-50)/3
#define HWStatusPhotoMargin 10
#define HWStatusPhotoMaxCol(count) ((count==4)?2:3)

@interface ADLCommentImageView ()
@property (nonatomic , weak)UIImageView*photoView;
@end

@implementation ADLCommentImageView // 9

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // self.frame = CGRectMake(0, 0, screenWidth, (self.photos.count%3+1) * HWStatusPhotoWH+self.photos.count%3*10);
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    NSUInteger photosCount = photos.count;
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        UIImageView *photoView = [[UIImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            //photoView.photo = photos[i];
            if (self.isSmall == YES) {
    [photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_photos[i]]] placeholderImage:[UIImage imageNamed:@"chat_album"]];
                
           
            }else{
                photoView.image =[UIImage imageNamed:@"chat_album"];
            }
            
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    int maxCol = HWStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        UIImageView *photoView = self.subviews[i];
        photoView.tag = i;
        [photoView addGestureRecognizer:tap];
        photoView.userInteractionEnabled = YES;
        int col = i % maxCol;
        photoView.x =10 + col * (HWStatusPhotoWH + HWStatusPhotoMargin);
        int row = i / maxCol;
        photoView.y = row * (HWStatusPhotoWH + HWStatusPhotoMargin);
        photoView.width = HWStatusPhotoWH;
        photoView.height = HWStatusPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count
{
    // 最大列数（一行最多有多少列）
    int maxCols = HWStatusPhotoMaxCol(count);
    NSUInteger cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * HWStatusPhotoWH + (cols - 1) * HWStatusPhotoMargin;
    
    // 行数
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * HWStatusPhotoWH + (rows - 1) * HWStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}
-(void)tap:(UITapGestureRecognizer*)tap{
    
       NSInteger tag = tap.view.tag;
  
     [ADLImagePreView showWithImageViews:@[tap.view] urlArray:self.photos currentIndex:tag];
}


@end
