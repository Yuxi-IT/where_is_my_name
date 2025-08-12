import { common, UIAbility } from '@kit.AbilityKit';
import { preferences } from "@kit.ArkData";
import { window } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { fovModel } from '../model/list';
import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import { readFovModels, saveFovModels } from '../model/filemanger';

@CustomDialog
export struct FavorDialog {
  controller: CustomDialogController
  list: string[] = [];
  name: string = "";
  words: string = "";

  build() {
    Column() {
      Text(`收藏${this.list.length}张图片`)
        .fontSize(18)
      TextInput({ placeholder: '输入要保存的图组名称' })
        .width(240)
        .onChange((e) => {
          this.name = e;
        })
        .margin({ top: 15 })
      Button("保存图组到收藏夹")
        .width(160)
        .margin({ top: 15 })
        .onClick(async () => {
          if (this.name.length === 0) {
            AlertDialog.show({
              title: "错误",
              message: "请输入要保存的图组名称",
              confirm: {
                value: "确认",
                action: () => { }
              }
            });
            return;
          }
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          let filesDir = context.filesDir;
          let models = await readFovModels(filesDir);
          const newModel = new fovModel();
          newModel.name = this.name;
          newModel.list = this.list;
          newModel.words = this.words;
          newModel.date = Date.now().toString();
          models.push(newModel);
          await saveFovModels(filesDir, models);

          AlertDialog.show({
            title: "提示",
            message: "保存成功！",
          });
        })
    }
    .height(160)
    .justifyContent(FlexAlign.Center)
  }
}
