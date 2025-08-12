## qr-code-generator单元测试用例

该测试用例基于OpenHarmony系统下，进行单元测试

### 单元测试用例覆盖情况

|接口名 | 是否通过 |备注|
|---|---|---|
|qrcodegen.QrCode.encodeText（）|pass|
|qrcodegen.QrCode.encodeBinary（）|pass|
|qrcodegen.QrCode.encodeSegments（）|pass|
|qrcodegen.QrSegment.makeBytes()|pass|
|qrcodegen.QrSegment.makeNumeric()|pass|
|qrcodegen.QrSegment.makeAlphanumeric()|pass|
|qrcodegen.QrSegment.makeSegments()|pass|
|qrcodegen.QrSegment.makeEci()|pass|