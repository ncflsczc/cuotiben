//
//  BijiTableViewCell.m
//  cuotiben
//
//  Created by 陈志超 on 2022/2/25.
//

#import "BijiTableViewCell.h"

#define Width [UIScreen mainScreen].bounds.size.width
@implementation BijiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    _kemulab.layer.masksToBounds = YES;
    _kemulab.layer.cornerRadius = 12.5;
//    _timuimg.layer.maskedCorners = YES;
    _timuimg.layer.cornerRadius = 5;
    _timuimg.frame = CGRectMake(10, 5, Width-20, 200);
    _kemulab.frame =_dengjiimg.frame = CGRectMake(Width-75, 10, 25, 25);
    _dengjiimg.frame = CGRectMake(Width-40, 10, 25, 25);
    _shuominglab.frame =CGRectMake(10, 210, Width-20, 40);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
