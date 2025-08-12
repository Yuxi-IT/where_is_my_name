import { common, UIAbility } from '@kit.AbilityKit';
import { preferences } from "@kit.ArkData";
import { window } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { fovModel } from '../model/list';
import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';

export async  function readFovModels(filesDir: string): Promise<fovModel[]> {
    try {
    const path = filesDir + '/fov.json';
    const stat = await fs.stat(path);
    if (!stat || !stat.isFile) {
    return [];
  }
  const file = fs.openSync(path, fs.OpenMode.READ_ONLY);
  const fileSize = stat.size;
  const arrayBuffer = new ArrayBuffer(fileSize);
  const readOptions: ReadOptions = {
    offset: 0,
    length: fileSize,
  };

  const readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
  fs.closeSync(file);

  const buf = buffer.from(arrayBuffer, 0, readLen);
  const jsonStr = buf.toString();

  if (!jsonStr) return [];

  const parsed:fovModel[] = JSON.parse(jsonStr);
  if (Array.isArray(parsed)) {
    return parsed.map(item => {
      const model = new fovModel();
      model.name = item.name ?? '';
      model.words = item.words;
      model.date = item.date;
      model.list = Array.isArray(item.list) ? item.list : [];
      return model;
    });
  }

  return [];
  } catch (e) {
    console.warn('读取fov.json失败:', e);
    return [];
  }
}

export async function  saveFovModels(filesDir: string, models: fovModel[]) {
  try {
    const path = filesDir + '/fov.json';
    const file = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
    const jsonStr = JSON.stringify(models, null, 2);
    const writeLen = fs.writeSync(file.fd, jsonStr);
    fs.closeSync(file);
    console.info(`写入fov.json成功，长度: ${writeLen}`);
  } catch (e) {
    console.error('写入fov.json失败:', e);
  }
}
