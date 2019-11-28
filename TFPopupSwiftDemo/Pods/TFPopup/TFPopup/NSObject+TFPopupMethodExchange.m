//
//  NSObject+TFPopupMethodExchange.m
//  TFPopupDemo
//
//  Created by zhutaofeng on 2019/8/15.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "NSObject+TFPopupMethodExchange.h"

@implementation NSObject (TFPopupMethodExchange)

/**
 *  交换类方法和交换实例方法
 */
+(BOOL)popup_instanceMethodExchange:(SEL)originSel toClass:(Class)toClass  toSel:(SEL)toSel{
    Method originMethod = class_getInstanceMethod([self class], originSel);
    Method toMethod = class_getInstanceMethod(toClass, toSel);
    BOOL added = class_addMethod([self class], originSel, method_getImplementation(toMethod), method_getTypeEncoding(toMethod));
    if (!added) {
        method_exchangeImplementations(originMethod, toMethod);
    }else{
        class_replaceMethod(self, toSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    return YES;
}

+(BOOL)popup_classMethodExchange:(SEL)originSel toClass:(Class)toClass  toSel:(SEL)toSel{
    Method originMethod = class_getClassMethod([self class], originSel);
    Method toMethod = class_getClassMethod(toClass, toSel);
    Class metaClass = objc_getMetaClass(NSStringFromClass([self class]).UTF8String);
    IMP toImp = method_getImplementation(toMethod);
    const char *toTypeEncoding = method_getTypeEncoding(toMethod);
    BOOL addMethod = class_addMethod(metaClass,originSel,toImp,toTypeEncoding);
    if (!addMethod) {
        method_exchangeImplementations(originMethod, toMethod);
    }else{
        IMP originImp = method_getImplementation(originMethod);
        const char *originTypeEncoding = method_getTypeEncoding(originMethod);
        class_replaceMethod([self class],toSel,originImp,originTypeEncoding);
    }
    return YES;
}

@end
