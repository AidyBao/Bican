//
//  ZLCollectionCell.h
//  多选相册照片
//
//  Created by long on 15/11/25.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLCollectionCell;
@protocol ZLCollectionCellDelegate <NSObject>
    
- (void)selectedCell:(ZLCollectionCell *)cell Button:(UIButton *)sender;
    
@end

@interface ZLCollectionCell : UICollectionViewCell

@property (nonatomic, assign) id <ZLCollectionCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btnSelect;

@end
