//
//  Array+Safe.m
//  DMProject
//
//  Created by panda誌 on 2017/7/11.
//  Copyright © 2017年 杭州稻本信息技术有限公司. All rights reserved.
//

#import "Array+Safe.h"
#import <objc/runtime.h>
@implementation NSArray (Safe)
//这个方法无论如何都会执行
/*
 **1. 直接调用 [NSArray alloc] ，会发现返回了一个 __NSPlaceholderArray 对象
 **2. [NSArray array], 会发现返回了一个 __NSArray0 对象
 **3. [NSArray arrayWithObject:@""], 会发现返回了一个 __NSSingleObjectArrayI 对象
 **4. [NSArray arrayWithObjects:@"", nil], 会发现返回了一个 __NSArrayI 对象
 */

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 取值
        Method original_get_1 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
        Method replace_get_1 = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(ly_swizzing_objectAtIndexI:));
        method_exchangeImplementations(original_get_1, replace_get_1);
        
        Method original_get_2 = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:));
        Method replace_get_2 = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(ly_swizzing_objectAtIndex0:));
        method_exchangeImplementations(original_get_2, replace_get_2);
        
        Method original_get_3 = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:));
        Method replace_get_3 = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(ly_swizzing_objectAtIndexSingle:));
        method_exchangeImplementations(original_get_3, replace_get_3);
        
        Method original_get_4 = class_getInstanceMethod(objc_getClass("__NSPlaceholderArray"), @selector(objectAtIndex:));
        Method replace_get_4 = class_getInstanceMethod(objc_getClass("__NSPlaceholderArray"), @selector(ly_swizzing_objectAtIndexPlaceholder:));
        method_exchangeImplementations(original_get_4, replace_get_4);
        
        //赋值
        Method original_init_1 = class_getInstanceMethod(objc_getClass("__NSPlaceholderArray"), @selector(initWithObjects:count:));
        Method replace_init_1 = class_getInstanceMethod(objc_getClass("__NSPlaceholderArray"), @selector(ly_swizzing_initWithObjects:count:));
        method_exchangeImplementations(original_init_1, replace_init_1);
    });
}

#pragma mark objectAtIndex:
//__NSArrayI
- (id)ly_swizzing_objectAtIndexI:(NSUInteger)index {
    
    if (![self judgeArrayIndex:index]) {
        return nil;
    }
    return [self ly_swizzing_objectAtIndexI:index];
}
//__NSArray0
- (id)ly_swizzing_objectAtIndex0:(NSUInteger)index {
    
    if (![self judgeArrayIndex:index]) {
        return nil;
    }
    return [self ly_swizzing_objectAtIndex0:index];
}
//__NSSingleObjectArrayI
- (id)ly_swizzing_objectAtIndexSingle:(NSUInteger)index {
    
    if (![self judgeArrayIndex:index]) {
        return nil;
    }
    return [self ly_swizzing_objectAtIndexSingle:index];
}
//__NSPlaceholderArray
- (id)ly_swizzing_objectAtIndexPlaceholder:(NSUInteger)index {
    NSLog(@"%s\n%s\n%@",class_getName(self.class),__func__,@"数组未初始化");
    return nil;
}
-(BOOL)judgeArrayIndex:(NSUInteger)index{
    
    if (!self.count || self.count == 0) {
        NSLog(@"%s\n%s\n%@",class_getName(self.class),__func__,@"数组为空");
        return NO;
    }
    else if (self.count-1 < index){
        NSLog(@"%s\n%s\n%@",class_getName(self.class),__func__,@"数组越界了");
        return NO;
    }
    return YES;
}

#pragma mark initWithObjects:count:
- (id)ly_swizzing_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt{
    for (int i = 0 ; i<cnt ; i++) {
        if (objects[i] == nil) {
            NSLog(@"数组第%d个参数为空",i);
            return nil;
        }
    }
    return [self ly_swizzing_initWithObjects:objects count:cnt];
}

@end


@implementation NSMutableArray (Safe)
//这个方法无论如何都会执行
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrCls = NSClassFromString(@"__NSArrayM");
        //查
        Method original = class_getInstanceMethod(arrCls, @selector(objectAtIndex:));
        Method replace = class_getInstanceMethod(arrCls, @selector(ly_swizzing_objectAtIndexM:));
        method_exchangeImplementations(original, replace);
        //增
        Method original1 = class_getInstanceMethod(arrCls, @selector(insertObject:atIndex:));
        Method replace1 = class_getInstanceMethod(arrCls, @selector(ly_swizzing_insertObjectM:atIndex:));
        method_exchangeImplementations(original1, replace1);
        //增
        Method original2 = class_getInstanceMethod(arrCls, @selector(setObject:atIndex:));
        Method replace2 = class_getInstanceMethod(arrCls, @selector(ly_swizzing_setObjectM:atIndex:));
        method_exchangeImplementations(original2, replace2);
        //增
        Method original3 = class_getInstanceMethod(arrCls, @selector(setObject:atIndexedSubscript:));
        Method replace3 = class_getInstanceMethod(arrCls, @selector(ly_swizzing_setObjectM:atIndexedSubscript:));
        method_exchangeImplementations(original3, replace3);
        //删
        Method original4 = class_getInstanceMethod(arrCls, @selector(removeObjectsInRange:));
        Method replace4 = class_getInstanceMethod(arrCls, @selector(ly_swizzing_removeObjectsInRange:));
        method_exchangeImplementations(original4, replace4);
        //改
        Method original5 = class_getInstanceMethod(arrCls, @selector(replaceObjectAtIndex:withObject:));
        Method replace5 = class_getInstanceMethod(arrCls, @selector(ly_swizzing_replaceObjectAtIndex:withObject:));
        method_exchangeImplementations(original5, replace5);
        
    });
}

//查
- (id)ly_swizzing_objectAtIndexM:(NSUInteger)index {
    if (!self.count || self.count == 0) {
        NSLog(@"%s\n%@",__func__,@"---------数组为空-------");
        return nil;
    }
    else if (self.count-1 < index){
        NSLog(@"%s\n%@",__func__,@"--------数组越界了-------");
        return nil;
    }
    return [self ly_swizzing_objectAtIndexM:index];
}
//增
-(void)ly_swizzing_insertObjectM:(id)anObject atIndex:(NSUInteger)index{
    
    if (index == 0) {
        if (!anObject) {
            NSLog(@"不能为空");
            return;
        }
    }
    else{
        //因为是插入操作 所以在数组最后也可以插入
        if (index> self.count) {
            NSLog(@"%s\n%@",__func__,@"数组越界了");
            return;
        }
        if (!anObject) {
            NSLog(@"不能为空");
            return;
        }
    }
    [self ly_swizzing_insertObjectM:anObject atIndex:index];
}
//增
-(void)ly_swizzing_setObjectM:(id)anObject atIndex:(NSUInteger)index{
    
    if (!anObject) {
        NSLog(@"不能为空");
        return;
    }
    //可以在最末位增加
    if (index>self.count) {
        NSLog(@"%s\n%@",__func__,@"数组越界了");
        return;
    }
    [self ly_swizzing_setObjectM:anObject atIndex:index];
}
//增
-(void)ly_swizzing_setObjectM:(id)anObject atIndexedSubscript:(NSUInteger)index{
    if (!anObject) {
        NSLog(@"不能为空");
        return;
    }
    //可以在最末位增加
    if (index>self.count) {
        NSLog(@"%s\n%@",__func__,@"数组越界了");
        return;
    }
    [self ly_swizzing_setObjectM:anObject atIndexedSubscript:index];
}
//删
-(void)ly_swizzing_removeObjectsInRange:(NSRange)range{
    if (range.location>self.count) {
        NSLog(@"%s\n%@",__func__,@"数组越界了");
        return;
    }
    
    if ((range.location + range.length)>self.count) {
        NSLog(@"%s\n%@",__func__,@"数组越界了");
        return;
    }
    [self ly_swizzing_removeObjectsInRange:range];
}
//改
- (void)ly_swizzing_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    if (!self.count || self.count==0) {
        NSLog(@"%s\n%@",__func__,@"数组为空");
        return;
    }
    if (index>=self.count) {
        NSLog(@"%s\n%@",__func__,@"数组越界了");
        return;
    }
    if (!anObject) {
        NSLog(@"不能为空");
        return;
    }
    [self ly_swizzing_replaceObjectAtIndex:index withObject:anObject];
}
@end
