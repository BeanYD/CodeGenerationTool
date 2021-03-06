//
//  CGTDDTableViewController.m
//  CodeGenerationTool
//
//  Created by dingbinbin on 2020/9/24.
//  Copyright © 2020 dingbinbin. All rights reserved.
//

#import "CGTDDTableViewController.h"
#import "NSTextField+Tip.h"
#import "NSTableCellView+Tip.h"

@interface CGTDDTableViewController ()<NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSTableView *stringTableView;

@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSTableView *objcTableView;

@property (nonatomic, strong) NSMutableArray *stringDataSource;

@property (nonatomic, strong) NSMutableDictionary *objcDataSource;
@property (nonatomic, assign) NSInteger maxRowNum;

@end

@implementation CGTDDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
	
	[self initData];
	
	[self.view addSubview:self.stringTableView];
	// 通过scrollView来滚动内部的tableview
	[self.view addSubview:self.scrollView];
    
    
    // 只沿一个方向进行滚动，滚动过程中不会在其他方向偏移。
    [[self.scrollView contentView] setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boundsDidChangeNotification:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:[self.scrollView contentView]];

	
	[self layoutSubviews];
    
}

- (void)layoutSubviews {
	[self.stringTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.bottom.equalTo(self.view);
		make.width.equalTo(@100);
	}];
	
	[self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.right.bottom.equalTo(self.view);
		make.height.equalTo(@400);
		make.left.equalTo(self.stringTableView.mas_right).offset(10);
	}];
	
	NSClipView *clipView = [[NSClipView alloc] init];
	[self.scrollView setContentView:clipView];
	[clipView setDocumentView:self.objcTableView];
	
}

- (void)initData {
	self.stringDataSource = [@[@"111", @"222", @"333"] mutableCopy];
//	self.objcDataSource = [@[@"444", @"555", @"666", @"777"] mutableCopy];
	
	// 模拟model
	self.objcDataSource = [@{
		@"column1": @[@"1", @"2", @"3"],
		@"column2": @[@"4", @"5", @"6"],
		@"column3": @[@"7", @"8"],
		@"column4": @[@"10", @"11", @"12"],

	} mutableCopy];
	
	for (NSArray *array in self.objcDataSource.allValues) {
		self.maxRowNum = MAX(self.maxRowNum, array.count);
	}
}


// noti
- (void)boundsDidChangeNotification:(NSNotification *)notification {
    // 在这里进行处理
    NSClipView *clipView = [notification object];

    // get the origin of the NSClipView of the scroll view that
    // we're watching
    NSPoint changedBoundsOrigin = [clipView documentVisibleRect].origin;
    changedBoundsOrigin.x = 0;
    if (clipView == self.scrollView.contentView) {
        [self.scrollView scrollClipView:clipView toPoint:changedBoundsOrigin];
        // 监控滚轮日志，如果使用xib文件，去除xib中tableview的cellview，部分版本下会影响滚轮位移
        NSLog(@"1++++++++++++++++++++++++=%.2f",changedBoundsOrigin.y);
    }
    if (clipView == self.scrollView.contentView) {
        [self.scrollView scrollClipView:clipView toPoint:changedBoundsOrigin];
    }
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	if (tableView == self.stringTableView) {
		return self.stringDataSource.count;
	}
//	return self.objcDataSource.count;
	return self.maxRowNum;
	
}

// 每次进入front都会调用一次，刷新页面，暂不使用
//- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
//	if (tableView == self.stringTableView) {
//		NSLog(@"%s %@", __func__, [tableView class]);
//		return self.stringDataSource[row];
//	}
//	return @"";
//
//}

#pragma mark - NSTableViewDelegate
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {

	NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
	if (!cellView) {
		cellView = [[NSTableCellView alloc] init];
	}
	NSTextField *textField = [[NSTextField alloc] init];
    textField.editable = NO;
    textField.usesSingleLineMode = YES;
    textField.drawsBackground = YES;
    textField.backgroundColor = [NSColor clearColor];
    textField.textColor = [NSColor blackColor];
    textField.font = [NSFont systemFontOfSize:12.f];
	[cellView addSubview:textField];
	[textField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(cellView);
	}];
	if (tableView == self.stringTableView) {
		textField.stringValue = self.stringDataSource[row];
		return cellView;
	}

	NSArray *stringArr = self.objcDataSource[tableColumn.identifier];
	
	// 数组保护
	if (stringArr.count <= row) {
		return nil;
	}
	
	textField.stringValue = stringArr[row];
	
	return  cellView;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 25;
}

#pragma mark - lazy load
- (NSTableView *)stringTableView {
	if (!_stringTableView) {
		_stringTableView = [[NSTableView alloc] init];
		_stringTableView.dataSource = self;
		_stringTableView.delegate = self;
		NSTableHeaderView *tableHeadView=[[NSTableHeaderView alloc] initWithFrame:[CGTFrameConfig getHalfWidthDefaultWindowFrame]];
		[_stringTableView setHeaderView:tableHeadView];

		NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"stringColumnIdentifier"];
		column.title = @"列";
		column.minWidth = 50;
		column.width = 100;
		column.editable = YES;
		[_stringTableView addTableColumn:column];
	}
	
	return _stringTableView;
}

- (NSScrollView *)scrollView {
	if (!_scrollView) {
		_scrollView = [[NSScrollView alloc] init];
	}
	
	return _scrollView;
}

- (NSTableView *)objcTableView {
	if (!_objcTableView) {
		_objcTableView = [[NSTableView alloc] init];
		_objcTableView.dataSource = self;
		_objcTableView.delegate = self;
        _objcTableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
		NSTableHeaderView *tableHeadView=[[NSTableHeaderView alloc] init];
		[_objcTableView setHeaderView:tableHeadView];
		
		NSArray *keys = [self.objcDataSource.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
			NSString *str1 = obj1;
			NSString *str2 = obj2;
			return [str1 compare:str2 options:NSNumericSearch];
		}];
		
		for (NSString *identifier in keys) {
			NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:identifier];
			column.title = identifier;
			column.minWidth = 50;
			column.width = 100;
			column.editable = YES;
			[_objcTableView addTableColumn:column];
		}
	}
	
	return _objcTableView;
}

- (NSMutableArray *)stringDataSource {
	if (!_stringDataSource) {
		_stringDataSource = [NSMutableArray array];
	}
	
	return _stringDataSource;
}

- (NSMutableDictionary *)objcDataSource {
	if (!_objcDataSource) {
		_objcDataSource = [NSMutableDictionary dictionary];
	}
	
	return _objcDataSource;
}

@end
