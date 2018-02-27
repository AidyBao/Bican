//
//  WalletCollectionViewCell.h
//  Bican
//
//  Created by bican on 2018/1/4.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *flowerImage;
@property (nonatomic, strong) UILabel *flowerNameLabel;
@property (nonatomic, strong) UILabel *numberLabel;

- (void)createWallectCellWithCollectionPicture:(NSString *)picture
                                           Own:(NSString *)own
                                          Unit:(NSString *)unit
                                          Name:(NSString *)name
                                      Currency:(NSString *)currency
                                      FlowerId:(NSString *)flowerId;

@end
