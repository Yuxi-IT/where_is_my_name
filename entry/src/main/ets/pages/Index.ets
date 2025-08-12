import { imgList, imgDatas, imgdata, fovModel } from "../model/list.ts";
import { ShareDialog } from "./ShareDialog.ets";
import { Base64 } from '@ohos/base64';
import { pasteboard } from "@kit.BasicServicesKit";
import { FavorDialog } from "./FavorDialog";
import { readFovModels, saveFovModels } from '../model/filemanger';
import { common } from '@kit.AbilityKit';
import { ListDataSource } from "../model/ListDataSource";
import { router } from "@kit.ArkUI";
import url from '@ohos.url';

@Entry
@Component
struct Index {
  @State inputText: string = '';
  @State resultImages: string[] = [];
  @State imageContainerWidth: number = 0;
  @State imageOpacities: number[] = [];
  @State isAnimating: boolean = false;
  @State selectedImageInfo: imgdata | null = null;

  @State isRefreshing: boolean = false;

  @State currentIndex: number = 0;
  @State selectedIndex: number = 0;
  @State tabText:string[] = ["探寻","喜爱","关于"];
  @State tabIcon:Resource[] = [
    $rawfile("icon/ic_public_home_filled.svg"),$rawfile("icon/ic_public_home.svg"),
    $rawfile("icon/ic_public_favor_filled.svg"),$rawfile("icon/ic_public_favor.svg"),
    $rawfile("icon/ic_public_detail_filled.svg"),$rawfile("icon/ic_public_detail.svg")
  ];
  private controller: TabsController = new TabsController();
  @State fovModels: fovModel[] = [];

  @Builder
  private tabBuilder(index: number) {
    Column() {
      Image(this.selectedIndex === index
        ? this.tabIcon[index * 2]
        : this.tabIcon[index * 2 + 1]
      )
        .width(26)
        .height(26)
        .margin({ bottom: 4 })
        .objectFit(ImageFit.Contain)
      Text(this.tabText[index])
        .fontSize(12)
        .fontWeight(500)
        .lineHeight(14)
        .foregroundColor("#000")
        .margin({bottom: 10})
    }
    .padding({top: 4,bottom: 10})
    .height(100)
    .width('100%')
    .backgroundColor("#fff")
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {

        // Tab 1: 搜索图片
        TabContent() {
          Column() {
            TextInput({ placeholder: '输入您的英文名或其他字符' })
              .width('80%')
              .height(50)
              .margin({ top: 40 })
              .type(InputType.Normal)
              .placeholderFont({ size: 16 })
              .onChange((value: string) => {
                this.inputText = value.replace(/[^a-zA-Z]/g, '');
              })
              .onSubmit(() => {
                this.searchImages();
              })

            Flex({
              direction: FlexDirection.Row,
              wrap: FlexWrap.NoWrap,
              justifyContent: FlexAlign.Center
            }) {
              Button('在地球上查找 🌏')
                .width('45%')
                .height(40)
                .fontSize(16)
                .onClick(() => {
                  this.searchImages();
                })

              Button() {
                Image($rawfile("icon/ic_public_share.svg"))
                  .width(20)
                  .height(20)
              }
              .width(40)
              .height(40)
              .margin({ left: 5 })
              .onClick(async () => {
                if (this.inputText.length === 0 && this.resultImages.length === 0) {
                  AlertDialog.show({
                    title: "错误",
                    message: "请输入一些内容"
                  });
                  return;
                }
                const dialogController = new CustomDialogController({
                  builder: ShareDialog({
                    url: `http://www.yuxiit.com.cn/name/?imgs=${Base64.encodeToString(Base64.stringToBytes(this.resultImages.join(",").replaceAll(".jpg", "")))}`,
                  }),
                });
                dialogController.open();
              })

              Button() {
                Image($rawfile("icon/ic_public_favor_white.svg"))
                  .width(20)
                  .height(20)
              }
              .width(40)
              .height(40)
              .margin({ left: 5 })
              .onClick(async () => {
                if (this.inputText.length === 0 || this.resultImages.length === 0) {
                  AlertDialog.show({
                    title: "错误",
                    message: "请输入一些内容"
                  });
                  return;
                }

                const dialogController = new CustomDialogController({
                  builder: FavorDialog({
                    list: this.resultImages,
                    words: this.inputText,

                  }),
                });
                dialogController.open();
              })
            }.margin({ top: 20 })

            Flex({
              direction: FlexDirection.Row,
              wrap: FlexWrap.NoWrap,
              justifyContent: FlexAlign.Center,
              alignItems: ItemAlign.Center
            }) {
              ForEach(this.resultImages, (item: string, index: number) => {
                Image($rawfile(`words/${item}`))
                  .width(212)
                  .height('80%')
                  .objectFit(ImageFit.Contain)
                  .margin(0)
                  .opacity(this.imageOpacities[index] ?? 1)
                  .onClick(() => {
                    this.showImageInfo(item);
                  })
              })
            }
            .width('100%')
            .height('80%')
            .margin({ top: 10 })
            .zIndex(-999)
            .onAreaChange((_, newValue) => {
              const widthValue = parseInt(newValue.width.toString().replace(/[^0-9]/g, ''));
              this.imageContainerWidth = widthValue;
            })
          }
          .width('100%')
          .height('100%')
          .padding(10)
          .onAppear(() => {
            this.searchImages("HI");
          })
        }.tabBar(this.tabBuilder(0))

        // Tab 2: 收藏列表
        TabContent() {
          Column(){
            if(this.fovModels.length === 0)
            {
              Column() {
                Text("还没有收藏的图组，请先进行探索吧")
                  .fontSize(18)

                Button() {
                  Image($rawfile("icon/ic_public_refresh.svg"))
                    .width(20)
                    .height(20)
                }
                .width(40)
                .height(40)
                .margin({top:10})
                .onClick(async ()=>{
                  this.isRefreshing = true;
                  await this.loadFovModels();
                })
              }
              .width('100%')
              .height('100%')
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)

            }
            Refresh({ refreshing: $$this.isRefreshing }) {
              List() {
                ForEach(this.fovModels.reverse(), (item: fovModel) => {
                  ListItem() {
                    Column() {
                      Text(`图组名: ${item.name}`)
                        .fontSize(16)
                        .textAlign(TextAlign.Center)
                      Text(`内容: ${item.words}`)
                        .fontSize(16)
                        .textAlign(TextAlign.Center)
                      Text(`日期: ${this.formatTimestamp(item.date)}`)
                        .fontSize(16)
                        .textAlign(TextAlign.Center)

                    }.width('80%')
                    .height(100)
                    .justifyContent(FlexAlign.Center)
                    .borderRadius(20)
                    .backgroundColor("#8fa2a2a2")
                    .margin({ bottom: 15 ,left:"10%",right:"10%"})
                  }.onClick(()=>{
                    const dialogController = new CustomDialogController({
                      builder: ShareDialog({
                        url: `http://www.yuxiit.com.cn/name/?imgs=${Base64.encodeToString(Base64.stringToBytes(item.list.join(",")))}`,
                      }),
                    });
                    dialogController.open();
                  })
                }, (item: fovModel) => item.name)
              }
              .width('100%')
              .height('100%')
            }
            .onRefreshing(async () => {
              await this.loadFovModels();
              this.isRefreshing = false;
            })
            .onStateChange((refreshStatus: RefreshStatus) => {
              console.info('刷新状态: ' + refreshStatus);
            })
            .onOffsetChange((offset: number) => {
              console.info('刷新偏移: ' + offset);
            })
            .width('100%')
            .height('100%')
            .onAppear(async () => {
              await this.loadFovModels();
            })
          }

        }.tabBar(this.tabBuilder(1))


        // Tab 3: 关于
        TabContent() {
          Scroll() {
            Column({ space: 20 }) {
              Text('关于本应用')
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .margin({ top: 20, bottom: 10 })
                .textAlign(TextAlign.Center)
                .width('100%')

              Text('数据来源')
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
                .width('100%')

              Text("本应用的数据来自于 NASA 与 USGS.")
              .fontSize(16)
              .lineHeight(22)
              .width('100%')
              .textAlign(TextAlign.Start)

              Text('隐私与安全')
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
                .width('100%')

              Text('所有的数据都仅保存在您的设备中，不会上传到任何服务器。')
                .fontSize(16)
                .lineHeight(22)
                .width('100%')
                .textAlign(TextAlign.Start)

              Text('分享图像所使用的是一个静态网页，没有服务器端数据收集，您同样可以在Github中找到它。')
                .fontSize(16)
                .lineHeight(22)
                .width('100%')
                .textAlign(TextAlign.Start)

              Hyperlink("https://agreement-drcn.hispace.dbankcloud.cn/index.html?lang=zh&agreementId=1749874199133984704",
                "隐私政策(点击复制链接)")
                .width('100%')
                .onClick(async()=>{
                  let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, "https://agreement-drcn.hispace.dbankcloud.cn/index.html?lang=zh&agreementId=1749874199133984704");
                  let systemPasteboard = pasteboard.getSystemPasteboard();
                  await systemPasteboard.setData(pasteData);
                })

              Text('开源社区')
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
                .width('100%')

              Hyperlink("https://github.com/yuxi-it/where_is_my_name",
                        "开源社区(点击复制链接)")
                .width('100%')
                .onClick(async()=>{
                  let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, "https://github.com/yuxi-it/where_is_my_name");
                  let systemPasteboard = pasteboard.getSystemPasteboard();
                  await systemPasteboard.setData(pasteData);
                })
            }
            .padding(20)
            .width('100%')
          }
          .width('100%')
          .height('100%')
        }.tabBar(this.tabBuilder(2))


      }
      .vertical(false)
      .barHeight(56)
      .onChange((index: number) => {
        this.currentIndex = index;
        this.selectedIndex = index;
      })
      .onAnimationStart((index: number, targetIndex: number) => {
        if (index === targetIndex) return;
        this.selectedIndex = targetIndex;
      })
      .width('100%')
      .height('100%')
      .margin({ top: 38 })
      .padding({bottom: 10})
    }
    .width('100%')
    .height('100%')
  }
  private formatTimestamp(ts: number | string): string {
    const timestamp = Number(ts);
    const date = new Date(timestamp);

    const Y = date.getFullYear();
    const M = String(date.getMonth() + 1).padStart(2, '0');
    const D = String(date.getDate()).padStart(2, '0');
    const h = String(date.getHours()).padStart(2, '0');
    const m = String(date.getMinutes()).padStart(2, '0');
    const s = String(date.getSeconds()).padStart(2, '0');

    return `${Y}-${M}-${D} ${h}:${m}:${s}`;
  }

  private getRandomImagesByLetters(input: string): string[] {
    const letters = input.toLowerCase().replace(/[^a-z]/g, '').split('');
    const result: string[] = [];

    letters.forEach(letter => {
      const matchedImages = imgList.filter(img => img.startsWith(`${letter}_`));
      if (matchedImages.length > 0) {
        const randomIndex = Math.floor(Math.random() * matchedImages.length);
        result.push(matchedImages[randomIndex]);
      }
    });

    return result;
  }

  private showImageInfo(imageName: string) {
    imgDatas.forEach(imgdata => {
      if (imgdata.name == imageName.replace(".jpg", "")) {
        this.selectedImageInfo = imgdata;
        AlertDialog.show({
          title: "关于这张图片...",
          message: `地区: ${this.selectedImageInfo.region}\n坐标: ${this.selectedImageInfo.xy}`,
          confirm: {
            value: '获取下载链接',
            action: async () => {
              let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, `https://www.yuxiit.com.cn/name/imgs/${imageName}`);
              let systemPasteboard = pasteboard.getSystemPasteboard();
              await systemPasteboard.setData(pasteData);
            }
          },
          alignment: DialogAlignment.Center,
          offset: { dx: 0, dy: 0 },
        });
        return;
      }
    });
  }

  public async searchImages(ipt?: string) {
    if (this.isAnimating) return;

    if (this.inputText.length === 0 && ipt?.length === 0) {
      AlertDialog.show({
        title: '错误',
        message: '请输入一些内容',
        autoCancel: true,
        alignment: DialogAlignment.Center,
        gridCount: 3,
        offset: { dx: 0, dy: 0 },
      });
      return;
    }

    this.isAnimating = true;

    if (this.resultImages.length > 0) {
      await this.fadeOutImages();
    }

    let input = "";
    if (!ipt) {
      input = this.inputText;
    } else {
      input = ipt;
    }
    const images = this.getRandomImagesByLetters(input);

    if (images.length === 0) {
      AlertDialog.show({
        title: '错误',
        message: '没有找到匹配的图片',
        autoCancel: true,
        alignment: DialogAlignment.Center,
        gridCount: 3,
        offset: { dx: 0, dy: 0 },
      });
      this.resultImages = [];
    } else {
      this.resultImages = images;
      this.imageOpacities = new Array(images.length).fill(0);
      await this.fadeInImages();
    }

    this.isAnimating = false;
  }

  private fadeOutImages(): Promise<void> {
    return new Promise((resolve) => {
      animateTo({
        duration: 500,
        curve: Curve.EaseOut
      }, () => {
        this.imageOpacities = this.imageOpacities.map(() => 0);
      });

      setTimeout(() => {
        resolve();
      }, 500);
    });
  }

  private fadeInImages(): Promise<void> {
    return new Promise((resolve) => {
      animateTo({
        duration: 500,
        curve: Curve.EaseIn
      }, () => {
        this.imageOpacities = this.imageOpacities.map(() => 1);
      });

      setTimeout(() => {
        resolve();
      }, 500);
    });
  }

  // 读取收藏数据
  public async loadFovModels(): Promise<void> {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const filesDir = context.filesDir;
    this.fovModels = await readFovModels(filesDir);
  }

  // 保存收藏数据
  public async saveCurrentModels(): Promise<void> {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    const filesDir = context.filesDir;
    await saveFovModels(filesDir, this.fovModels);
  }
}
