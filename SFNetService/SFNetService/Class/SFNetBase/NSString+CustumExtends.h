//
//  NSString+CustumExtends.h
//  UpLive
//
//  Created by Sage on 2016/10/26.
//  Copyright © 2016年 AsiaInnovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringCustumExtends)
///是否是一个json数据
@property (nonatomic,assign) BOOL isJson;

+ (NSString*)JSONValueFromObj:(id)obj;


-(id)JSONValue;
-(id)JSONValue:(NSError **)error;

+ (NSString *)stringWithArray:(NSArray*)aArray;
@end

@interface NSMutableString(NSMutableStringCustomExtend)
-(NSMutableString*)appendStrings:(NSString*)aString;
- (NSMutableString *)trimEdgeString:(NSString*)aString;
@end
