//
//  ViewController.m
//  CollectionCircleDemo
//
//  Created by Damon on 2017/5/24.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "ViewController.h"
#import "JLXUICollectionViewFlowLayout.h"
#import "HomeCaseCell.h"

static NSString * const reuseIdentifier = @"HomeCaseCellID";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *caseArray;
@property (assign,nonatomic) NSInteger m_currentIndex;
@property (assign,nonatomic) CGFloat m_dragStartX;
@property (assign,nonatomic) CGFloat m_dragEndX;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadData];
}

-(void)createUI{
    JLXUICollectionViewFlowLayout *layout = [[JLXUICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kItemW, kItemH);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 1000;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:kJLXBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[HomeCaseCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];

    [self.collectionView setFrame:CGRectMake(0, 0, JLXScreenSize.width, JLXScreenSize.height)];
    self.collectionView.contentSize = CGSizeMake(self.caseArray.count*JLXScreenSize.width, 0);
}

-(void)loadData{
    NSArray *array = [NSArray arrayWithObjects:@"img1",@"img2",@"img3",@"img4", nil];
    self.caseArray = [NSMutableArray arrayWithArray:array];
    ///加四次为了循环
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.m_currentIndex = 0;
}

//配置cell居中
- (void)scrollToCenter {
    //最小滚动距离
    float dragMiniDistance = self.view.bounds.size.width/20.0f;
    if (self.m_dragStartX -  self.m_dragEndX >= dragMiniDistance) {
        self.m_currentIndex -= 1;//向右
    }else if(self.m_dragEndX -  self.m_dragStartX >= dragMiniDistance){
        self.m_currentIndex += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    
    
    self.m_currentIndex = self.m_currentIndex <= 0 ? 0 : self.m_currentIndex;
    self.m_currentIndex = self.m_currentIndex >= maxIndex ? maxIndex : self.m_currentIndex;
    
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.caseArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //自定义collectonView content最左边和最右边两边的缩进
    return UIEdgeInsetsMake(0, (self.view.bounds.size.width - kItemW) / 2.0, 0, (self.view.bounds.size.width - kItemW) / 2.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.coverImgView setImage:[UIImage imageNamed:[self.caseArray objectAtIndex:indexPath.item]]];
    
    return cell;
}


#pragma mark -
#pragma mark - UIScrollViewDelegate

//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.m_dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.m_dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToCenter];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"willDisplayCell:%ld",(long)indexPath.item);
}

@end
