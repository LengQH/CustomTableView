//
//  CustomTableView.h
//  CustomTableView
//
//  Created by 冷求慧 on 15/12/29.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface customIndexPath : NSObject
/** 标识选中的按钮 */
@property (nonatomic,assign)NSInteger selectBtn;
/** 标识选中的TableView */
@property (nonatomic,assign)NSInteger selectTableView;
/** Section的下标 */
@property (nonatomic,assign)NSInteger customSection;
/** Row的下标 */
@property (nonatomic,assign)NSInteger customRow;

-(instancetype)initWithIndexPath:(NSInteger)selectBtnParam  selectTable:(NSInteger)selectTableParam selecSection:(NSInteger)sectionParam selectRow:(NSInteger)customRowParam; //提供构造方法(动态方法)
+(instancetype)customIndexPath:(NSInteger)selectBtnParam  selectTable:(NSInteger)selectTableParam selecSection:(NSInteger)sectionParam selectRow:(NSInteger)customRowParam; //提供类方法(静态方法)
@end

@class CustomTableView;
@protocol CustomTableViewDataSource <NSObject> //定义一个数据源协议
@optional
/** 显示的Section的个数和传递的下标 */
-(NSInteger)showSectionNum:(CustomTableView *)cusView cusIndexPath:(customIndexPath *)indexPath;
/** 显示的Row的个数和传递的下标 */
-(NSInteger)showRowNum:(CustomTableView *)cusView cusIndexPath:(customIndexPath *)indexPath;
/** 显示的cell上面的数据和传递的下标 */
-(NSString *)showCellData:(CustomTableView *)cusView cusIndexPath:(customIndexPath *)indexPath;
@end

@protocol CustomTableViewDelegate <NSObject>
@optional
/** 选中的下标 */
-(void)selectTableIndexPath:(CustomTableView *)cusView cusIndexPath:(customIndexPath *)indexPath;
@optional
@end

@interface CustomTableView : UIView
/** 自定义视图的数据源  */
@property (nonatomic,weak)id<CustomTableViewDataSource>customViewDataSource;
/** 自定义视图的代理  */
@property (nonatomic,weak)id<CustomTableViewDelegate>customViewDelegate;

@end
