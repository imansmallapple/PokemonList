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
        // 获取宝可梦列表
        const list = await source.getPokemonList();
        this.pokeList = list;

        // 初始化数据和图片 URL
        this.pokeList.forEach((item, index) => {
          this.dataSet.pushData(item);
          this.pokeList[index].image = `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png`;
        });

        // 获取每个宝可梦的类型，并存储到 typeList
        const infoPromises = this.pokeList.map((item, index) =>
        source.getPokemonInfo(index).then((types) => {
          this.typeList[index] = types; // 存储类型数组到二维数组 typeList
        })
        );

        await Promise.all(infoPromises); // 等待所有异步任务完成

        // 打印每个宝可梦的类型
        this.typeList.forEach((types, index) => {
          console.log(`Pokemon [${index}]:`, types.join(', '));
        });

        this.isLoading = false; // 加载完成
      } else {
        this.isLoading = false; // 如果 HTTP 请求失败
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
        // todo: 在渲染数据的时候增加一秒延迟的页面让其缓冲
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
                  left: 20
                })

                Row() {
                  Text(this.typeList[index]?.join(', ') || 'No types available')
                  // Text(item.detail?.types?.map(type => type.type?.name).join(', '))
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