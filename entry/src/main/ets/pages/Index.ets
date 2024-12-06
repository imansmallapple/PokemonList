import { BASE_URL, PokemonDataSource, MyDataSource } from '../data/DataSource';
import { Pokemon, PokeInfo, PokeTypeContent, PokeType } from '../Model/Pokemon';
import { BusinessError } from '@ohos.base';

@Entry
@Component
struct Index {
  @State isLoading: boolean = false
  @State httpCode: number = 0
  @State pokeList: Pokemon[] = []
  @State pokeImage: string[] = []
  @State pokeType: string[] = []
  private scroller: Scroller = new Scroller()
  @State dataSet: MyDataSource = new MyDataSource()
  @State pokeInfo: PokeInfo[] = []
  @State typeList: PokeTypeContent[][] = []

  aboutToAppear() {
    this.isLoading = true;
    const source = new PokemonDataSource()
    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code;
      //网络连接成功
      if (code == 200) {
        PokemonDataSource.getPokemonList((data: Pokemon[]) => {
          this.pokeList = data

          //数据源填充数据
          for (let index = 0; index < data.length; index++) {
            this.dataSet.pushData(data[index])
          }

          // 异步加载列表详细信息
          // const promises = this.pokeList.map((item, index) =>
          // new Promise<void>((resolve) => {
          //   PokemonDataSource.getPokemonInfo(
          //     index,
          //     (info: PokeInfo) => {
          //       // 确保 `info` 和 `info.types` 存在
          //       if (info && info.types) {
          //         this.pokeList[index].detail = info;
          //         this.pokeList[index].type = info.types.map((typeObj: PokeTypeContent): PokeType => ({
          //           name: typeObj.type?.name || 'Unknown', // 安全访问类型名称
          //           url: typeObj.type?.url || '', // 安全访问类型 URL
          //         }));
          //         console.log(`Pokemon [${index}]:`, {
          //           name: this.pokeList[index].name,
          //           image: this.pokeList[index].image,
          //           types: this.pokeList[index].type,
          //         });
          //       } else {
          //         console.warn(`No detail or types for index ${index}`);
          //       }
          //       resolve(); // 完成当前 Promise
          //     },
          //     (error: BusinessError) => {
          //       console.error(`Error fetching data for index ${index}:`, error);
          //       resolve(); // 即使失败也完成 Promise，防止阻塞
          //     }
          //   );
          // })
          // );

          this.pokeList.forEach((item, index: number) => {
            this.pokeList[index].image = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon' + `/${index + 1}.png`
            PokemonDataSource.getPokemonInfo(index, (data: PokeInfo) => {
              this.pokeList[index].detail = data
              // console.log(`${this.pokeList[index].detail.types[0].type.name}`)
              // this.pokeInfo[index] = data
              // item.type = this.pokeList[index].detail.types as PokeTypeContent[]
              // 确保 detail 和 types 存在再访问

              const types = this.pokeList[index].detail?.types;
              if (types && types.length > 0) {
                // this.pokeList[index].type.length = types.length

                console.log(`type length: ${types.length}`)
                // console.log('pokodata:' + types[0].type.name);
              } else {
                console.warn(`No types found for index ${index}`);
              }
            },
              (error: BusinessError) => {
                console.error(`Error fetching data for index ${index}:`, error);
              })
          });
        })
      }
      else {
        this.isLoading = false;
      }
    })
  }

  build() {
    Row() {
      Column() {
        Row({ space: 60 }) {
          Text(`No.`)
          Text('Image')
          Text('Name')
          Text('Type')
        }

        List({ scroller: this.scroller }) {
          LazyForEach(this.dataSet, (item: Pokemon, index: number) => {
            ListItem() {
              Row({ space: 20 }) {
                Row() {
                  Text(`${index + 1}`)
                }
                .width(50)
                .margin({
                  left: 30
                })

                Row() {
                  Image(item.image)
                    .width(40)
                }
                .width(50)

                Row() {
                  Text(item.name)
                }
                .width(90)
                .margin({
                  left: 30
                })

                Row() {
                  // Text(item.detail.name)

                }
                .layoutWeight(1)
              }
              .width('100%')
              .height('8%')
              .justifyContent(FlexAlign.Start)
            }
          })
        }

        Text(`http:${this.httpCode}`)
      }
      .width('100%')
    }
    .height('100%')
  }
}