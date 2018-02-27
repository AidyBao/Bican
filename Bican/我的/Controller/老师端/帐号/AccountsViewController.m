//
//  AccountsViewController.m
//  Bican
//
//  Created by bican on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "AccountsViewController.h"
#import "AccountsTableViewCell.h"
#import "MineTableViewCell.h"
#import "PseudonymViewController.h"
#import "BindPhoneViewController.h"
#import "DetailsViewController.h"
#import "ChangePasswordViewController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLShowBigImage.h"
#import "ZLDefine.h"
#import "ZLCollectionCell.h"

#import "ZTBottomSelecteView.h"

@interface AccountsViewController ()<UITableViewDataSource, UITableViewDelegate , ZTBottomSelecteViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *accountsTableView;
@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;
@property (nonatomic, strong) NSArray *arrDataSources;

@property (nonatomic, strong) NSArray *genderArray;
@property (nonatomic, strong) ZTBottomSelecteView *bottomSelecteView;
@property (nonatomic, assign) NSInteger selectedTitleIndex;//记录选中的下标

@property (nonatomic, strong) NSArray *photoArray;

@end

@implementation AccountsViewController

- (NSArray *)arrDataSources
{
    if (!_arrDataSources) {
        _arrDataSources = [NSArray array];
    }
    return _arrDataSources;
}

- (NSArray *)genderArray
{
    if (!_genderArray) {
        _genderArray = [NSArray arrayWithObjects:@"女", @"男", nil];
    }
    return _genderArray;
}

- (NSArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSArray arrayWithObjects:@"从手机相册选择", @"拍照", nil];
    }
    return _photoArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserBasiceInfo];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帐号";
    
    [self createTableView];
    [self createBottomSelecteView];
    
}

#pragma mark - 查询用户的基本信息
- (void)getUserBasiceInfo
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    NSString *url = [NSString stringWithFormat:@"%@api/user/get", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        UserInformation *model = [[UserInformation alloc] init];
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        [model setValuesForKeysWithDictionary:dic];
        //重新存用户的model
        [GetUserInfo updateUserinfoModelWithNewModel:model];
        //刷新页面
        [self.accountsTableView reloadData];
        
    } errorHandler:^(NSError *error) {
        
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

- (void)createTableView
{
    self.accountsTableView = [[UITableView alloc] init];
    self.accountsTableView.dataSource = self;
    self.accountsTableView.delegate = self;
    
    self.accountsTableView.backgroundColor = [UIColor whiteColor];
    self.accountsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] init];
    self.accountsTableView.tableFooterView = view;
    self.accountsTableView.rowHeight = GTH(125);
    
    [self setScrollIndicatorInsetsForTabelView:self.accountsTableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.accountsTableView];
    
    [self.accountsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
    }];
}


#pragma makr - 创建弹出的view
- (void)createBottomSelecteView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bottomSelecteView = [[ZTBottomSelecteView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.bottomSelecteView.delegate = self;
    self.bottomSelecteView.hidden = YES;
    
    [window addSubview:self.bottomSelecteView];
}

- (void)cancelButtonClick
{
    
}

#pragma makr - ZTBottomSelecteViewDelegate
- (void)selecetedIndex:(NSInteger)selecetedIndex
{
    if (self.selectedTitleIndex == 0) {
        //头像
        if (selecetedIndex == 1) {
            //拍照
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = NO;
                picker.videoQuality = UIImagePickerControllerQualityTypeLow;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
                
            } else {
                [ZTToastUtils showToastIsAtTop:NO Message:@"相机功能暂不能使用" Time:3.0];
                return;
            }
            
        }
        if (selecetedIndex == 0) {
            //从手机相册选择
            ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
            actionSheet.maxSelectCount = 1;
            weakify(self);
            
            [actionSheet showPhotoLibraryWithSender:self lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                
                strongify(weakSelf);
                strongSelf.arrDataSources = selectPhotos;
//                strongSelf.lastSelectMoldels = selectPhotoModels;
                //上传头像图片
                [strongSelf fileUpload];
                
            }];
        }
        
    }
    if (self.selectedTitleIndex == 2) {
        //性别
        [self completeBaseInfoWithSex:self.genderArray[selecetedIndex]];
    }
    self.bottomSelecteView.hidden = YES;
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        strongify(weakSelf);
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        strongSelf.arrDataSources = @[image];
        [strongSelf fileUpload];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 头像图片上传
- (void)fileUpload
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    //命题图片, ","分割
    NSMutableArray *picPathArray = [NSMutableArray array];
    for (UIImage *image in self.arrDataSources) {
        //压缩图片
        NSData *pictureData = UIImageJPEGRepresentation(image, 0.5);
//        UIImage *scaledImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(image.size.width * 0.5, image.size.height * 0.5)];
//        NSData *pictureData = UIImagePNGRepresentation(scaledImage);
        NSString *result = [pictureData base64EncodedStringWithOptions:0];
        [picPathArray addObject:result];
    }
    NSString *filePath = [picPathArray componentsJoinedByString:@","];
    [params setValue:filePath forKey:@"fileList"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/file/uploadIOS", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"图片提交成功" Time:3.0];
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        NSString *url = [dic objectForKey:@"url"];
        //修改用户信息
        [self modifyUserInfoWithHeadPic:url];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];
        
    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
    
}

#pragma mark - 完善个人资料信息
- (void)completeBaseInfoWithSex:(NSString *)sex
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    if (sex.length != 0) {
        [params setValue:sex forKey:@"sex"];
    }
    UserInformation *user = [GetUserInfo getUserInfoModel];
    [params setValue:user.roleType forKey:@"roleType"];
    [params setValue:user.firstName forKey:@"firstName"];
    [params setValue:user.lastName forKey:@"lastName"];
    [params setValue:user.nickname forKey:@"nickName"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/completeBaseInfo", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            return;
        }
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        UserInformation *user = [[UserInformation alloc] init];
        [user setValuesForKeysWithDictionary:dic];
        //更新用户信息
        [GetUserInfo updateUserinfoModelWithNewModel:user];
        
        [self reloadTableView:self.accountsTableView Row:2 Section:0];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 修改用户基本信息
- (void)modifyUserInfoWithHeadPic:(NSString *)headPic
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:headPic forKey:@"headPic"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/user/modify", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            return;
        }
        //重新获取用户基本信息
        [self getUserBasiceInfo];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AccountsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        if (!cell) {
            cell = [[AccountsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
        }
        UserInformation *user = [GetUserInfo getUserInfoModel];
        [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"my_header"]];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCell"];
        if (!cell) {
            cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descCell"];
        }
        
        UserInformation *user = [GetUserInfo getUserInfoModel];
        
        if (indexPath.row == 1) {
            NSString *nickName = [NSString string];
            if ([GetUserInfo getUserInfoModel].nickname.length != 0) {
                nickName = [GetUserInfo getUserInfoModel].nickname;
            }
            [cell setMineTableViewCellWithLeftText:@"笔名" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:nickName RightFont:FONT(30) RightColor:ZTTextLightGrayColor IsShowButton:YES];
        }
        if (indexPath.row == 2) {
            [cell setMineTableViewCellWithLeftText:@"性别" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:user.sex RightFont:FONT(30) RightColor:ZTTextLightGrayColor IsShowButton:YES];
        }
        if (indexPath.row == 3) {
            //手机号密文显示
            NSString *mobile = [self formatPhoneNumber:user.mobile];
            [cell setMineTableViewCellWithLeftText:@"绑定手机号" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:mobile RightFont:FONT(30) RightColor:ZTTextLightGrayColor IsShowButton:YES];
        }
        if (indexPath.row == 4) {
            [cell setMineTableViewCellWithLeftText:@"个人信息" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:[NSString stringWithFormat:@"%@%@", user.firstName, user.lastName] RightFont:FONT(30) RightColor:ZTTextLightGrayColor IsShowButton:YES];
        }
        
        if (indexPath.row == 5) {
            [cell setMineTableViewCellWithLeftText:@"修改密码" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTextLightGrayColor IsShowButton:YES];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.bottomSelecteView setZTBottomSelecteViewWithArray:self.photoArray CancelButtonTitle:@"取消" TextColor:ZTTextGrayColor TextFont:FONT(30) IsShowOrangeColor:NO OrangeColorIndex:0];

        self.bottomSelecteView.hidden = NO;
    }
    if (indexPath.row == 1) {
        PseudonymViewController *pseudonymVC = [[PseudonymViewController alloc] init];
        [self pushVC:pseudonymVC animated:YES IsNeedLogin:YES];
    }
    if (indexPath.row == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.bottomSelecteView setZTBottomSelecteViewWithArray:self.genderArray CancelButtonTitle:@"取消" TextColor:ZTTextGrayColor TextFont:FONT(30) IsShowOrangeColor:NO OrangeColorIndex:0];

        self.bottomSelecteView.hidden = NO;

    }
    if (indexPath.row == 3) {
        BindPhoneViewController *bindPhoneVC = [[BindPhoneViewController alloc] init];
        [self pushVC:bindPhoneVC animated:YES IsNeedLogin:YES];
    }
    if (indexPath.row == 4) {
        DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
        [self pushVC:detailsVC animated:YES IsNeedLogin:YES];
    }
    if (indexPath.row == 5) {
        ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
        [self pushVC:changePasswordVC animated:YES IsNeedLogin:YES];
    }
    //记录选中的行数
    self.selectedTitleIndex = indexPath.row;
}


@end

