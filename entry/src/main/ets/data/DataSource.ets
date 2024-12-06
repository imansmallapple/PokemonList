import { Pokemon, PokemonResponse, PokeInfo } from '../Model/Pokemon';
import http from '@ohos.net.http';

const BASE_URL: string = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=1000"

class PokemonDataSource {
  public static PokemonList: Pokemon[] = [];

  constructor() {
  }


  // static getPokemonList(success: Function) {
  //   let httpRequest = http.createHttp()
  //   httpRequest.request(BASE_URL, (err, data) => {
  //     if (!err) {
  //       let responseData: PokemonResponse = JSON.parse(data.result as string)
  //       let PokemonList: Pokemon[] = responseData.results
  //       success(PokemonList)
  //     } else {
  //       // 请求失败，处理错误信息
  //       console.log('Error: ' + err);
  //     }
  //   });
  // }
  async getPokemonList(): Promise<Pokemon[]> {
    // 返回一个 Promise 来确保异步请求的结果可以正确传递
    return new Promise<Pokemon[]>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(BASE_URL, (err, data) => {
        if (!err) {
          try {
            let responseData: PokemonResponse = JSON.parse(data.result as string)
            let pokemonList: Pokemon[] = responseData.results
            resolve(pokemonList); // 请求成功，返回 PokemonList
          } catch (error) {
            reject('Failed to parse response data'); // 捕获解析错误
          }
        } else {
          reject('Error: ' + err); // 请求失败，返回错误
        }
      });
    });
  }

  // static getPokemonInfo(index: number, success: Function, failure?: Function) {
  //   let httpRequest = http.createHttp();
  //   httpRequest.request(`https://pokeapi.co/api/v2/pokemon/${index + 1}/`, (err, data) => {
  //     if (!err) {
  //       try {
  //         // 尝试解析返回数据
  //         let responseData: PokeInfo = JSON.parse(data.result as string);
  //         success(responseData); // 成功时回调
  //       } catch (parseErr) {
  //         console.error('JSON Parse Error:', parseErr);
  //         if (failure) failure(parseErr); // 调用失败回调
  //       }
  //     } else {
  //       console.error('HTTP Error:', err);
  //       if (failure) failure(err); // 调用失败回调
  //     }
  //   });
  // }
  async getPokemonInfo(index: number): Promise<string[]> {
    return new Promise<string[]>((resolve, reject) => {
      let httpRequest = http.createHttp();
      httpRequest.request(`https://pokeapi.co/api/v2/pokemon/${index + 1}/`, (err, data) => {
        if (!err) {
          try {
            // 尝试解析返回数据
            let responseData: PokeInfo = JSON.parse(data.result as string);

            // 检查 types 是否存在
            if (responseData.types && Array.isArray(responseData.types)) {
              // 提取类型名称为 string[]
              let pokeTypes = responseData.types.map((type) => {
                return type.type?.name || 'Unknown'; // 如果类型不存在，返回 'Unknown'
              });

              resolve(pokeTypes); // 成功返回类型数组
            } else {
              console.warn('No types found in response');
              resolve(['Unknown']); // 如果 types 不存在，返回默认值
            }
          } catch (parseErr) {
            console.error('JSON Parse Error:', parseErr);
            reject(parseErr); // 解析失败，拒绝 Promise
          }
        } else {
          console.error('HTTP Error:', err);
          reject(err); // 请求失败，拒绝 Promise
        }
      });
    });
  }




  async fetchHttpCode(): Promise<number> {
    try {
      let httpRequest = http.createHttp();
      const response = await new Promise<number>((resolve, reject) => {
        httpRequest.request(BASE_URL, (err: Error, data: http.HttpResponse) => {
          if (!err) {
            resolve(data.responseCode);
          } else {
            reject(err);
          }
        });
      });
      return response; // 返回响应码
    } catch (error) {
      console.error('Error fetching HTTP code:', error);
      return -1; // 返回一个错误码
    }
  }
}

// Basic implementation of IDataSource to handle data listener
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: Pokemon[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): Pokemon {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

class MyDataSource extends BasicDataSource {
  private dataArray: Pokemon[] = []

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): Pokemon {
    return this.dataArray[index];
  }

  public addData(index: number, data: Pokemon): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Pokemon): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

export { BASE_URL, PokemonDataSource, MyDataSource }