//
//  ADLEmojiInputView.m
//  lockboss
//
//  Created by adel on 2019/8/7.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLEmojiInputView.h"
#import "ADLAttributeFlowLayout.h"
#import "ADLEmojiViewCell.h"
#import "ADLGlobalDefine.h"

@interface ADLEmojiInputView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) id<ADLEmojiInputViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *emojiArr;
@end

@implementation ADLEmojiInputView

+ (instancetype)emojiViewWithDelegate:(id)delegate {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 255+BOTTOM_H) delegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
        self.emojiArr = [NSArray arrayWithContentsOfFile:path];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/8, 42);
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 213)];
        bgView.backgroundColor = COLOR_F2F2F2;
        [self addSubview:bgView];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 175) collectionViewLayout:layout];
        collectionView.backgroundColor = COLOR_F2F2F2;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        [collectionView registerClass:[ADLEmojiViewCell class] forCellWithReuseIdentifier:@"emoji"];
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.center = CGPointMake(SCREEN_WIDTH/2, 188);
        pageControl.currentPageIndicatorTintColor = COLOR_999999;
        pageControl.pageIndicatorTintColor = COLOR_D3D3D3;
        pageControl.transform = CGAffineTransformMakeScale(1.2, 1.2);
        pageControl.numberOfPages = 4;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        sendBtn.frame = CGRectMake(SCREEN_WIDTH-66, 213, 66, 42);
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        sendBtn.backgroundColor = APP_COLOR;
        [sendBtn addTarget:self action:@selector(clickSendEmojiBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
    }
    return self;
}

#pragma mark ------ UICollectionView Delegate && DataSource ------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 32;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADLEmojiViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emoji" forIndexPath:indexPath];
    NSString *emoji = self.emojiArr[indexPath.section*32+indexPath.item];
    if (emoji.length == 0) {
        cell.imgView.hidden = NO;
    } else {
        cell.imgView.hidden = YES;
    }
    cell.emojiLab.text = emoji;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *emoji = self.emojiArr[indexPath.section*32+indexPath.item];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickEmoji:)]) {
        [self.delegate didClickEmoji:emoji];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (scrollView.contentOffset.x+0.5*SCREEN_WIDTH)/SCREEN_WIDTH;
}

#pragma mark ------ 发送 ------
- (void)clickSendEmojiBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSend)]) {
        [self.delegate didClickSend];
    }
}

@end
