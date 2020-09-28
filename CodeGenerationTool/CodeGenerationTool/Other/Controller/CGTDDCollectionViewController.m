//
//  CGTDDCollectionViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTDDCollectionViewController.h"

@interface CGTDDCollectionViewController ()

@property (nonatomic, strong) NSCollectionView *collectionView;

@end

@implementation CGTDDCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
	
	
}


#pragma mark - lazy load

- (NSCollectionView *)collectionView {
	if (!_collectionView) {
		_collectionView = [[NSCollectionView alloc] init];
		_collectionView.dataSource = self;
		_collectionView.delegate = self;
	}
	
	return _collectionView;
}

@end
