# TFPopup
**🚀🚀🚀TFPopup不生产弹框,它只是弹框的弹出工🚀🚀🚀默认支持多种动画方式一行调用,支持完全自定义动画.**

<br>弹框是UI开发中很常用的一种界面展示和交互方式，弹框在页面开发中占着很重要的位置。但是由于弹框具有UI不确定性，弹出方式不确定性，动画不确定性，还有需求的不确定性一直以来没能统一成一定的标准去做一个固定的轮子。所以可以退而求其次把UI，动画和弹出方式拆分开来，UI由开发者开发，动画和弹出方式统一成多数的标准，这样以来做弹框就会变得异常的简单:
<br>1.已经有一个弹框，或者新写一个页面作为弹框。
<br>2.用喜欢的方式将它弹出来。<br>
## 特点
1.和UI代码不耦合<br>
2.1+行代码调用<br>
3.默认支持多种弹出和动画方式,有更多参数可以自由组合<br>
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
## 效果截图示例ScreenShot
#### 自定义动画效果
___
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/cus-1.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/cus-2.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/cus-3.gif" width="30%" height="30%">
</div>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/cus-4.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/cus-5.gif" width="30%" height="30%">
</div>
<br>
#### 默认动画效果

___

<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/exc1.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/exc2.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/exc3.gif" width="30%" height="30%">
</div>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/exc4.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/exc5.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/exc6.gif" width="30%" height="30%">
</div>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/exc7.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/exc8.gif" width="30%" height="30%">
</div>
<br>
#### 基于默认动画效果的参数自由组合

___

<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/nor-bubble.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/nor-mask.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Excemple/nor-slide.gif" width="30%" height="30%">
</div>



