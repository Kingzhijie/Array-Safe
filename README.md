# Array+Safe  
##### 利用runtime方法交换, demo提供方法解决 NSArray 和 NSMutableArray 处理错误 导致的越界
	下载Demo , 选择Array+Safe.h Array+Safe.m 文件导入项目, 即可自动使用, 无需在项目中引头文件
###### 1. NSArray 安全性
```oc
 无论哪种方法创建的数组, 均被安全替换, 请放心使用
 **1. 直接调用 [NSArray alloc] ，会发现返回了一个 __NSPlaceholderArray 对象
 **2. [NSArray array], 会发现返回了一个 __NSArray0 对象
 **3. [NSArray arrayWithObject:@""], 会发现返回了一个 __NSSingleObjectArrayI 对象
 **4. [NSArray arrayWithObjects:@"", nil], 会发现返回了一个 __NSArrayI 对象


        取值
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

``` 
###### 2. NSMutableArray 安全性
```oc
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

```