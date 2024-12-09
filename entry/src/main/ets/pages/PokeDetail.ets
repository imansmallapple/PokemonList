import router from '@ohos.router';
import { PokemonDataSource } from '../data/DataSource';
import { Ability, AbilityInfo, PokeInformation, Pokemon } from '../Model/Pokemon';
import { EvolutionChain, EvolutionData, Species } from '../Model/Revolution';
import { extractLastNumber, heightConverter, weightConverter } from '../utils/unitFormatConverter';
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
  @State abilities: AbilityInfo[] = []
  @State pokeEvolution: EvolutionData = new EvolutionData()
  @State evolutionSpecies: Species[] = []

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

          //Get evolution chain url
          const url: string = await source.getEvolutionUrl(this.pokeId)

          // 异步获取宝可梦进化链
          this.pokeEvolution = await source.getEvolutionChain(url);


          // console.info(`url: ${url}`)
          // 提取进化链物种名称
          this.evolutionSpecies = this.extractSpeciesNames(this.pokeEvolution.chain as EvolutionChain)
          // 提取类型名称并存储为字符串数组
          if (Array.isArray(this.pokeInfo.types)) {
            this.types = this.pokeInfo.types.map((type) => {
              return type.type?.name || 'Unknown'; // 提取类型名称
            });
          }

          //Fetch Pokemon abilities
          if (Array.isArray(this.pokeInfo.abilities)) {
            this.abilities = this.pokeInfo.abilities
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

  // 提取物种名称的递归方法
  extractSpeciesNames(chain: EvolutionChain, result: Species[] = []): Species[] {
    result.push({
      name: chain.species.name,
      url: chain.species.url
    });
    chain.evolves_to.forEach((nextChain) => {
      this.extractSpeciesNames(nextChain, result);
    });
    return result;
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
    Column({ space: 10 }) {
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

      Column({ space: 5 }) {
        Row() {
          Text("Abilities")
            .fontWeight(600)
            .fontSize(20)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        ForEach(this.abilities, (item: AbilityInfo) => {
          Row() {
            if (item.is_hidden == true) {
              Text(`${item.ability.name} `)
                .fontWeight(500)
                .fontSize(18)
              Text('(Hidden Ability)')
                .fontColor('#3c000000')
                .fontWeight(500)
                .fontSize(18)
            }
            else {
              Text(`${item.ability.name}`)
                .fontWeight(500)
                .fontSize(18)
            }
          }
          .margin(10)
          .width('100%')
        })
      }
      .width('100%')
      .borderWidth(1)

      Column({ space: 5 }) {
        Row() {
          Text("Evolution Chart")
            .fontWeight(600)
            .fontSize(20)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        Row({ space: 5 }) {
          ForEach(this.evolutionSpecies, (item: Species) => {
            Column() {
              Image(`https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${extractLastNumber(item.url)}.png`) // 显示图片
                .width(80)    // 设置图片宽度
                .height(80)   // 设置图片高度
              Text(item.name) // 显示宝可梦名称
                .fontSize(16)
                .padding({ top: 5 });
              Text(`No. ${extractLastNumber(item.url)}`) // 显示编号
                .fontSize(14)
                .fontColor('#666');
            }
            .margin({ left: 10, right: 10 }) // 每个宝可梦间距
          });

        }
      }
      .width('100%')

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