import router from '@ohos.router';
import { PokemonDataSource } from '../data/DataSource';
import { EffectEntry, Language, Pokemon, PokemonData } from '../Model/AbilityEffect';
import { extractLastNumber } from '../utils/unitFormatConverter';

interface RouterParams {
  url: string,
  name: string
}


@Entry
@Component
struct AbilityDetail {
  @State url: string = ''
  @State abilityName: string = ''
  @State isLoading: boolean = false
  @State httpCode: number = 0
  private effectEntry: EffectEntry[] = []
  @State effectInfo: EffectEntry = new EffectEntry()
  private abilityPokemonData: PokemonData[] = []
  @State abilityPokemonList: Pokemon[] = []
  scroller: Scroller = new Scroller()

  onPageShow() {
    const params = router.getParams() as RouterParams
    this.url = params.url
    this.abilityName = params.name
  }

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
              console.info(item.pokemon.name)
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

  onBackPress(): boolean | void {
    router.back({
      url: 'pages/Index'
    })
  }

  build() {
    Column({ space: 20 }) {
      Row() {
        Text(`${this.abilityName}`)
          .fontSize(40)
          .fontWeight(800)
      }
      .margin({
        bottom: 20
      })

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