import router from '@ohos.router';
import { PokemonDataSource } from '../data/DataSource';
import { EffectEntry, Language, Pokemon, PokemonData } from '../Model/AbilityEffect';
import { extractLastNumber } from '../utils/unitFormatConverter';
import { HttpErrorComponent, LoadComponent } from './Index';

interface RouterParams {
  url: string,
  name: string
}

@Entry
@Component
struct AbilityDetail {
  @State url: string = AppStorage.get("url") as string
  @State abilityName: string = AppStorage.get("abilityName") as string
  @State isLoading: boolean = false
  @State httpCode: number = 0
  private effectEntry: EffectEntry[] = []
  @State effectInfo: EffectEntry = new EffectEntry()
  private abilityPokemonData: PokemonData[] = []
  @State abilityPokemonList: Pokemon[] = []
  scroller: Scroller = new Scroller()
  @State pokeName: string = AppStorage.get("pokeName") as string
  @State pokeId: number = AppStorage.get("pokeId") as number
  @State image: string = AppStorage.get("pokeImage") as string

  // onPageShow() {
  //   const params = router.getParams() as RouterParams
  //   this.url = params.url
  //   this.abilityName = params.name
  // }

  aboutToAppear(): void {
    this.isLoading = true
    const source = new PokemonDataSource();
    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code
      if (code == 200) {
        try {
          this.effectEntry = await source.getAbilityInfo(this.url)
          this.abilityPokemonData = await source.getAbilityPokemon(this.url)

          if (Array.isArray(this.effectEntry)) {
            for (const item of this.effectEntry) {
              if (item.language?.name === 'en') {
                this.effectInfo.effect = item.effect;
                this.effectInfo.short_effect = item.short_effect;
                break;
              }
            }
          }

          if (Array.isArray(this.abilityPokemonData)) {
            for (const item of this.abilityPokemonData) {
              this.abilityPokemonList.push(item.pokemon)
              // console.info(item.pokemon.name)
            }
          }

          if (Array.isArray(this.effectEntry)) {

          }

          // console.info(`item: ${this.effectInfo.effect}`)
        }
        catch (error) {
          console.error('Error fetching Pokémon info:', error);
        }
        finally {
          this.isLoading = false;
        }
      } else {
        this.isLoading = false;
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })

  }
  @Builder
  NavigationTitle() {
    Column() {
      Text('Ability')
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
    Column({ space: 20 }) {
      this.NavigationComponent()
      if (this.isLoading) {
        LoadComponent() // 显示加载组件
      }
      if (this.httpCode == -1) {
        HttpErrorComponent({
          text: 'Can\'t connect to the server'
        })
      }
      Row() {
        Text(`${this.abilityName}`)
          .fontSize(40)
          .fontWeight(800)
      }

      Column() {
        Row() {
          Text('Effect')
            .fontWeight(600)
            .fontSize(25)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)


        Row() {
          Text(`${this.effectInfo.short_effect}`)
            .fontSize(20)
            .fontWeight(500)
        }
      }


      Column() {
        Row() {
          Text(`Pokémon with ${this.abilityName}`)
            .fontWeight(600)
            .fontSize(25)
        }
        .width('100%')

        Column() {
          Row({ space: 60 }) {
            Text('Image')
              .margin({
                left: 20
              })
              .fontSize(20)

            Text('Name')
              .fontSize(20)

            Text('ID')
              .fontSize(20)
              .margin({
                left: 50
              })
          }
          .width('100%')
          .height(40)

          List({ scroller: this.scroller }) {
            ForEach(this.abilityPokemonList, (item: Pokemon) => {
              ListItem() {
                Row({space: 30}) {
                  Image(`https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${extractLastNumber(item.url)}.png`)// 显示图片
                    .width(100)// 设置图片宽度
                    .height(100)

                  Text(`${item.name}`)
                    .fontWeight(600)
                    .fontSize(20)
                    .width(140)

                  Text(`${extractLastNumber(item.url)}`)
                    .fontSize(20)
                }
              }
              .onClick(()=>{
                AppStorage.setOrCreate("pokeName", item.name);
                AppStorage.setOrCreate("pokeId", extractLastNumber(item.url));
                AppStorage.setOrCreate("pokeImage", `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${extractLastNumber(item.url)}.png`);
                router.pushUrl({
                  url: 'pages/PokeDetail'
                })
              })
            })
          }
        }
        .width('100%')

      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}