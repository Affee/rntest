//
//  AddAdvertisementViewController.m
//  WeiDianKe
//
//  Created by lqz on 2017/7/1.
//  Copyright © 2017年 zichenfang. All rights reserved.
//
#import "ImageCollectionViewCell.h"
#import "EmojiTextAttachment.h"
#import "TTRequestManager.h"
#import "AddAdvertisementViewController.h"
#import "NSAttributedString+EmojiExtension.h"
@interface AddAdvertisementViewController () <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UIView *imgSuperView;
@property (strong, nonatomic) IBOutlet UIButton *tupianBtn;
@property (weak, nonatomic) IBOutlet UITextField *titlePlaceText;
@property (weak, nonatomic) IBOutlet UITextField *contentPlaceText;
@property (weak, nonatomic) IBOutlet UITextView *titleText;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (assign,nonatomic)NSInteger charu;
@property (strong,nonatomic)NSString *shangchuanStr;
@property (strong,nonatomic)NSMutableArray *emoTextArray;
@property(strong,nonatomic)NSMutableArray *emoImgArray;
@property (strong,nonatomic)NSMutableArray *imgUrlArray;
@property (strong,nonatomic)NSString *imgUrl;
@property(assign,nonatomic) NSInteger imgNum;
@property(strong,nonatomic) NSMutableArray *imgArray;
@property(strong,nonatomic) UIView *shanChuView;
@end

@implementation AddAdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgArray = [NSMutableArray array];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 5; // 水平方向的间距
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.contentText.frame.origin.y + self.contentText.bounds.size.height, self.view.bounds.size.width, 120) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
     self.collectionView.alwaysBounceHorizontal = YES;

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];

    
    self.imgNum = 0;
    self.imgUrl = @"";
    self.navigationItem.title = @"编辑资料";
    self.titleText.delegate = self;
    self.contentText.delegate = self;
    self.titlePlaceText.enabled = NO;
    self.contentPlaceText.enabled = NO;
    CALayer *titleBorder = [CALayer layer];
    float titleBorderY = self.titleText.bounds.size.height - 1;
    float titleBorderW = self.titleText.bounds.size.width;
    titleBorder.frame = CGRectMake(0, titleBorderY, titleBorderW, 1);
    titleBorder.backgroundColor = [UIColor colorWithRed:216 / 255.8f green:215 / 255.8f blue:216 / 255.8f alpha:1] .CGColor;
//    [self.titleText.layer addSublayer:titleBorder];
    
    CALayer *contentBorder = [CALayer layer];
    float contentY = self.contentText.bounds.size.height - 1;
    float contentW = self.contentText.bounds.size.width;
    contentBorder.frame = CGRectMake(0, contentY, contentW, 1);
    contentBorder.backgroundColor = [UIColor colorWithRed:216 / 255.8f green:215 / 255.8f blue:216 / 255.8f alpha:1] .CGColor;
//    [self.contentText.layer addSublayer:contentBorder];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.firstLineHeadIndent = 10.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:18], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor blackColor]
                                  };
    self.titleText.attributedText = [[NSAttributedString alloc]initWithString:@" " attributes:attributes];
    
    self.contentText.attributedText = [[NSAttributedString alloc]initWithString:@" " attributes:attributes];
//    self.tupianBtn.hidden = YES;
    if (self.dataDic != nil) {
        self.titleText.text = self.dataDic[@"title"];
        self.titlePlaceText.placeholder = @"";
        self.contentPlaceText.placeholder = @"";
        [self xianshitupian];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)xianshitupian{
//    self.contentText.text = self.dataDic[@"content"];
    NSArray *array = [self.dataDic[@"content"] componentsSeparatedByString:@"<p>"];
    self.contentText.text = array[0];
    NSArray *str = [self filterImage:self.dataDic[@"content"]];
    for (NSString *urlStr in str) {
//        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        [self.imgArray addObject:urlStr];
    }
}

- (NSArray *)filterImage:(NSString *)html{
    NSMutableArray *resultArray = [NSMutableArray array];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src = \""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src = \""]; }
        else if ([imgHtml rangeOfString:@"src = "].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src = "];
        }
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1]; NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
        }
    }
}
    return resultArray;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@" "]) {
        textView.text = @"";
    }
    
    if (textView.tag == 11) {
        self.titlePlaceText.placeholder = @"";
    }else if(textView.tag == 12){
        self.contentPlaceText.placeholder = @"";
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        if (textView.tag == 11) {
            self.titlePlaceText.placeholder = @"填写标题";
        }else if(textView.tag == 12){
            self.contentPlaceText.placeholder = @"填写描述";
        }
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArray.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, cell.bounds.size.width, cell.bounds.size.height)];
    imgView.backgroundColor = [UIColor grayColor];
    if (indexPath.row == 0) {
        imgView.image = [UIImage imageNamed:@"+"];
    }else{
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgArray[indexPath.row - 1]]];
    }
    [cell addSubview:imgView];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(78, 82);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self addImageBtn:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除照片" message:@"确认删除吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.imgArray removeObjectAtIndex:indexPath.row - 1];
            [self.collectionView reloadData];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - 添加图片
- (IBAction)addImageBtn:(UIButton *)sender {
//    NSRange range = self.contentText.selectedRange;
//    NSLog(@"%ld, %ld",range.length,range.location);
    [self showImgPicker];
}

-(void)showImgPicker{
    UIImagePickerController* vc = [[UIImagePickerController alloc]init];
    vc.navigationBar.tintColor = [UIColor redColor];
    vc.navigationBar.barTintColor = [UIColor redColor];
    
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* img = info[UIImagePickerControllerOriginalImage];
    
    NSData *imgData = UIImageJPEGRepresentation(img, 1);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"key"] = @"picture";
    params[@"codeType"] = @"5004";
    [ProgressHUD show:@"正在加载"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    [manager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/uploadImage" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     
        
        // 获取图片数据
        
        // 设置上传图片的名字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:imgData name:@"image" fileName:fileName mimeType:@"image/png"];
        self.contentPlaceText.text = @"";

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 返回结果
        
        [self dismissViewControllerAnimated:YES completion:nil];
        self.imgUrl = [NSString stringWithFormat:@"%@<p><img src = \"%@\" alt=\"\" indth=\"250\" height = \"250\" title=\"\" align=\"\" />",self.imgUrl,responseObject[@"result"][@"picture"]];
        [self.imgArray addObject:responseObject[@"result"][@"picture"]];
        [self.collectionView reloadData];
        
        if (self.imgArray.count > 1) {
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0,  78 * 3);
        }

        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [ProgressHUD showError:@"加载失败"];
    }];

}

- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, self.contentText.textStorage.length);
    
    [self.contentText.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    
    [self.contentText.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22.0f] range:wholeRange];
}

- (NSString *)str:(NSString *)string replaceStr:(NSString *)replaceStr{
    NSString *newString = string;

    if ([string rangeOfString:@"<p><img src = \""].location != NSNotFound||[string rangeOfString:@"\" alt=\"\" indth=\"250\" height = \"250\" title=\"\" align=\"\" />"].location != NSNotFound) {
        NSArray * arr = [string componentsSeparatedByString:@"<p><img src = \""]; string = arr[1];
            NSArray * arr1 = [string componentsSeparatedByString:@"\" alt=\"\" indth=\"250\" height = \"250\" title=\"\" align=\"\" />"]; string = arr1[0];
        string = [NSString stringWithFormat:@"{%@}",string];
    }
    newString = [newString stringByReplacingOccurrencesOfString:string withString:replaceStr];
    return newString;
}


- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}
#pragma mark - 确认发布
- (IBAction)issueBtn:(UIButton *)sender {
    
    if ([self.titleText.text isEqualToString:@""] || [self.titleText.text isEqualToString:@" "]) {
         [ProgressHUD showError:@"请填写标题"];
    }else if([self.contentText.text isEqualToString:@""] || [self.contentText.text isEqualToString:@" "]){
        [ProgressHUD showError:@"请填写描述"];
    }else{
//         [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject)
        if (self.dataDic != nil) {
            self.imgUrl = @"";
            for (NSString *imgStr in self.imgArray) {
                self.imgUrl = [NSString stringWithFormat:@"%@<p><img src = \"%@\" alt=\"\" indth=\"250\" height = \"250\" title=\"\" align=\"\" />",self.imgUrl,imgStr];
            }
            
            [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/postAdver" Parameters:@{@"userId":[TTUserInfoManager userId],@"title":self.titleText.text,@"content":[NSString stringWithFormat:@"%@%@",self.contentText.text,self.imgUrl],@"id":self.dataDic[@"id"],@"money":self.dataDic[@"money"],@"day":self.dataDic[@"day"]} Success:^(NSDictionary *responseJsonObject) {
                if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                    [ProgressHUD showSuccess:@"上传成功!!!"];
//                    [self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [ProgressHUD showError:responseJsonObject[@"msg"]];

                }
            } Failure:^(NSError *error) {
                [ProgressHUD showError:@"网络错误"];
            }];
        }else{
            [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/postAdver" Parameters:@{@"userId":[TTUserInfoManager userId],@"title":self.titleText.text,@"content":[NSString stringWithFormat:@"%@%@",self.contentText.text,self.imgUrl],@"money":self.money,@"day":self.day,@"id":self.guangGaoId} Success:^(NSDictionary *responseJsonObject) {
                if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                    [ProgressHUD showSuccess:@"上传成功!!!"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [ProgressHUD showError:responseJsonObject[@"msg"]];
                }
            } Failure:^(NSError *error) {
                [ProgressHUD showError:@"网络错误"];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
