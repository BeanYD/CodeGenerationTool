//
//  CGTDDCollectionViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTDDCollectionViewController.h"

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
	[scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
		make.height.equalTo(@200);
	}];
	
	[scrollView setDocumentView:self.collectionView];
}

- (void)initData {
	self.dataSource = [@[@[@"1", @"2", @"3", @"4", @"5", @"1", @"2", @"3", @"4", @"5", @"1", @"2", @"3", @"4", @"5"], @[@"1", @"2", @"3", @"4", @"5", @"1", @"2", @"3", @"4", @"5"]] mutableCopy];
}

#pragma mark - NSCollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
	return self.dataSource.count;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSArray *array = self.dataSource[section];
	return array.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
	
	NSCollectionViewItem *item = [collectionView makeItemWithIdentifier:@"itemIdentifier" forIndexPath:indexPath];
	NSTextField *textField = [[NSTextField alloc] init];
	textField.stringValue = self.dataSource[indexPath.section][indexPath.item];
	item.textField = textField;
	
	return item;
}

#pragma mark - NSCollectionViewDelegate


#pragma mark - lazy load

- (NSCollectionView *)collectionView {
	if (!_collectionView) {
//		NSCollectionViewFlowLayout *flowLayout = [[NSCollectionViewFlowLayout alloc] init];
//		flowLayout.scrollDirection = NSCollectionViewScrollDirectionVertical;
		_collectionView = [[NSCollectionView alloc] init];
//		_collectionView.collectionViewLayout = flowLayout;
		_collectionView.dataSource = self;
		_collectionView.delegate = self;
		[_collectionView registerClass:[NSCollectionViewItem class] forItemWithIdentifier:@"collectionViewItemId"];
	}
	
	return _collectionView;
}

@end
