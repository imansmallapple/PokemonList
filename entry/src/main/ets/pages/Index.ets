import { BASE_URL, PokemonDataSource, MyDataSource } from '../data/DataSource';
import { Pokemon, PokeInformation, PokeInfo, PokeTypeContent, PokeType } from '../Model/Pokemon';
import { BusinessError } from '@ohos.base';
import router from '@ohos.router';

AppStorage.setOrCreate<string>("pokeName", '');
AppStorage.setOrCreate<number>("PokeId", 0);
AppStorage.setOrCreate<string>("pokeImage", '');

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
        source.getPokemonType(index).then((types) => {
          this.typeList[index] = types; // 存储类型数组到二维数组 typeList
        })
        );

        await Promise.all(infoPromises); // 等待所有异步任务完成

        // 打印每个宝可梦的类型
        // this.typeList.forEach((types, index) => {
        //   console.log(`Pokemon [${index}]:`, types.join(', '));
        // });

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
        Row() {
          Text(`No.`)
            .margin({left: 20,right:60})
          Text('Image')
            .margin({right:60})
          Text('Name')
            .margin({right:60})
          Text('Type')
            .margin({right:30})
        }
        .width('100%')
        if (this.isLoading) {
          LoadComponent() // 显示加载组件
        }
        if (this.httpCode == -1) {
          HttpErrorComponent({
            text: 'Can\'t connect to the server'
          })
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
                    .width(50)
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
            .onClick(() => {
              // console.info(`item id: ${index+1}`)
              AppStorage.setOrCreate("pokeName", item.name);
              AppStorage.setOrCreate("pokeId", index + 1);
              AppStorage.setOrCreate("pokeImage", item.image);
              router.pushUrl({
                url: 'pages/PokeDetail',
              })
            })
          })
        }

        Text(`http:${this.httpCode}`)
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
export struct LoadComponent {
  build() {
    Column() {
      LoadingProgress()
        .color(Color.Blue)
        .width(50)
        .margin({ bottom: '10%' })
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

@Component
export struct HttpErrorComponent {
  @Prop text: string = ''

  build() {
    Column() {
      Column() {

        Image($r('app.media.ic_no_wifi'))
          .width('20%')
          .opacity(0.4)
        Text(this.text)
          .opacity(0.4)
          .margin(5)
      }
      .margin({
        bottom: '10%'
      })
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}