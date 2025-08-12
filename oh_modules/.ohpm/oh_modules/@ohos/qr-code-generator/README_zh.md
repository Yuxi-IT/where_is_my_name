# qr-code-generator

## 简介
>用于生成符合国际标准的高质量 QR 码。它支持生成包括文本、URL、邮件地址、电话号码等不同类型数据的 QR 码，并且具有灵活的参数设置，能够生成矢量图形以保持图像清晰度，同时具备良好的性能。
> 支持按照二维码Model 2标准对所有40个版本（尺寸）和所有4个纠错级别进行编码。
> 输出格式：QR符号的原始模块/像素。

![](screenshot/screenshot_zh.gif)

## 下载安装
```shell
ohpm install @ohos/qr-code-generator
```
- OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

## 使用说明

### 1、创建context：
 ```
Context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
 ```
### 2、通过canvas设置绘制区域：
 ```
Canvas(this.Context).width('80%').height("50%")
 ```
### 3、设置二维码显示内容及容错率：
 ```
qrcode: qrcodegen.QrCode = qrcodegen.QrCode.encodeText("Hello, world!", qrcodegen.QrCode.Ecc.MEDIUM)
 ```
### 4、绘制二维码：
 ```
qrcode.drawCanvas(8, 1, this.Context)
 ```

## 接口说明
1. 二维码符号类:`qrcodegen.QrCode`
   - 获取有效载荷数据：`qrcodegen.QrCode.encodeText（）或qrcodegen.QrCode.encodeBinary（）`
   - 定制片段列表:`qrcodegen.QrCode.encodeSegments（）`
   - 二维码绘制：`qrcodegen.QrCode.drawCanvas（）`
   
2. 数据段类:`qrcodegen.QrSegment`
   - 文本字符串转换为UTF-8字节并编码为字节模式段：`qrcodegen.QrSegment.makeBytes()`
   - 以数字模式编码的给定十进制数字字符串:`qrcodegen.QrSegment.makeNumeric()`
   - 以字母数字模式编码的给定文本字符串：`qrcodegen.QrSegment.makeAlphanumeric()`
   - 一个包含零个或多个段的新可变列表的给定的Unicode文本字符串：`qrcodegen.QrSegment.makeSegments()`
   - 具有给定赋值的扩展通道解释（ECI）指示符：`qrcodegen.QrSegment.makeEci()`
   
3. 二维码符号中的错误纠正级别:`qrcodegen.QrCode.Ecc`

4. 解释段的数据位:`qrcodegen.QrSegment.Mode`

单元测试用例详情见[TEST.md](https://gitcode.com/openharmony-sig/qr-code-generator/blob/master/TEST.md)

## 关于混淆
- 代码混淆，请查看[代码混淆简介](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- 如果希望qr-code-generator库在代码混淆过程中不会被混淆，需要在混淆规则配置文件obfuscation-rules.txt中添加相应的排除规则：
```
-keep
./oh_modules/@ohos/qr-code-generator
```

## 约束与限制
在下述版本验证通过：
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API12 Release(5.0.0.66)
- 
- DevEco Studio NEXT Developer Preview2: (5.0.3.24), SDK: API12 Canary1(5.0.0.13)

- DevEco Studio: 3.1Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)

## 目录结构
````
|---- qr-code-generator 
|     |---- entry  # 示例代码文件夹
|     |---- qrcodegen  # qrcodegen库文件夹
|           |---- index.ets  # 对外接口
|           |---- src
|                  |---- main
|                        |---- ets
|                              |---- components
|                                    |---- qrcodegen.ets  #二维码生成实现
|     |---- README_zh.md  # 安装使用方法                    
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/openharmony-sig/qr-code-generator/issues) 给组件，当然，也非常欢迎发 [PR](https://gitcode.com/openharmony-sig/qr-code-generator/pulls) 共建。

## 开源协议
本项目基于 [MIT License](https://gitcode.com/openharmony-sig/qr-code-generator/blob/master/LICENSE) ，请自由地享受和参与开源。