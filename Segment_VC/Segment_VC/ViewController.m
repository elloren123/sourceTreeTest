//
//  ViewController.m
//  Segment_VC
//
//  Created by adel on 2019/11/15.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ViewController.h"

#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"

#define SCREEN_WIDTH                              [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT                             [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,assign) UIViewController *selectedViewController;

@property(nonatomic, assign) NSInteger selectedViewCtlWithIndex;

@property(nonatomic,strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic ,strong)UIButton *rigBtn;

@property (nonatomic ,strong)OneViewController *oneVC;
@property (nonatomic ,strong)TwoViewController *twoVC;
@property (nonatomic ,strong)ThreeViewController *threeVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self createSegement];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    //TODO  ??
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSArray *dataArr = @[@"家庭",@"酒店",@"校园"];
    
    OneViewController *oneVC = [[OneViewController alloc] init];
    TwoViewController *twoVC = [[TwoViewController alloc] init];
    ThreeViewController *threeVC = [[ThreeViewController alloc] init];
    self.oneVC = oneVC;
    self.twoVC = twoVC;
    self.threeVC = threeVC;
    
    
    [self.scrollView addSubview:oneVC.view];
    
    twoVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.scrollView addSubview:twoVC.view];
    
    threeVC.view.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.scrollView addSubview:threeVC.view];
    
    NSInteger number = dataArr.count;
    self.segmentControl.frame = CGRectMake((SCREEN_WIDTH-180)/2, 20+6, 180, 32);
    for (int i = 0; i < number; i++) {
        [self.segmentControl insertSegmentWithTitle:dataArr[i] atIndex:i animated:NO];
    }
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*number, 0);
    self.segmentControl.selectedSegmentIndex = 0;
    self.scrollView.contentOffset = CGPointZero;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"家庭" forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    self.rigBtn = btn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
}

- (void)createSegement{
    if (!_segmentControl){
        _segmentControl = [[UISegmentedControl alloc]init];
        //        _segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
        _segmentControl.layer.masksToBounds = YES ;
        _segmentControl.layer.cornerRadius = 3.0;
        _segmentControl.tintColor = [UIColor whiteColor];
        _segmentControl.backgroundColor = [UIColor colorWithRed:224/255.0 green:33/255.0 blue:42/255.0 alpha:1];
        self.navigationItem.titleView = _segmentControl;
    }else{
        [_segmentControl removeAllSegments];
    }
    [_segmentControl addTarget:self
                        action:@selector(selectedSegmentClick:)
              forControlEvents:UIControlEventValueChanged];
}





//
//- (void)loadSetViewController:(NSArray *)arrViewCtl andSegementTitle:(NSArray *)arrTitle
//{
//    if ([_segmentControl numberOfSegments] > 0)
//    {
//        return;
//    }
//    for (int i = 0; i < [arrViewCtl count]; i++)
//    {
//        [self pushViewController:arrViewCtl[i] title:arrTitle[i]];
//    }
//    _segmentControl.frame = CGRectMake(0, 0, 200, 25);
//    [_segmentControl setSelectedSegmentIndex:0];
//    self.selectedViewCtlWithIndex = 0;
//
//
//
//}
//- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title
//{
//    [_segmentControl insertSegmentWithTitle:title atIndex:_segmentControl.numberOfSegments animated:NO];
//    [self addChildViewController:viewController];
//    [_segmentControl sizeToFit];
//}
//
//- (void)setSelectedViewCtlWithIndex:(NSInteger)index
//{
//    if (!_selectedViewController)
//    {
//        _selectedViewController = self.childViewControllers[index];
//        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f)
//        {
//            CGFloat fTop = 20.0f;
//            if (self.navigationController && !self.navigationController.navigationBar.translucent)
//            {
//                fTop = self.navigationController.navigationBar.frame.size.height;
//            }
//            CGRect frame = self.view.frame;
//            [_selectedViewController view].frame = CGRectMake(frame.origin.x, frame.origin.y - fTop, frame.size.width, frame.size.height);
//
//        }
//        else
//        {
//            [_selectedViewController view].frame = self.view.frame;
//        }
//        [self.view addSubview:[_selectedViewController view]];
//        [_selectedViewController didMoveToParentViewController:self];
//    }
//    else
//    {
//        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
//            [self.childViewControllers[index] view].frame = self.view.frame;
//        }
//        [self transitionFromViewController:_selectedViewController toViewController:self.childViewControllers[index] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished)
//         {
//             _selectedViewController = self.childViewControllers[index];
//             _selectedViewCtlWithIndex = index;
//         }];
//    }
//
//
//}

#pragma mark - action
- (void)selectedSegmentClick:(UISegmentedControl *)sender{
    NSInteger index = sender.selectedSegmentIndex;
    self.selectedViewCtlWithIndex = index;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:YES];
     [self changeItemWithIndex:index];
}

-(void)changeColor:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"家庭"]) {
        self.oneVC.view.backgroundColor = [UIColor purpleColor];
    }else if ([btn.titleLabel.text isEqualToString:@"酒店"]){
         self.twoVC.view.backgroundColor = [UIColor greenColor];
    }else{
         self.threeVC.view.backgroundColor = [UIColor brownColor];
    }
    
}

#pragma mark ------ UIScrollViewDelegate ------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {//滑动时同步segment
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    self.segmentControl.selectedSegmentIndex = index;
    [self changeItemWithIndex:index];
}

-(void)changeItemWithIndex:(NSInteger)index{
     NSArray *dataArr = @[@"家庭",@"酒店",@"校园"];
    [self.rigBtn setTitle:dataArr[index] forState:0];
}

@end
