import router from '@ohos.router';
import { PokemonDataSource } from '../data/DataSource';
import { Ability, AbilityInfo, PokeInformation, Pokemon, PokeType } from '../Model/Pokemon';
import { EvolutionChain, EvolutionData, Species } from '../Model/Revolution';
import { extractLastNumber, heightConverter, weightConverter } from '../utils/unitFormatConverter';
import { HttpErrorComponent, LoadComponent } from './Index'

AppStorage.setOrCreate<string>("url", '');
AppStorage.setOrCreate<string>("abilityName", '');

@Entry
@Component
struct PokeDetail {
  @State pokeName: string = AppStorage.get("pokeName") as string
  @State pokeId: number = AppStorage.get("pokeId") as number
  @State image: string = AppStorage.get("pokeImage") as string
  @State isLoading: boolean = false
  @State httpCode: number = 0
  @State pokeInfo: PokeInformation = new PokeInformation()
  @State types: PokeType[] = []
  @State abilities: AbilityInfo[] = []
  @State pokeEvolution: EvolutionData = new EvolutionData()
  @State abilityUrlList: string[] = []
  @State evolutionSpecies: Species[] = []
  private scroller: Scroller = new Scroller()
  @State source: string = ''

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
              return type.type as PokeType
            });
          }

          //Fetch Pokemon abilities
          if (Array.isArray(this.pokeInfo.abilities)) {
            this.abilities = this.pokeInfo.abilities
            //Get current Pokemon's all ability detail's url route
            this.abilities.forEach((item) => {
              this.abilityUrlList.push(item.ability.url)
            })
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
      Text('Pokemon')
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
    ForEach(this.types, (item: PokeType) => {
      Row(){
        if (item.name == 'grass') {
          Text(`${item.name}`)
            .typeStyle(Color.Green, Color.White)
        }
        else if (item.name == 'poison') {
          Text(`${item.name}`)
            .typeStyle('#ff82139f', Color.White)
        }
        else if (item.name == 'flying') {
          Text(`${item.name}`)
            .typeStyle('#ffb8afb8')
        }
        else if (item.name == 'bug') {
          Text(`${item.name}`)
            .typeStyle('#ff1f7033', Color.White)
        }
        else if (item.name == 'fire') {
          Text(`${item.name}`)
            .typeStyle('#ffbe4110', Color.White)
        }
        else if (item.name == 'ice') {
          Text(`${item.name}`)
            .typeStyle('#ff69b4ea')
        }
        else if (item.name == 'ground') {
          Text(`${item.name}`)
            .typeStyle('#ff6b5326', Color.White)
        }
        else if (item.name == 'rock') {
          Text(`${item.name}`)
            .typeStyle('#ff726035', Color.White)
        }
        else if (item.name == 'water') {
          Text(`${item.name}`)
            .typeStyle('#ff0561ab', Color.White)
        }
        else if (item.name == 'electric') {
          Text(`${item.name}`)
            .typeStyle('#ffe7e434', Color.White)
        }
        else if (item.name == 'steel') {
          Text(`${item.name}`)
            .typeStyle('#ff82139f', Color.White)
        }
        else if (item.name == 'dragon') {
          Text(`${item.name}`)
            .typeStyle('#ff82139f', Color.White)
        }
        else if (item.name == 'normal') {
          Text(`${item.name}`)
            .typeStyle('#ff5f5d5f', Color.White)
        }
        else if (item.name == 'fairy') {
          Text(`${item.name}`)
            .typeStyle('#ffa72ca7', Color.White)
        }
        else if (item.name == 'fighting') {
          Text(`${item.name}`)
            .typeStyle('#ffb05804', Color.White)
        }
        else if (item.name == 'psychic') {
          Text(`${item.name}`)
            .typeStyle('#ffd42dd4', Color.White)
        }
        else if (item.name == 'ghost') {
          Text(`${item.name}`)
            .typeStyle('#ff660566', Color.White)
        }
      }
      .onClick(()=>{
        // console.info(`Clicked:${item.url}`)
        router.pushUrl({url: 'pages/TypeDetail',
        params:{
          url: item.url,
          typeName: item.name
        }})
      })
    })
  }

  @Builder
  NavigationComponent(){
    Row(){
      Navigation()
        .title(this.NavigationTitle())
        .height(56)
        .width('50%')
        .titleMode(NavigationTitleMode.Mini)

      Row(){
        Image($r('app.media.home_icon'))
          .width(30)
          .margin({
            right: 20
          })
          .onClick(()=>{
            router.clear()
            router.pushUrl({url: 'pages/Index'})
          })

      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
  }

  build() {
    Column({ space: 10 }) {
      this.NavigationComponent()
      if (this.isLoading) {
        LoadComponent() // 显示加载组件
      }
      if (this.httpCode == -1) {
        HttpErrorComponent({
          text: 'Can\'t connect to the server'
        })
      }
      Scroll() {
        Column() {
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

            ForEach(this.abilities, (item: AbilityInfo, index: number) => {
              Row() {
                // Text(`index:${index}`)
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
              .onClick(() => {
                AppStorage.setOrCreate("url", this.abilityUrlList[index]);
                AppStorage.setOrCreate("name", item.ability.name);

                router.pushUrl({
                  url: 'pages/AbilityDetail',
                })
                // console.info(`Index:${index} clicked!`)
              })
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

            Scroll() {
              Row({ space: 5 }) {
                List({ scroller: this.scroller }) {
                  ForEach(this.evolutionSpecies, (item: Species) => {
                    ListItem() {
                      Column() {
                        Image(`https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${extractLastNumber(item.url)}.png`)// 显示图片
                          .width(80)// 设置图片宽度
                          .height(80) // 设置图片高度
                        Text(item.name)// 显示宝可梦名称
                          .fontSize(16)
                          .padding({ top: 5 });
                        Text(`No. ${extractLastNumber(item.url)}`)// 显示编号
                          .fontSize(14)
                          .fontColor('#666');
                      }
                      .margin({ left: 10, right: 10 }) // 每个宝可梦间距
                    }
                    .onClick(() => {
                      AppStorage.setOrCreate("pokeName", item.name);
                      AppStorage.setOrCreate("pokeId", extractLastNumber(item.url));
                      AppStorage.setOrCreate("pokeImage", `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${extractLastNumber(item.url)}.png`);
                      router.pushUrl({
                        url: 'pages/PokeDetail'
                      })
                    })
                  });
                }
                .height('20%')
                .listDirection(Axis.Horizontal)
              }
            }
            .width('100%')
          }
          .margin({
            top: 40
          })
        }
      }
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