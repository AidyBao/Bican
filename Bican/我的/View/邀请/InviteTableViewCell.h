//
//  InviteTableViewCell.h
//  Bican
//
//  Created by chichen on 2018/1/10.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteTableViewCell : UITableViewCell

- (void)createInviteViewControllerWithNickname:(NSString *)nickname
                                    SchoolName:(NSString *)schoolName
                                         Title:(NSString *)title
                                     Frequency:(NSString *)frequency
                                        Status:(NSString *)status
                                        Flower:(NSString *)flower;

@end
