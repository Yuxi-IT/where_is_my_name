# qr-code-generator

## Introduction
qr-code-generator generates international standard–compliant QR codes for various data types, including text, URLs, email addresses, and phone numbers. It offers flexible settings to generate vector graphics to maintain image clarity while providing good performance. It supports encoding for all 40 versions (sizes) and all 4 error correction levels according to the QR Code Model 2 standard.

Output format: raw module/pixel of the QR symbol.

![](screenshot/screenshot.gif)

## How to Install
```shell
ohpm install @ohos/qr-code-generator
```
- For details about the OpenHarmony ohpm environment configuration, see [OpenHarmony HAR](https://gitcode.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.en.md).

## How to Use

### 1. Creating a Context
 ```
Context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
 ```
### 2. Setting the Drawing Area Using the Canvas
 ```
Canvas(this.Context).width('80%').height("50%")
 ```
### 3. Setting the QR Code Content and Error Correction Level
 ```
qrcode: qrcodegen.QrCode = qrcodegen.QrCode.encodeText("Hello, world!", qrcodegen.QrCode.Ecc.MEDIUM)
 ```
### 4. Drawing the QR Code
 ```
qrcode.drawCanvas(8, 1, this.Context)
 ```

## Available APIs
1. QR code symbol class: **qrcodegen.QrCode**
   - Obtain payload data: **qrcodegen.QrCode.encodeText()** or **qrcodegen.QrCode.encodeBinary()**
   - Customize a segment list: **qrcodegen.QrCode.encodeSegments()**
   - Draw the QR code: **qrcodegen.QrCode.drawCanvas()**
   
2. Data segment class: **qrcodegen.QrSegment**
   - Convert a text string to UTF-8 bytes and encode it into a byte mode segment: **qrcodegen.QrSegment.makeBytes()**
   - Encode a given decimal digit string in numeric mode: **qrcodegen.QrSegment.makeNumeric()**
   - Encode a given text string in alphanumeric mode: **qrcodegen.QrSegment.makeAlphanumeric()**
   - Create a new mutable list of segments from a given Unicode text string, which may contain zero or more segments: **qrcodegen.QrSegment.makeSegments()**
   - Create an Extended Channel Interpretation (ECI) indicator with a specified assignment value: **qrcodegen.QrSegment.makeEci()**
   
3. Error correction levels for QR code symbols: **qrcodegen.QrCode.Ecc**

4. Data modes for interpreting segments: **qrcodegen.QrSegment.Mode**

For details about unit test cases, see [TEST.md](https://gitcode.com/openharmony-sig/qr-code-generator/blob/master/TEST.md).

## About obfuscation
- Code obfuscation, please see[Code Obfuscation](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/source-obfuscation.md)
- If you want the qr-code-generator library not to be obfuscated during code obfuscation, you need to add corresponding exclusion rules in the obfuscation rule configuration file obfuscation-rules.txt：
```
-keep
./oh_modules/@ohos/qr-code-generator
```

## Constraints
This project has been verified in the following versions:
- DevEco Studio: NEXT Beta1-5.0.3.806, SDK: API 12 Release (5.0.0.66)
- DevEco Studio NEXT Developer Preview2: (5.0.3.24), SDK: API 12 Canary1 (5.0.0.13)

- DevEco Studio: 3.1Beta2 (3.1.0.400), SDK: API 9 Release (3.2.11.9)

## Directory Structure
````
|---- qr-code-generator 
|     |---- entry                                        # Sample code
|     |---- qrcodegen                                    # Library
|           |---- index.ets                              # External APIs
|           |---- src
|                  |---- main
|                        |---- ets
|                              |---- components
|                                    |---- qrcodegen.ets # Implementation of QR code generation
|     |---- README.md                                    # Readme                   
````

## How to Contribute
If you find any problem when using the project, submit an [issue](https://gitcode.com/openharmony-sig/qr-code-generator/issues) or a [PR](https://gitcode.com/openharmony-sig/qr-code-generator/pulls).

## License
This project is licensed under [MIT License](https://gitcode.com/openharmony-sig/qr-code-generator/blob/master/LICENSE).
