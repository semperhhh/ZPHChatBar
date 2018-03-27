//
//  ZPHMessageTableViewCellLayout.m
//  ZHChatBar
//
//  Created by zph on 27/03/2018.
//  Copyright © 2018 zph. All rights reserved.
//

#import "ZPHMessageTableViewCellLayout.h"
#import "ZPHMessageTableViewCellLayoutText.h"
#import "ZPHMessageTableViewCellLayoutImage.h"
#import "ZPHMessageTableViewCellLayoutVoice.h"

@implementation ZPHMessageTableViewCellLayout

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if (self = [super init]) {
        
        switch ([dictionary[@"category"]integerValue]) {
            case 0: self = [[ZPHMessageTableViewCellLayoutText alloc]initWithDictionary:dictionary];
                break;
            case 1: self = [[ZPHMessageTableViewCellLayoutImage alloc]initWithDictionary:dictionary];
                break;
            case 2: self = [[ZPHMessageTableViewCellLayoutVoice alloc]initWithDictionary:dictionary];
                break;
            default://未知类型暂时为文字
                self = [[ZPHMessageTableViewCellLayoutText alloc]initWithDictionary:dictionary];
                break;
        }
    }
    
    return self;
}

//左
-(void)setLeftLayoutWithModel:(ZPHMessage *)model {
    
    _model = model;
    
    CGFloat kviewWidth = [UIScreen mainScreen].bounds.size.width;

    NSString *timeString = [self messageTimeWithModelTime:[NSString stringWithFormat:@"%@",model.time]];
    NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc]init];
    [timeAttributedString appendAttributedString:[[NSAttributedString alloc]initWithString:timeString]];
    [timeAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, timeAttributedString.length)];
    CGSize timeSize = [self sizeWithAttributedString:timeAttributedString proSize:CGSizeMake(kviewWidth, MAXFLOAT)];
    _timeFrame = CGRectMake(kviewWidth/2 -timeSize.width/2, 15, timeSize.width, 20);
    _timeAttributedString = [[NSAttributedString alloc]initWithAttributedString:timeAttributedString];
    //头像
    _headPictureFrame = CGRectMake(5, CGRectGetMaxY(_timeFrame) +15, 40, 40);

    
    self.rowHeight = CGRectGetMaxY(_headPictureFrame) +5;//行高
}

//右
-(void)setRightLayoutWithModel:(ZPHMessage *)model {
    
    _model = model;
    
    CGFloat kviewWidth = [UIScreen mainScreen].bounds.size.width;
    
    //时间
        
    NSString *timeString = [self messageTimeWithModelTime:[NSString stringWithFormat:@"%@",model.time]];
    NSMutableAttributedString *timeAttributedString = [[NSMutableAttributedString alloc]init];
    [timeAttributedString appendAttributedString:[[NSAttributedString alloc]initWithString:timeString]];
    [timeAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, timeAttributedString.length)];
    CGSize timeSize = [self sizeWithAttributedString:timeAttributedString proSize:CGSizeMake(kviewWidth, MAXFLOAT)];
    _timeFrame = CGRectMake(kviewWidth/2 -timeSize.width/2, 15, timeSize.width, 20);
    _timeAttributedString = [[NSAttributedString alloc]initWithAttributedString:timeAttributedString];
    //头像
    _headPictureFrame = CGRectMake(kviewWidth - 40 -10, CGRectGetMaxY(_timeFrame) +15, 40, 40);
    self.rowHeight = CGRectGetMaxY(_headPictureFrame) +5;//行高
}

//计算文本高度
-(CGSize)sizeWithAttributedString:(NSMutableAttributedString *)attributedString proSize:(CGSize)proSize {
    
    CGRect rect = [attributedString boundingRectWithSize:proSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return CGSizeMake(rect.size.width, rect.size.height);
}

#pragma mark --时间
-(NSString *)messageTimeWithModelTime:(NSString *)timeString {
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    //将需要转换的时间转换成 NSDate 对象
    NSDate * needFormatDate = [dateFormatter dateFromString:timeString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@" dd日 HH:mm "];
    //获取当前时间
    NSDate *nowDate = [NSDate date];
    
    //将nsdate重新转换成字符串
    NSString *dateStr = nil;
    
    NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
    
    if (time<=60*60*24) {
        
        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
        NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
        NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        if ([need_yMd isEqualToString:now_yMd]) {
            //// 在同一天
            dateStr = [NSString stringWithFormat:@" 今天 %@ ",[dateFormatter stringFromDate:needFormatDate]];
        }else{
            ////  昨天
            dateStr = [NSString stringWithFormat:@" 昨天 %@ ",[dateFormatter stringFromDate:needFormatDate]];
        }
    }else {
        
        [dateFormatter setDateFormat:@"yyyy"];
        NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowYear = [dateFormatter stringFromDate:nowDate];
        
        if ([yearStr isEqualToString:nowYear]) {
            ////  在同一年
            [formatter setDateFormat:@" MM月dd日 HH:mm "];
            dateStr = [formatter stringFromDate:needFormatDate];
        }else{
            [formatter setDateFormat:@" yyyy/MM/dd HH:mm "];
            dateStr = [formatter stringFromDate:needFormatDate];
        }
    }
    
    return dateStr;
}
@end
