# TFPopup

[![License MIT](https://img.shields.io/badge/License-MIT-orange)]()&nbsp;
[![Platform iOS](https://img.shields.io/badge/platform-iOS-grayblue)]()&nbsp;
<br/>
<br/>

**🚀🚀🚀不耦合弹框代码,但可以为它添加弹出方式;
<br>🚀🚀🚀TFPopup不是弹框,它只是一种弹出方式;**

<br>使用TFPopup做弹框会让你的弹框变的异常简单。
<br>1.已经有一个view。
<br>2.用喜欢的方式将它弹出来。<br>


## 弹出效果图示例
**自定义动画效果**
___
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/cus-6.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/cus-2.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/cus-3.gif" width="30%" height="30%">
</div>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/cus-4.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/cus-5.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/cus-1.gif" width="30%" height="30%">
</div>
<br>

**默认动画效果**

___

<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/exa1.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/exa2.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/exa3.gif" width="30%" height="30%">
</div>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/exa4.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/exa5.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/exa6.gif" width="30%" height="30%">
</div>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/exa7.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/exa8.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/exa9.gif" width="30%" height="30%">
</div>
<br>

**基于默认动画效果的参数自由组合**

___

<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/nor-bubble.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/nor-mask.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/nor-slide.gif" width="30%" height="30%">
</div>

## 特点
- 和view代码不耦合<br>
&nbsp;&nbsp;&nbsp;&nbsp;你可以将一个新的/已存在的view调用弹出方法将他弹出来
- 默认支持多种弹出方式<br>
&nbsp;&nbsp;&nbsp;&nbsp;无动画覆盖/缩放弹出/滑动弹出/基于某点的泡泡方式弹出/基于frame变化的弹出/基于于遮罩的遮罩弹出/折叠弹出
- 在弹出方式基础上可以通过**调节参数**来调整**弹出效果**<br>
&nbsp;&nbsp;&nbsp;&nbsp;**拖动：**开启、关闭拖动/是否开启拖动弹性效果/设置拖动松手后自动消失距离<br>
&nbsp;&nbsp;&nbsp;&nbsp;**拖动方式：** 自由模式下弹框可全方向拖动,松手后触发消失/组合模式下可自由组合上下左右四个方向进行方向识别<br>
&nbsp;&nbsp;&nbsp;&nbsp;**时间调整：** 动画时间/动画延迟开始时间/动画延迟消失时间/弹框自动消失时间<br>
&nbsp;&nbsp;&nbsp;&nbsp;**时间曲线：** 通过UIViewAnimationOptions设置动画时间曲线<br>
&nbsp;&nbsp;&nbsp;&nbsp;**弹出背景：** 是否使用背景/调整背景颜色/背景色透明/背景点击事件及默认自动点击消失/背景显示、消失透明度动画<br>
&nbsp;&nbsp;&nbsp;&nbsp;**渐隐和位置：** 弹出渐隐/消失渐隐/弹出位置变化/消失位置变化<br>
&nbsp;&nbsp;&nbsp;&nbsp;**尺寸和位置：** 弹出区域计算尺寸设置/弹框尺寸/位置偏移量/初始位置/目标位置/是否始终保持原位置<br>
&nbsp;&nbsp;&nbsp;&nbsp;**属性动画：** 可分别设置显示、消失时的属性动画,只需要设置属性:属性值、初始值、结束值即可使用丰富的属性动画效果<br>
&nbsp;&nbsp;&nbsp;&nbsp;**泡泡：** 泡泡基准点/泡泡八个弹出方向<br>
&nbsp;&nbsp;&nbsp;&nbsp;**mask：** 可分别设置显示、消失时的mask,只需要设置属性:mask初始path、mask结束path即可<br>
- 保留弹出全过程接口，支持完全自定义弹出方式、动画、和背景<br>
&nbsp;&nbsp;&nbsp;&nbsp;TFPopupDataSource代理包含整个弹出过程事件，TFPopup使view本身实现此代理来封装以上动画效果的组合和弹出，你可以在弹框类中
&nbsp;&nbsp;&nbsp;&nbsp;重写一个或多个方法来截断和修改弹出过程以实现完全自定义动画效果
&nbsp;&nbsp;&nbsp;&nbsp;TFPopupBackgroundDelegate同TFPopupDataSource一样，可通过实现一个或多个方法来截断和修改弹出过程以实现完全自定义背景和背景动画





4.自定义背景属性,完全自定义背景<br>
5.完全自定义动画
## 默认支持几种弹出方式：
1.直接弹出<br>
2.缩放弹出<br>
3.滑动弹出<br>
4.基于某点的泡泡弹出<br>
5.基于frame变化的弹出<br>
6.基于遮罩的遮罩弹出<br>
## 在以上几种默认弹出方式中可通过简单修改参数产生不同的动画
1.所有弹出方式支持:是否使用背景,背景点击等事件设置和监听,背景透明度,背景渐隐动画,弹框渐隐动画,弹框偏移,弹窗大小等参数自由组合.<br>
2.滑动弹出支持上下左右四个方向，另外可以通过参数设置弹框的大小和偏移.<br>
3.泡泡的弹出方式支持上，上右。。八个方向另外可以通过参数设置弹框的大小和偏移.<br>
4.可以自由设置弹框的初始frame，和结束frame做弹出和动画方式.<br>
5.通过设置遮罩的path动画可以设置更丰富的动画效果.<br>
6.支持自定义属性动画,缩放弹出默认动画属性为transform.scale,通过修改属性和属性值可以做不同的动画,可选的属性值可参考以下.
```
CATransform3D{
    //rotation旋转
    transform.rotation.x
    transform.rotation.y
    transform.rotation.z
    //scale缩放
    transform.scale
    transform.scale.x
    transform.scale.y
    transform.scale.z
    //translation平移
    transform.translation.x
    transform.translation.y
    transform.translation.z
}
CGPoint{
    position
    position.x
    position.y
}
CGRect{
    bounds
    bounds.size
    bounds.size.width
    bounds.size.height
    bounds.origin
    bounds.origin.x
    bounds.origin.y
}
property{
    opacity
    backgroundColor
    cornerRadius
    borderWidth
    contents
    Shadow{
        shadowColor
        shadowOffset
        shadowOpacity
        shadowRadius
    }
}
```
## 自定义动画和弹出方式
如果以上默认动画都不能满足需求的话，可以使用自定义动画的方式实现更多不确定的动画方式，需要实现以下代理方法：
```
// 自定义动画代理,弹出框模式实现了此代理，并且代理对象为本身。通过以下代理的设置，为弹框设置了动画。
@protocol TFPopupDelegate<NSObject>
@optional;

/* 自定义背景弹框背景覆盖层view，设置动画的情况下覆盖层的alpha的值会0-1过渡
 * manager 中包含弹框过程多数基本信息，可以从此参数中获取可设置参数，具体参照TFPopupManager类
 * popup 即弹框的view */
-(UIView *)tf_popupCustemBackgroundView:(TFPopupManager *)manager
                                  popup:(UIView *)popup;

/* 准备动画前调用此函数，所以参数及设置都已经设置完成，在此函数回调中可随时修改可变参数
 * 返回值是否打断默认动画，切断默认动画意味着所有开始动画将自己实现
 * manager & popup 同上 */
-(BOOL)tf_popupWillShow:(TFPopupManager *)manager popup:(UIView *)popup;

/* 使用方式和作用tf_popupWillShow，不同的是如果打断默认动画，自己需要额外管理弹出框和背景视图等*/
-(BOOL)tf_popupWillHide:(TFPopupManager *)manager popup:(UIView *)popup;

/* 用户点击背景覆盖层时调用此函数，默认点击关闭弹框。
 * 返回值是否打断默认事件，如果打断默认事件，需要自己控制弹框的消失
 * manager & popup 同上 */
-(BOOL)tf_popupBackgroundTouch:(TFPopupManager *)manager popup:(UIView *)popup;
```

## 使用

**固定位置-无动画**

```
//效果参考：【默认动画效果1-1】
UIView *view = nil;
[view tf_showNormal:self.view animated:NO];
//[view tf_showNormal:self.view offset:CGPointMake(0, -100) animated:NO];//offset弹框相对于原来位置的偏移
//TFPopupParam *param = [TFPopupParam new];//更多参数设置
//[view tf_showNormal:self.view popupParam:param];
```

**固定位置-渐隐动画**

```
//效果参考：【默认动画效果1-1,此基础上背景和弹框具有渐隐效果】
UIView *view = nil;
[view tf_showNormal:self.view animated:YES];
//[view tf_showNormal:self.view offset:CGPointMake(0, -100) animated:YES];//offset弹框相对于原来位置的偏移
//TFPopupParam *param = [TFPopupParam new];//更多参数设置
//[view tf_showNormal:self.view popupParam:param];
```

**固定位置-缩放动画**

```
//效果参考：【默认动画效果2-1】
UIView *view = nil;
TFPopupParam *param = [TFPopupParam new];
[view tf_showScale:self.view offset:CGPointMake(0, 50) popupParam:param];
//[view tf_showScale:self.view offset:CGPointMake(0, 50)];
//[view tf_showScale:self.view];
```

**滑动弹出**

```
//效果参考：【默认动画效果1-2,1-3,3-2】
UIView *view = nil;
TFPopupParam *param = [TFPopupParam new];
param.popupSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 300);//设置弹框的尺寸
param.offset = CGPointZero;//在计算好的位置上偏移
[view tf_showSlide:self.view direction:PopupDirectionBottom popupParam:param];
//[view tf_showSlide:self.view direction:PopupDirectionLeft];
```

**泡泡弹出**

```
//效果参考：【默认动画效果3-1】
UIView *view = nil;
TFPopupParam *param = [TFPopupParam new];
param.popupSize = CGSizeMake(200, 300);//设置弹框的尺寸
param.offset = CGPointMake(-30, 50);//左移30右移50
[view tf_showBubble:self.view basePoint:CGPointMake(100, 100) bubbleDirection:PopupDirectionBottomLeft popupParam:param];
```

**形变&位移【frame】弹出**

```
//效果参考：【默认动画效果1-2,1-3,2-2,2-3,3-2】
UIView *view = nil;
TFPopupParam *param = [TFPopupParam new];
param.backgroundColorClear = YES;//设置背景色透明
CGRect from = CGRectMake(-200, 0, 200, [UIScreen mainScreen].bounds.size.height);
CGRect to = CGRectMake(0, 0, 200, [UIScreen mainScreen].bounds.size.height);
[view tf_showFrame:self.view from:from to:to popupParam:param];
```

**遮罩弹出**

```
//效果参考：【基于默认动画效果的参数自由组合1-2】【自定义动画效果2-1】
//小五角形在左
UIBezierPath *p0 = [UIBezierPath bezierPath];
[p0 moveToPoint:CGPointMake(-200, 0)];
[p0 addLineToPoint:CGPointMake(-100, 0)];
[p0 addLineToPoint:CGPointMake(0, 170 * 0.5)];
[p0 addLineToPoint:CGPointMake(-100, 170)];
[p0 addLineToPoint:CGPointMake(-200, 170)];
[p0 closePath];
//小五角形从左到右
UIBezierPath *p1 = [UIBezierPath bezierPath];
[p1 moveToPoint:CGPointMake(-200, 0)];
[p1 addLineToPoint:CGPointMake(314, 0)];
[p1 addLineToPoint:CGPointMake(314 + 100, 170 * 0.5)];
[p1 addLineToPoint:CGPointMake(314, 170)];
[p1 addLineToPoint:CGPointMake(-200, 170)];
[p1 closePath];

UIView *view = nil;
TFPopupParam *param = [TFPopupParam new];
param.maskShowFromPath = p0;
param.maskShowToPath = p1;
[view tf_showMask:self.view popupParam:param];
```

**默认动画基础上修改属性动画弹出**

```
//效果参考：【自定义动画效果2-3】

TFPopupParam *param = [TFPopupParam new];
param.showKeyPath = @"transform.rotation.y";//弹出时的属性动画
param.showFromValue = @(-M_PI * 2);//起始动画值
param.showToValue = @(0);//结束动画值
param.hideKeyPath = @"transform.rotation.x";//消失时的属性动画
param.hideFromValue = @(0);
param.hideToValue = @(M_PI * 2);
param.autoDissmissDuration = 1;//弹出后1s后自动消失
param.duration = 0.5;//动画时间0.5

UIView *view = nil;
[view tf_showCustem:self.view popupParam:param delegate:nil];
```

**自定义动画**

```
//【自定义动画效果1-3代码】
UIView *view = nil;
view.popupDelegate = self;
[view tf_showNormal:self.view popupParam:param];
//代理方法
//代理方法
- (BOOL)tf_popupViewWillShow:(UIView *)popup{
    if (@available(iOS 9.0, *)) {
        CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
        spring.damping = 15;
        spring.stiffness = 100;
        spring.mass = 1.5;
        spring.initialVelocity = 0;
        spring.duration = spring.settlingDuration;
        spring.fromValue = @(-200);
        spring.toValue = @(self.view.center.y);
        spring.fillMode = kCAFillModeForwards;
        [popup.layer addAnimation:spring forKey:nil];
        __weak typeof(popup) weakPopup = popup;
        [spring observerAnimationDidStop:^(CAAnimation *anima, BOOL finished) {
            if (finished) {
                weakPopup.center = CGPointMake(kSize.width * 0.5, kSize.height * 0.5);
            }
        }];
    }
    return NO;
}

- (BOOL)tf_popupViewWillHide:(UIView *)popup{
    if (@available(iOS 9.0, *)) {
        popup.center = CGPointMake(kSize.width * 0.5, -500);
        CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
        spring.damping = 15;
        spring.stiffness = 100;
        spring.mass = 1.5;
        spring.initialVelocity = 0;
        spring.duration = spring.settlingDuration;
        spring.fromValue = @(self.view.center.y);
        spring.toValue = @(-200);
        spring.fillMode = kCAFillModeForwards;
        [popup.layer addAnimation:spring forKey:nil];
        __weak typeof(popup) weakPopup = popup;
        [spring observerAnimationDidStop:^(CAAnimation *anima, BOOL finished) {
            if (finished) {
                weakPopup.center = CGPointMake(kSize.width * 0.5, -200);
            }
        }];
    }
    return NO;
}

```

**自定义背景**
需要自己实现代理TFPopupBackgroundDelegate,具体请看demo

```
//【自定义动画效果2-3代码】
- (NSInteger)tf_popupBackgroundViewCount:(UIView *)popup;//默认1
//默认UIButton背景色为black-0.3透明度
- (UIView *)tf_popupView:(UIView *)popup backgroundViewAtIndex:(NSInteger)index;
- (CGRect)tf_popupView:(UIView *)popup backgroundViewFrameAtIndex:(NSInteger)index;//默认弹框区域大小
```

## 监听弹出过程:block&delegate
监听弹出过程有两种方式,一种是代理方式如上所述，另外一种是block如下代码
```
//弹出前调用此函数以监听弹出过程
-(void)tf_observerDelegateProcess:(TFDelegateProcessBlock)delegateProcessBlock;

//弹出过程阶段枚举如下：
typedef NS_ENUM(NSInteger,DelegateProcess) {
    DelegateProcessWillGetConfiguration = 0,//将要获取弹出配置
    DelegateProcessDidGetConfiguration,//已经获取弹出配置
    DelegateProcessWillShow,//将要弹出
    DelegateProcessDidShow,//已经调用完弹出,正在执行动画
    DelegateProcessShowAnimationDidFinish,//弹出动画执行完成
    DelegateProcessWillHide,//将要消失
    DelegateProcessDidHide,//已经调用完消失,正在执行动画
    DelegateProcessHideAnimationDidFinish,//消失动画执行完成
    DelegateProcessBackgroundDidTouch,//默认背景点击
};

```

## Tips
```
1.当需要自定义动画自己重写代理方法时,有两种实现方式
(1)创建一个新类继承弹框视图，并重写需要重新的某个方法
(2)直接将弹框的某个代理(比如说自定义背景视图代理)指向其他类,然后重写代理的所有方法。
因为设置弹框的所有代理方法都通过category在本类实现，使用（1）方式可以直接重新某个方法实现修改，使用（2）方式需要实现对应代理的所有方法。
2.如果调用弹框代码很多，可以进行二次封装
```


## 注意
```
//默认值
//param.popupSize = 弹框本身的尺寸
//param.popupAreaRect = 弹框容器视图的bounds
//param.offset = CGPointZero;
//param.offset = CGPointZero;
//param.duration = 0.3;
//TFPopupDelegate代理默认值为弹框本身
```

## 使用
```
pod 'TFPopup'
```

## 如果
使用过程中有bug，请随时issues我或者联系我；
现有功能满足不了你的需求，请随时issues我或者联系我；
有更好的建议或者优化，请随时issues我或者联系我；
qq:927141965



        
