import router from '@ohos.router';
import { PokemonDataSource } from '../data/DataSource';
import { PokeInformation, Pokemon } from '../Model/Pokemon';
import { heightConverter, weightConverter } from '../utils/unitFormatConverter';
import { LoadComponent } from './Index'

export interface RouterParams {
  id: number;
  name: string;
  image: string;
}

@Entry
@Component
struct PokeDetail {
  @State pokeName: string = ''
  @State localParams: RouterParams | null = null;
  @State pokeId: number = 0
  @State isLoading: boolean = false
  @State httpCode: number = 0
  @State image: string = ''
  @State pokeInfo: PokeInformation = new PokeInformation()
  @State types: string[] = []

  onPageShow() {
    const params = router.getParams() as RouterParams
    this.localParams = params
    this.pokeName = params.name
    this.pokeId = params.id
    this.image = params.image
  }

  aboutToAppear() {
    this.isLoading = true;

    const source = new PokemonDataSource();

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code;

      if (code === 200) {
        try {
          // 异步获取宝可梦信息
          this.pokeInfo = await source.getPokemonInfo(this.pokeId - 1);

          // 提取类型名称并存储为字符串数组
          if (this.pokeInfo.types && Array.isArray(this.pokeInfo.types)) {
            this.types = this.pokeInfo.types.map((type) => {
              return type.type?.name || 'Unknown'; // 提取类型名称
            });
          }
        } catch (error) {
          console.error('Error fetching Pokémon info:', error);
        } finally {
          this.isLoading = false; // 确保加载状态正确更新
        }
      } else {
        this.isLoading = false; // 如果 HTTP 请求失败
        console.error('Failed to fetch data: HTTP Code', code);
      }
    });
  }

  @Builder
  NavigationTitle() {
    Column() {
      Text('Pokemon Data')
        .fontColor('#182431')
        .fontSize(26)
        .fontWeight(500)
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .height('100%')
    .width('100%')
  }

  @Builder
  PokemonTypes() {
    // 使用 forEach 遍历数组并渲染每个类型
    ForEach(this.types, (item: string) => {
      if (item == 'grass') {
        Text(`${item}`)
          .typeStyle(Color.Green, Color.White)
      }
      else if (item == 'poison') {
        Text(`${item}`)
          .typeStyle('#ff82139f', Color.White)
      }
      else if (item == 'flying') {
        Text(`${item}`)
          .typeStyle('#ffb8afb8')
      }
      else if (item == 'bug') {
        Text(`${item}`)
          .typeStyle('#ff1f7033', Color.White)
      }
      else if (item == 'fire') {
        Text(`${item}`)
          .typeStyle('#ffbe4110', Color.White)
      }
      else if (item == 'ice') {
        Text(`${item}`)
          .typeStyle('#ff69b4ea')
      }
      else if (item == 'ground') {
        Text(`${item}`)
          .typeStyle('#ff6b5326', Color.White)
      }
      else if (item == 'rock') {
        Text(`${item}`)
          .typeStyle('#ff726035', Color.White)
      }
      else if (item == 'water') {
        Text(`${item}`)
          .typeStyle('#ff0561ab', Color.White)
      }
      else if (item == 'electric') {
        Text(`${item}`)
          .typeStyle('#ffe7e434', Color.White)
      }
      else if (item == 'steel') {
        Text(`${item}`)
          .typeStyle('#ff82139f', Color.White)
      }
      else if (item == 'dragon') {
        Text(`${item}`)
          .typeStyle('#ff82139f', Color.White)
      }
      else if (item == 'normal') {
        Text(`${item}`)
          .typeStyle('#ff5f5d5f', Color.White)
      }
      else if (item == 'fairy') {
        Text(`${item}`)
          .typeStyle('#ffa72ca7', Color.White)
      }
      else if (item == 'fighting') {
        Text(`${item}`)
          .typeStyle('#ffb05804', Color.White)
      }
      else if (item == 'psychic') {
        Text(`${item}`)
          .typeStyle('#ffd42dd4', Color.White)
      }
      else if (item == 'ghost') {
        Text(`${item}`)
          .typeStyle('#ff660566', Color.White)
      }
    })
  }

  build() {
    Column() {
      Navigation()
        .title(this.NavigationTitle())
        .hideToolBar(true)
        .height(56)
        .width('100%')
        .titleMode(NavigationTitleMode.Mini)
        .hideBackButton(false)
      if (this.isLoading) {
        LoadComponent() // 显示加载组件
      }

      Row() {
        Column() {
          Image(this.image)
            .width(150)
            .height(150)
        }
        .justifyContent(FlexAlign.Center)
        .width('40%')
        .height('100%')

        Column({ space: 10 }) {
          Row() {
            Text(`${this.pokeName}`)
              .fontWeight(800)
              .fontSize(25)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)

          Row() {
            Text('No.')
              .labelStyle()
            Text(`${this.pokeId}`)
              .fontWeight(600)
          }
          .width('100%')

          Divider()
            .strokeWidth(1)

          Row() {
            Text('Type')
              .fontColor('#56000000')
              .fontWeight(700)
            this.PokemonTypes()
          }
          .width('100%')

          Divider()
            .strokeWidth(1)
          Row() {
            Text('Height')
              .labelStyle()
            Text(`${heightConverter(this.pokeInfo.height)} m`)
              .fontWeight(600)
          }
          .width('100%')

          Divider()
            .strokeWidth(1)
          Row() {
            Text('Weight')
              .labelStyle()
            Text(`${weightConverter(this.pokeInfo.weight)} kg`)
              .fontWeight(600)
          }
          .width('100%')

          Divider()
            .strokeWidth(1)
        }
        .width('60%')
        .height('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
      }
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .height('30%')
      .borderRadius(20)
      .borderWidth(1)
      .borderColor('#68645c5c')

    }
    .height('100%')
    .width('100%')
  }
}

@Extend(Text)
function typeStyle(backgroundColor: ResourceColor | string, fontColor?: ResourceColor | string) {
  .fontWeight(600)
  .margin({
    left: 10,
    right: 10
  })
  .fontColor(fontColor)
  .padding(10)
  .backgroundColor(backgroundColor)
  .borderRadius(10)
}

@Extend(Text)
function labelStyle() {
  .fontColor('#56000000')
  .width('40%')
  .fontWeight(700)
}