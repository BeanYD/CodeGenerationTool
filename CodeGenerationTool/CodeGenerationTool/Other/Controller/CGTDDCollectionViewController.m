//
//  CGTDDCollectionViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTDDCollectionViewController.h"

#import "CGTDDCollectionViewItem.h"

@interface CGTDDCollectionViewController ()<NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CGTDDCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
	
	[self initData];
	
	NSScrollView *scrollView = [[NSScrollView alloc] init];
	[self.view addSubview:scrollView];

	
	NSClipView *clipView = [[NSClipView alloc] init];
	
	[scrollView setContentView:clipView];
	scrollView.needsLayout = true;
	// 使用约束的话 下面这句话是必须有的 否则会影响window，导致window不能用鼠标改变大小
	scrollView.translatesAutoresizingMaskIntoConstraints = false;
	
	[clipView setDocumentView:self.collectionView];
	
	[scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
		make.height.equalTo(@200);
	}];
}

- (void)initData {
	self.dataSource = [@[@"1", @"2", @"3", @"4", @"5", @"1", @"2", @"3", @"4", @"5", @"1", @"2", @"3", @"4", @"5"] mutableCopy];

}

#pragma mark - NSCollectionViewDataSource
- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return self.dataSource.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
	
	CGTDDCollectionViewItem *item = [collectionView makeItemWithIdentifier:@"collectionViewItemId" forIndexPath:indexPath];
	if (!item) {
		item = [[CGTDDCollectionViewItem alloc] init];
	}
//	NSTextField *textField = [[NSTextField alloc] in
    
    it];
//	textField.stringValue = self.dataSource[indexPath.item];
//	item.textField = textField;
    
    [item loadName:self.dataSource[indexPath.item]];
	
	return item;
}

#pragma mark - NSCollectionViewDelegate


#pragma mark - lazy load

- (NSCollectionView *)collectionView {
	if (!_collectionView) {
		_collectionView = [[NSCollectionView alloc] init];
		NSCollectionViewFlowLayout *layout = [[NSCollectionViewFlowLayout alloc] init];
		layout.scrollDirection = NSCollectionViewScrollDirectionVertical;
		_collectionView.collectionViewLayout = layout;
		_collectionView.dataSource = self;
		_collectionView.delegate = self;
		[_collectionView registerClass:[CGTDDCollectionViewItem class] forItemWithIdentifier:@"collectionViewItemId"];
	}
	
	return _collectionView;
}

@end
