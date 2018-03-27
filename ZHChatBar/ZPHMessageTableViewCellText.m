//
//  ZPHMessageTableViewCellText.m
//  ZHChatBar
//
//  Created by zph on 27/03/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import "ZPHMessageTableViewCellText.h"
@interface ZPHMessageTableViewCellText ()
/**
 内容文本
 */
@property (nonatomic,strong)UILabel *textContentLabel;
@end
@implementation ZPHMessageTableViewCellText

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _textContentLabel = [[UILabel alloc]init];
        _textContentLabel.numberOfLines = 0;//换行
        _textContentLabel.textAlignment = NSTextAlignmentLeft;
        _textContentLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_textContentLabel];
    }
    
    return self;
}

-(void)setLayout:(ZPHMessageTableViewCellLayout *)layout {
    
    [super setLayout:layout];
    
    _textContentLabel.frame = layout.contentFrame;
    _textContentLabel.attributedText = layout.layoutAttributedString;
    self.messageBackView.frame = layout.messageBackViewFrame;
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
