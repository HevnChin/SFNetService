//
//  NSString+CustumExtends.m
//  UpLive
//
//  Created by Sage on 2016/10/26.
//  Copyright © 2016年 AsiaInnovations. All rights reserved.
//

#import "NSString+CustumExtends.h"
#import  <stdio.h>
#include <sys/xattr.h>
#import <objc/runtime.h>

@implementation NSString (NSStringCustumExtends)
/*标示的对象*/
static void* isJsonContent;
-(void)setIsJson:(BOOL)isJson{
    objc_setAssociatedObject(self, &isJsonContent, isJson?@1:@0, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isJson{
    return [objc_getAssociatedObject(self, &isJsonContent) boolValue];
}

+ (NSString*)JSONValueFromObj:(id)obj{
    if(nil == obj){
        return @"";
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&parseError];
    if(nil == jsonData){
        return @"";
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString.isJson = YES;
    return jsonString;
}
-(id)JSONValue{
    return [self JSONValue:nil];
}
-(id)JSONValue:(NSError **)error{
    NSData * d = [self dataUsingEncoding:NSUTF8StringEncoding];
    id dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableLeaves error:error];
    return dict;
}

- (NSRange)rangeFromSuffixOfString:(NSString *)aString{
    NSRange aRange = [self rangeOfString:aString options:NSBackwardsSearch];
    return aRange;
}


+ (NSString *)stringWithArray:(NSArray*)aArray{
    return [self stringWithArray:aArray divisionString:@""];
}
+ (NSString *)stringWithArray:(NSArray*)array divisionString:(NSString*)divisionString{
    NSMutableString * aString = [NSMutableString string];
    for(NSString * aValue in array){
        NSString *appendStr = aValue;
        if(nil == appendStr){
            appendStr = [NSString string];//cur_amap_id
        }
        else if( ![appendStr isKindOfClass:[NSString class]]){
            appendStr = [NSString stringWithFormat:@"%@",appendStr];
        }
        aString = [[aString appendStrings:[NSString stringWithFormat:@"%@",appendStr]] appendStrings:divisionString];
    }
    aString = [aString trimEdgeString:divisionString];//去除侧边的字符串
    return aString;
}
@end

@implementation NSMutableString (NSMutableStringCustomExtend)
-(NSMutableString*)appendStrings:(NSString*)aString{
    NSMutableString *mString = [NSMutableString stringWithString:self];
    
    [mString appendString:aString];
    return mString;
}
//去除两边侧的Sting
- (NSMutableString *)trimEdgeString:(NSString*)aString{
    NSMutableString *mString = [NSMutableString stringWithString:self];
    if(aString.length<=0){
        return mString;
    }
    BOOL isBeginRange = [mString hasPrefix:aString];
    if(isBeginRange){
        [mString deleteCharactersInRange:NSMakeRange(0, aString.length)];
    }
    BOOL isEndRange = [mString hasSuffix:aString];
    if(isEndRange){
        NSRange endRange = [mString rangeFromSuffixOfString:aString];
        [mString  deleteCharactersInRange:NSMakeRange(endRange.location, endRange.length)];
    }
    return mString;
}
@end
