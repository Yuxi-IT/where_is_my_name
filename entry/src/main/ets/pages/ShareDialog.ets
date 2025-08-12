import {qrcodegen} from "@ohos/qr-code-generator"
import { pasteboard } from "@kit.BasicServicesKit";


@CustomDialog
export struct ShareDialog {
  controller: CustomDialogController
  context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  url: string = "";

  build() {
    Column() {
      Canvas(this.context)
        .width(180)
        .height(180)
        .onReady(()=>{
          let qrc = qrcodegen.QrCode.encodeText(this.url,qrcodegen.QrCode.Ecc.MEDIUM)
          qrc.drawCanvas(8, 1, this.context)
        })
      Text(this.url)
        .margin({top:15,left:10,right:10})
      Button("复制分享链接")
        .width(160)
        .margin({top:15})
        .onClick(async ()=>{
          let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.url);
          let systemPasteboard = pasteboard.getSystemPasteboard();
          await systemPasteboard.setData(pasteData);
        })

    }
    .height(350)
    .justifyContent(FlexAlign.Center)

  }

}
