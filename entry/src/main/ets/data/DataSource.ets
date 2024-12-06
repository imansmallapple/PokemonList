import { Pokemon, PokemonResponse } from '../Model/Pokemon';
import http from '@ohos.net.http';

const BASE_URL: string = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=1302"

class PokemonDataSource {
  public static PokemonList: Pokemon[] = [];
  constructor() {
  }

  static getPokemonList(success: Function) {
    let httpRequest = http.createHttp()
    httpRequest.request(BASE_URL, (err, data) => {
      if (!err) {
        let responseData: PokemonResponse = JSON.parse(data.result as string)
        let PokemonList: Pokemon[] = responseData.results
        success(PokemonList)
      } else {
        // 请求失败，处理错误信息
        console.log('Error: ' + err);
      }
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

export {BASE_URL, PokemonDataSource}