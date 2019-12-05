# TFPopup

[![License MIT](https://img.shields.io/badge/License-MIT-orange)]()&nbsp;
[![Platform iOS](https://img.shields.io/badge/platform-iOS-grayblue)]()&nbsp;
[![Pod 1.2.0](https://img.shields.io/badge/pod-1.2.0-blue)]()&nbsp;


### English | [中文版](https://github.com/shmxybfq/TFPopup/blob/master/README_EN.md)  


**🚀🚀🚀Uncoupled view code, you can add popup methods for created / uncreated views;
<br>🚀🚀🚀TFPopup not a view, it is only a pop-up manner;**
<br>Using TFPopup as a pop-up box will make your pop-up box extremely easy:
<br>1.You already have a view;
<br>2.Pop it up the way you like;<br>

## Warning
The document contains a lot of gif images and may load slowly<br>
Project contains Swift and OC Demo respectively

## Features
- Decouple view code<br>
&nbsp;&nbsp;&nbsp;&nbsp; You can add popup methods for created / uncreated views;
- Support multiple pop-up methods by default<br>
&nbsp;&nbsp;&nbsp;&nbsp;No Animation cover / zoom eject / eject slide / mode based on a point of bubble eject / eject frame based variation / mask based on the mask eject / eject folded
- On the basis of the way through the pop-up**Adjust parameters**to adjust**pop-up effect**<br>
&nbsp;&nbsp;&nbsp;&nbsp;**Drag：** Turn drag on / off / whether to enable drag elastic effect / set the distance to automatically disappear after dragging<br>
&nbsp;&nbsp;&nbsp;&nbsp;**Drag style：** In free mode, the pop-up box can be dragged in all directions, and the trigger disappears after letting go./ In combination mode, you can freely combine the four directions to recognize the direction.<br>
&nbsp;&nbsp;&nbsp;&nbsp;**Time adjustment：** Animation time / Animation delay start time / Animation delay disappear time / Pop-up frame disappear time automatically<br>
&nbsp;&nbsp;&nbsp;&nbsp;**Time curve：** Set animation time curve via UIViewAnimationOptions<br>
&nbsp;&nbsp;&nbsp;&nbsp;**Pop-up background：** Whether to use the background / adjust the background color / transparent background color / background click event and default auto click disappear / background display, disappear transparency animation<br>
&nbsp;&nbsp;&nbsp;&nbsp;**Fade and location：** Pop-up Fade / Disappear Fade-out / Pop-up Position Change / Vanish Position Change<br>
&nbsp;&nbsp;&nbsp;&nbsp;**Size and location：** Pop-up area calculation size setting / pop-up frame size / position offset / initial position / target position / whether to always maintain the original position<br>
&nbsp;&nbsp;&nbsp;&nbsp;**Attribute animation：** You can set the property animations when displaying and disappearing.You only need to set the properties: property value, initial value, and end value to use rich property animation effects<br>
&nbsp;&nbsp;&nbsp;&nbsp;**Bubble：** Bubble reference points / Eight pop-up directions<br>
&nbsp;&nbsp;&nbsp;&nbsp;**Mask：** You can set the mask when displaying and disappearing.You only need to set the attributes: the initial path of the mask and the end path of the mask.<br>
- Retain full pop-up interface, support fully custom pop-up method, animation, and background<br>
&nbsp;&nbsp;&nbsp;&nbsp;**TFPopupDataSource**This agent contains various parameter configurations required for the pop-up animation, which will be called in turn after the animation starts
&nbsp;&nbsp;&nbsp;&nbsp;**TFPopupBackgroundDelegate**As with TFPopupDataSource, you can truncate and modify the popup process by implementing one or more methods to achieve a completely custom background and background animation
&nbsp;&nbsp;&nbsp;&nbsp;**TFPopupDelegate**The proxy contains the entire popup process event. TFPopup makes the view itself implement this proxy to encapsulate the combination and popup of the above animation effects. You can do this in the popup class
&nbsp;&nbsp;&nbsp;&nbsp;Overriding one or more methods to truncate and modify the pop-up process for fully custom animation effects


## Pop-up effect example

**Drag**
___
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/drag1.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/drag2.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/drag3.gif" width="30%" height="30%">
</div>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/drag0.gif" width="30%" height="30%">
</div>
<br>

**Custom animation effects**
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

**Default animation effect**

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

**Free combination of parameters based on default animation effects**

___

<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/nor-bubble.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/nor-mask.gif" width="30%" height="30%">
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/nor-slide.gif" width="30%" height="30%">
</div>


## How to use
Pictures load slowly. Please be patient or look in the project directory using screenshot resources
<br/>

### Common usage
Do not set TFPopupParam
<br/>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/TFPopupOperatingInstruction.png" width="100%" height="100%">
</div>

### Advanced usage
Modify the pop-up method and animation by setting TFPopupParam
<br/>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/TFPopupParam.png" width="100%" height="100%">
</div>

### Custom usage
To achieve the effect you want by overriding one or more methods of TFPopupDataSource and TFPopupBackgroundDelegate on the view
<br/>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/delegateAndDatasource.png" width="100%" height="100%">
</div>

## Please note the custom usage！！！
The following figure, this attribute TFPopupExtension is a model that saves the internal attributes during the whole frame view of the frame view. All the attributes related to the frame process are here
<br/>
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/UIView+TFPopup.png" width="100%" height="100%">
</div>
<br/>
TFPopupExtension model detail
<div>
<img src="https://github.com/shmxybfq/TFPopup/blob/master/Example/TFPopupExtension.png" width="100%" height="100%">
</div>


## Use supplement
##### The above method briefly describes the use method. For specific effects and use, please refer to the demo!
##### This framework will be updated and maintained all the time [except for career change] Please rest assured.

## Installation
```
pod 'TFPopup'
```

## In case
There are bugs or deficiencies during use, please feel free to issue me or contact me；<br>
The existing functions cannot meet your needs, please feel free to issue me or contact me；<br>
Have better suggestions or optimization, please feel free to issue me or contact me；<br>
Email: shmxybfq@163.com;<br>



        
