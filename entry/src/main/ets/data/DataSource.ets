import { Pokemon, PokemonResponse } from '../Model/Pokemon';
import http from '@ohos.net.http';

//
// //Pokeapi default page with pokemon id 1 - 20
// const poke_server: string = "https://pokeapi.co/api/v2/pokemon"
//
// class DataSource {
//   public static allPokemonList: Pokemon[] = [];
//
//   constructor() {
//   }
//
//   static getPokemonNameList(success: Function, error: Function) {
//     let httpRequest = http.createHttp();
//     httpRequest.request(poke_server, {
//       method: http.RequestMethod.GET
//     }, (err, data) => {
//       if (!err && data.responseCode == 200) {
//         let dataJson = JSON.parse(data.result as string) as Object
//         success(dataJson);
//       } else {
//         console.info('error:' + JSON.stringify(err));
//         httpRequest.destroy();
//         error(err);
//       }
//     });
//   }
//
//   static getPokemonList(success: Function) {
//
//   }
//
//   async fetchHttpCode(): Promise<number> {
//     try {
//       let httpRequest = http.createHttp();
//       const response = await new Promise<number>((resolve, reject) => {
//         httpRequest.request(poke_server, (err: Error, data: http.HttpResponse) => {
//           if (!err) {
//             resolve(data.responseCode);
//           } else {
//             reject(err);
//           }
//         });
//       });
//       return response; // 返回响应码
//     } catch (error) {
//       console.error('Error fetching HTTP code:', error);
//       return -1; // 返回一个错误码
//     }
//   }
// }
//
// export { DataSource, poke_server }
const BASE_URL: string = "https://pokeapi.co/api/v2/pokemon"




class DataSource {
  public static PokemonList: Pokemon[] = [];

  constructor() {
  }

  static getPokemonList(success: Function) {
    let httpRequest = http.createHttp()
    httpRequest.request(BASE_URL, (err, data) => {
      if (!err) {
        let responseData: PokemonResponse = JSON.parse(data.result as string)
        let PokemonList: Pokemon[] = responseData.results
        console.log(`${PokemonList[0].name}`);
        success(PokemonList);
        // return PokemonList
      } else {
        // 请求失败，处理错误信息
        console.log('Error: ' + err);
      }
    });
    // return []
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

export {DataSource}