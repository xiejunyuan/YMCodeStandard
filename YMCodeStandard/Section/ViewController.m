//
//  ViewController.m
//  YMCodeStandard
//
//  Created by 涛 陈 on 6/16/15.
//  Copyright (c) 2015 cornapp. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "Masonry.h"

#import "ViewController.h"
#import "CustomView.h"
#import "ViewModel.h"

@interface ViewController()

@property (nonatomic, strong) CustomView *customSubView;
@property (nonatomic, strong) UIButton *subviewForButton;
@property (nonatomic, strong) ViewModel *viewModel;

@end

@implementation ViewController

// 方法分割顺序 dealloc and init / life cycle / Delegate / event response / public methods / private methods / getters and setters

#pragma mark - dealloc and init

#pragma mark - life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//self.view的处理可以放这里
	self.view.backgroundColor = [UIColor blackColor];
	
	//此方法只做addSubview,子视图在get方法进行初始化
	[self.view addSubview:self.subviewForButton];
	[self.view addSubview:self.customSubView];
	
	//设置ViewModel监听
	[self setupViewModel];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	//此方法对子视图进行Autolayout布局
	[self.subviewForButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.width.equalTo(self.view);
		make.top.equalTo(self.view).offset(60);
		make.height.equalTo(@30);
	}];
	
	[self.customSubView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.width.equalTo(self.view);
		make.top.equalTo(self.view).offset(160);
		make.height.equalTo(@180);
	}];
	
	//设置完Autolayout布局后,相应的View的Frame还是CGRectZero,需要调用layoutIfNeeded后才能获取正确的Frame
	NSLog(@"customSubView.frame before = %@", NSStringFromCGRect(self.customSubView.frame));
	[self.customSubView layoutIfNeeded];
	NSLog(@"customSubView.frame after = %@", NSStringFromCGRect(self.customSubView.frame));
}

#pragma mark - viewModel

//这里不仅可以描述ViewModel暴露的参数改变,也可以描述UI控件的响应
- (void)setupViewModel
{
	RAC(self.customSubView, title) = RACObserve(self.viewModel, title);
	
	@weakify(self);
	[RACObserve(self.viewModel, content) subscribeNext:^(NSString *content) {
		@strongify(self);
		NSLog(@"content is %@",content);
	}];
}

#pragma mark - delegate

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

#pragma mark - event response

//由用户点击触发的事件

- (void)subviewForButtonAction:(UIButton *)button
{
	[self.viewModel requestData];
}

#pragma mark - public methods

//存放公共方法

#pragma mark - private methods

//正常情况下ViewController里面一般是不会存在private methods的，因为private methods一般是用于日期换算、图片裁剪啥的这种小功能。这种小功能要么把它写成一个category，要么把做成一个模块，哪怕这个模块只有一个函数也行。

#pragma mark - getters and setters

//getters and setters 全部放在最后

- (CustomView *)customSubView
{
	if (_customSubView == nil) {
		_customSubView = [[CustomView alloc] init];
		_customSubView.backgroundColor = [UIColor redColor];
	}
	
	return _customSubView;
}

- (UIButton *)subviewForButton
{
	if (_subviewForButton == nil) {
		_subviewForButton = [[UIButton alloc] init];
		_subviewForButton.backgroundColor = [UIColor blueColor];
		[_subviewForButton setTitle:@"发送请求"
						   forState:UIControlStateNormal];
		[_subviewForButton addTarget:self
							  action:@selector(subviewForButtonAction:)
					forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _subviewForButton;
}

- (ViewModel *)viewModel
{
	if (_viewModel == nil) {
		_viewModel = [[ViewModel alloc] init];
	}
	
	return _viewModel;
}

@end