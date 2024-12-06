import {  DataSource } from '../data/DataSource';
import { Pokemon } from '../Model/Pokemon';

@Entry
@Component
struct Index {
  @State isLoading: boolean = false
  @State httpCode: number = 0
  @State pokeList: Pokemon[] = []

  aboutToAppear() {
    this.isLoading = true;
    const source = new DataSource()
    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code; // 更新状态变量以触发 UI 的重新渲染
      if (code == 200) {
        DataSource.getPokemonList((data: Pokemon[])=>{
          this.pokeList = data
        })
      }
      else {
        this.isLoading = false;
      }
    });
  }

  build() {
    Row() {
      Column() {
        ForEach(this.pokeList,(item:Pokemon)=>{
          Text(item.name)
        })
        Text(`http:${this.httpCode}`)
      }
      .width('100%')
    }
    .height('100%')
  }
}