//
//  ZPHMessageTableViewCell.m
//  ZHChatBar
//
//  Created by zph on 27/03/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import "ZPHMessageTableViewCell.h"
#import "ZPHMessageTableViewCellText.h"
#import "ZPHMessageTableViewCellImage.h"
#import "ZPHMessageTableViewCellVoice.h"

@implementation ZPHMessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//点击效果
        self.userInteractionEnabled = NO;//交互
        self.backgroundColor = [UIColor clearColor];
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
        _timeLabel.font = [UIFont systemFontOfSize:8];
        _timeLabel.layer.cornerRadius = 3;
        _timeLabel.layer.masksToBounds = YES;
        [_timeLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_timeLabel];
        
        _headImageView = [[UIImageView alloc]init];         //头像
        [self.contentView addSubview:_headImageView];
        
        _messageBackView = [[UIImageView alloc]init];       //背景图片
        [self.contentView addSubview:_messageBackView];
    }
    return self;
}

//赋值
-(void)setLayout:(ZPHMessageTableViewCellLayout *)layout {
    
    _layout = layout;

    //时间
    _timeLabel.attributedText = layout.timeAttributedString;
    _timeLabel.frame = layout.timeFrame;
    _timeLabel.hidden = NO;

    
    //头像
    _headImageView.frame = layout.headPictureFrame;
    
    if (layout.model.isSelf) {
        
        if (layout.headImage == nil) {
            _headImageView.image = [UIImage imageNamed:@"message_headImage"];
        }else {
            _headImageView.image = layout.headImage;
        }
    }else {

        _headImageView.image = [UIImage imageNamed:@"message_kefu"];

    }
    _rowHeight = layout.rowHeight;
    
    //背景
    if (layout.model.isSelf) {
        _messageBackView.image = [[UIImage imageNamed:@"selfcontactBg"]stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    }else {
        _messageBackView.image = [[UIImage imageNamed:@"otherContactBg"]stretchableImageWithLeftCapWidth:50 topCapHeight:30];
    }
}

-(ZPHMessageType)messageType {
    
    if ([self isKindOfClass:[ZPHMessageTableViewCellText class]]) {
        return ZPHMessageTypeText;
    }else if ([self isKindOfClass:[ZPHMessageTableViewCellImage class]]) {
        return ZPHMessageTypeImage;     //图片
    }else if ([self isKindOfClass:[ZPHMessageTableViewCellVoice class]]) {
        return ZPHMessageTypeVoice;     //语音
    }
    return ZPHMessageTypeUnknow;        //未知
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
