# TFPopup

[![License MIT](https://img.shields.io/badge/License-MIT-orange)]()&nbsp;
[![Platform iOS](https://img.shields.io/badge/platform-iOS-grayblue)]()&nbsp;
[![Pod 1.2.0](https://img.shields.io/badge/pod-1.2.0-blue)]()&nbsp;

### 中文版 | [English](https://github.com/shmxybfq/TFPopup/blob/master/README_EN.md)

**🚀🚀🚀不耦合view代码,可以为已创建过 / 未创建过的view添加弹出方式;
<br>🚀🚀🚀TFPopup不是弹框,它只是一种弹出方式;**
<br>使用TFPopup做弹框会让你的弹框变的异常简单:
<br>1.已经有一个view。
<br>2.用喜欢的方式将它弹出来。<br>

## 注意
文档包含大量gif图片,可能加载较慢<br>
项目分别包含Swift 和 OC Demo

## 特点
- 和view代码不耦合<br>
&nbsp;&nbsp;&nbsp;&nbsp;你可以将一个新的/已存在的view调用弹出方法将他弹出来
- 默认支持多种弹出方式<br>
&nbsp;&nbsp;&nbsp;&nbsp;无动画覆盖  /  缩放弹出  /  滑动弹出  /  基于某点的泡泡方式弹出  /  基于frame变化的弹出  /  基于于遮罩的遮罩弹出  /  折叠弹出
- 在弹出方式基础上可以通过**调节参数**来调整**弹出效果**<br>
&nbsp;&nbsp;&nbsp;&nbsp;**拖动：** 开启/关闭拖动  /  是否开启拖动弹性效果  /  设置拖动松手后自动消失距离<br>
&nbsp;&nbsp;&nbsp;&nbsp;**拖动方式：** 自由模式下弹框可全方向拖动,松手后触发消失  /  组合模式下可自由组合上下左右四个方向进行方向识别<br>
&nbsp;&nbsp;&nbsp;&nbsp;**时间调整：** 动画时间  /  动画延迟开始时间/动画延迟消失时间  /  弹框自动消失时间<br>
&nbsp;&nbsp;&nbsp;&nbsp;**时间曲线：** 通过UIViewAnimationOptions设置动画时间曲线<br>
&nbsp;&nbsp;&nbsp;&nbsp;**弹出背景：** 是否使用背景  /  调整背景颜色  /  背景色透明  /  背景点击事件及默认自动点击消失  /  背景显示、消失透明度动画<br>
&nbsp;&nbsp;&nbsp;&nbsp;**渐隐和位置：** 弹出渐隐  /  消失渐隐  /  弹出位置变化  /  消失位置变化<br>
&nbsp;&nbsp;&nbsp;&nbsp;**尺寸和位置：** 弹出区域计算尺寸设置  /  弹框尺寸  /  位置偏移量  /  初始位置  /  目标位置  /  是否始终保持原位置<br>
&nbsp;&nbsp;&nbsp;&nbsp;**属性动画：** 可分别设置显示、消失时的属性动画,只需要设置属性:属性值、初始值、结束值即可使用丰富的属性动画效果<br>
&nbsp;&nbsp;&nbsp;&nbsp;**泡泡：** 泡泡基准点  /  泡泡八个弹出方向<br>
&nbsp;&nbsp;&nbsp;&nbsp;**mask：** 可分别设置显示、消失时的mask,只需要设置属性:mask初始path、mask结束path即可<br>
- 保留弹出全过程接口，支持完全自定义弹出方式、动画、和背景<br>
&nbsp;&nbsp;&nbsp;&nbsp;**TFPopupDataSource**此代理包含弹出动画需要的各种参数配置，在动画开始后会依次被调用
&nbsp;&nbsp;&nbsp;&nbsp;**TFPopupBackgroundDelegate**同TFPopupDataSource一样，可通过实现一个或多个方法来截断和修改弹出过程以实现完全自定义背景和背景动画
&nbsp;&nbsp;&nbsp;&nbsp;**TFPopupDelegate**代理包含整个弹出过程事件，TFPopup使view本身实现此代理来封装以上动画效果的组合和弹出，你可以在弹框类中
&nbsp;&nbsp;&nbsp;&nbsp;重写一个或多个方法来截断和修改弹出过程以实现完全自定义动画效果


## 弹出效果图示例

**拖动**
___
<div>
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/drag1.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/drag2.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/drag3.gif" width="30%" height="30%">
</div>
<div>
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/drag0.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/drag4.gif" width="30%" height="30%">
</div>
<br>

**自定义动画效果**
___
<div>
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/cus-6.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/cus-2.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/cus-3.gif" width="30%" height="30%">
</div>
<div>
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/cus-4.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/cus-5.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/cus-1.gif" width="30%" height="30%">
</div>
<br>

**默认动画效果**

___

<div>
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/TFPopup-Example/exa1.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/TFPopup-Example/exa2.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/TFPopup-Example/exa3.gif" width="30%" height="30%">
</div>
<div>
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/TFPopup-Example/exa4.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/TFPopup-Example/exa5.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/TFPopup-Example/exa6.gif" width="30%" height="30%">
</div>
<div>
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/exa7.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/exa8.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/exa9.gif" width="30%" height="30%">
</div>
<br>

**基于默认动画效果的参数自由组合**

___

<div>
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/nor-bubble.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/nor-mask.gif" width="30%" height="30%">
<img src="https://gitee.com/shmxybfq/TFProductResource/blob/master/TFPopup-Example/nor-slide.gif" width="30%" height="30%">
</div>


## 使用
图片加载较慢请耐心等待或在项目目录中查找使用截图资源
<br/>

### 普通用法
不设置TFPopupParam
<br/>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/TFPopupOperatingInstruction.png" width="100%" height="100%">
</div>

### 高级用法
通过设置TFPopupParam修改弹出方式和动画等
<br/>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/TFPopupParam.png" width="100%" height="100%">
</div>

### 自定义用法
通过在view上重写TFPopupDataSource 和 TFPopupBackgroundDelegate 的一个或多个方法来实现你想要的效果
<br/>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/delegateAndDatasource.png" width="100%" height="100%">
</div>

## 自定义用法请注意！！！
下图此属性TFPopupExtension是弹框view整个弹框过程中保存内部属性的一个model,所有和弹框过程相关的属性都在这里
<br/>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/UIView+TFPopup.png" width="100%" height="100%">
</div>
<br/>
TFPopupExtension model详情
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/TFPopupExtension.png" width="100%" height="100%">
</div>


## 使用补充
##### 以上方式简单描述了使用方法,具体效果和使用请参照demo !
##### 此框架会一直更新维护【转行除外】请放心使用。

## 安装
```
pod 'TFPopup'
```

## 如果
使用过程中有bug或不足，请随时issues我或者联系我；<br>
现有功能满足不了你的需求，请随时issues我或者联系我；<br>
有更好的建议或者优化，请随时issues我或者联系我；<br>
QQ:927141965;<br>
邮箱shmxybfq@163.com;<br>



        
