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
  @State typeList: string[][] = []

  aboutToAppear() {
    this.isLoading = true;
    const source = new PokemonDataSource();

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code;

      if (code === 200) {
        await source.getPokemonList().then(async (list) => {
          this.pokeList = list;

          for (let index = 0; index < list.length; index++) {
            this.dataSet.pushData(list[index]);
          }

          // 设置图片 URL
          this.pokeList.forEach((item, index) => {
            this.pokeList[index].image = `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png`;
          });

          // 使用 Promise.all 处理所有异步任务
          const infoPromises = this.pokeList.map((item, index) =>
          source.getPokemonInfo(index).then((response) => {
            this.pokeList[index].detail = response;
          })
          );

          await Promise.all(infoPromises); // 等待所有异步任务完成

          // 打印每个宝可梦的类型
          this.pokeList.forEach((item, index) => {
            if (item.detail && item.detail.types) {
              const types = item.detail.types.map((type) => {
                if (type.type && type.type.name) {
                  return type.type.name; // 确保安全访问
                } else {
                  return 'Unknown';
                }
              });

              console.log(`Pokemon [${index}]:`, types.join(', '));
            } else {
              console.warn(`No types found for Pokemon [${index}]`);
            }
          });
        });
      } else {
        this.isLoading = false;
        console.error('Failed to fetch data: HTTP Code', code);
      }
    });
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
                  // Text(this.typeList[index]?.join(', ') || 'No types available')
                  Text(item.detail?.types?.map(type => type.type?.name).join(', '))
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