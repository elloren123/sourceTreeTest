//
//  ADLListsortingView.m
//  lockboss
//
//  Created by adel on 2019/9/20.
//  Copyright © 2019 adel. All rights reserved.
//

#import "ADLListsortingView.h"
#import "ADLListsortingTableViewCell.h"

@interface ADLListsortingView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak)UIVisualEffectView * effe;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,assign)CGFloat navigheight;
@end

@implementation ADLListsortingView

-(instancetype)initWithFrame:(CGRect)frame navigheight:(CGFloat)navigheight {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.navigheight = navigheight;
        UIWindow *window =  [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        UIView *backView = [[UIView alloc] init];
        backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        backView.backgroundColor = [UIColor clearColor];
       // backView.alpha = 0.7;
        //  backView.frame = CGRectMake(18, lognViewY, screenWidth-36, 300, 300);
        //backView.backgroundColor = [UIColor blackColor];
        //backView.hidden = YES;
        [self addSubview:backView];
        self.backView = backView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [backView addGestureRecognizer:tap];
        
        UIView *titleView = [[UIView alloc] init];
        titleView.frame = CGRectMake(0,navigheight, SCREEN_WIDTH,SCREEN_HEIGHT - navigheight);
        titleView.backgroundColor = [UIColor blackColor];
        titleView.alpha = 0.7;
        
        [self addSubview:titleView];
        self.titleView = titleView;
        
        UITableView *tableView = [[UITableView alloc]init];
        tableView.frame  = CGRectMake(0,navigheight, SCREEN_WIDTH, 260);
        // tableView.backgroundColor = Coloreeeeee;
         tableView.backgroundColor = [UIColor whiteColor];
        tableView.alpha = 0.98;
        // tableView.bounces = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.tableFooterView = [UIView new];
   
         [self addSubview:tableView];
        self.tableView = tableView;
        
        
        
        [UIView animateWithDuration:0.25 animations:^{
           titleView.frame = CGRectMake(0,navigheight, SCREEN_WIDTH,SCREEN_HEIGHT - navigheight);
     
           tableView.frame  =  CGRectMake(0,navigheight, SCREEN_WIDTH,260);
            
        } completion:nil];
        

        
    }
    return self;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADLListsortingTableViewCell *cell = [ADLListsortingTableViewCell cellWithTableView:tableView];
    cell.title.text = self.array[indexPath.row];
    return cell;
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ListsortingView:didSelectRowAtIndexPath:iphone:)]) {
        [self.delegate ListsortingView:self didSelectRowAtIndexPath:indexPath iphone:nil];
    }
    [self remove];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
      [self remove];
//    if ([touches.anyObject.view isKindOfClass:[self class]]) {
//
//        [self remove];
//
//    }
}

- (void)remove
{
   
    WS(ws);
    [UIView animateWithDuration:0.1 animations:^{
        
       // self.titleView.frame = CGRectMake(0,ws.navigheight,SCREEN_WIDTH,0);
        self.tableView.frame  = CGRectMake(0,ws.navigheight, SCREEN_WIDTH, 0);
        //_backView.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)setArray:(NSArray *)array {
    _array = array;
    [self.tableView reloadData];
}
@end
