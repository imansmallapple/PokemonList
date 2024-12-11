import router from '@ohos.router'
import { PokemonDataSource } from '../data/DataSource'
import { DamageRelations, TypeInfo } from '../Model/Type'

interface RouterParams {
  url: string,
  typeName: string
}

@Entry
@Component
struct TypeDetail {
  @State url: string = ''
  @State isLoading: boolean = false
  @State httpCode: number = 0
  @State typeName: string = ''
  @State damageRelation: DamageRelations = new DamageRelations()

  onPageShow() {
    const params = router.getParams() as RouterParams
    this.url = params.url
    this.typeName = params.typeName
  }

  aboutToAppear(): void {
    this.isLoading = true;

    const source = new PokemonDataSource();

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code;

      if (code === 200) {
        try {
          this.damageRelation = await source.getTypeDetail(this.url);
        }
        catch (error) {
          console.error('Error fetching Pokémon info:', error);
        } finally {
          this.isLoading = false; // 确保加载状态正确更新
        }
      } else {
        this.isLoading = false; // 如果 HTTP 请求失败
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })
  }

  @Builder
  NavigationTitle() {
    Column() {
      Text('Type')
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
  NavigationComponent() {
    Row() {
      Navigation()
        .title(this.NavigationTitle())
        .height(56)
        .width('50%')
        .titleMode(NavigationTitleMode.Mini)

      Row() {
        Image($r('app.media.home_icon'))
          .width(30)
          .margin({
            right: 20
          })
          .onClick(() => {
            router.clear()
            router.pushUrl({ url: 'pages/Index' })
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
      Row() {
        if (this.typeName == 'grass') {
          Text(`${this.typeName}`)
            .typeStyle(Color.Green, Color.White)
        }
        else if (this.typeName == 'poison') {
          Text(`${this.typeName}`)
            .typeStyle('#ff82139f', Color.White)
        }
        else if (this.typeName == 'flying') {
          Text(`${this.typeName}`)
            .typeStyle('#ffb8afb8')
        }
        else if (this.typeName == 'bug') {
          Text(`${this.typeName}`)
            .typeStyle('#ff1f7033', Color.White)
        }
        else if (this.typeName == 'fire') {
          Text(`${this.typeName}`)
            .typeStyle('#ffbe4110', Color.White)
        }
        else if (this.typeName == 'ice') {
          Text(`${this.typeName}`)
            .typeStyle('#ff69b4ea')
        }
        else if (this.typeName == 'ground') {
          Text(`${this.typeName}`)
            .typeStyle('#ff6b5326', Color.White)
        }
        else if (this.typeName == 'rock') {
          Text(`${this.typeName}`)
            .typeStyle('#ff726035', Color.White)
        }
        else if (this.typeName == 'water') {
          Text(`${this.typeName}`)
            .typeStyle('#ff0561ab', Color.White)
        }
        else if (this.typeName == 'electric') {
          Text(`${this.typeName}`)
            .typeStyle('#ffe7e434', Color.White)
        }
        else if (this.typeName == 'steel') {
          Text(`${this.typeName}`)
            .typeStyle('#ff82139f', Color.White)
        }
        else if (this.typeName == 'dragon') {
          Text(`${this.typeName}`)
            .typeStyle('#ff82139f', Color.White)
        }
        else if (this.typeName == 'normal') {
          Text(`${this.typeName}`)
            .typeStyle('#ff5f5d5f', Color.White)
        }
        else if (this.typeName == 'fairy') {
          Text(`${this.typeName}`)
            .typeStyle('#ffa72ca7', Color.White)
        }
        else if (this.typeName == 'fighting') {
          Text(`${this.typeName}`)
            .typeStyle('#ffb05804', Color.White)
        }
        else if (this.typeName == 'psychic') {
          Text(`${this.typeName}`)
            .typeStyle('#ffd42dd4', Color.White)
        }
        else if (this.typeName == 'ghost') {
          Text(`${this.typeName}`)
            .typeStyle('#ff660566', Color.White)
        }
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('10%')
      .borderRadius(20)
      .borderWidth(1)
      .borderColor('#68645c5c')

      Column({ space: 20 }) {
        Row({ space: 15 }) {
          Text('Attack')
            .fontWeight(600)
            .fontSize(25)
          Text('pros & cons')
            .fontSize(23)
            .fontWeight(600)
            .fontColor('#5e000000')

        }
        .width('100%')

        Column() {
          Row() {
            Text(`${this.typeName} moves are super-effective against:`)
              .fontSize(18)
          }
          .width('100%')

          Row({ space: 10 }) {
            ForEach(this.damageRelation.double_damage_from, (item: TypeInfo) => {
              Text(`${item.name}`)
            })
          }
        }

        Column() {
          Row() {
            Text(`${this.typeName} moves are not very effective against:`)
              .fontSize(18)
          }
          .width('100%')


          Row({ space: 10 }) {
            ForEach(this.damageRelation.double_damage_to, (item: TypeInfo) => {
              Text(`${item.name}`)
            })
          }
        }
      }
      .width('100%')
      .height('40%')

      Column() {
        Row({ space: 15 }) {
          Text('Defense')
            .fontWeight(600)
            .fontSize(25)
          Text('pros & cons')
            .fontSize(23)
            .fontWeight(600)
            .fontColor('#5e000000')

        }
        .width('100%')

        Column({space: 25}) {
          Column() {
            Row() {
              Text('moves are super-effective against:')
                .fontSize(18)
            }
            .width('100%')

            Row({ space: 10 }) {
              ForEach(this.damageRelation.double_damage_from, (item: TypeInfo) => {
                Text(`${item.name}`)
                  .fontSize(18)
              })
            }
          }

          Column() {
            Row() {
              Text('moves are super-effective against:')
            }
            .width('100%')

            Row({ space: 10 }) {
              ForEach(this.damageRelation.double_damage_from, (item: TypeInfo) => {
                Text(`${item.name}`)
              })
            }
          }

        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('40%')

    }
    .width('100%')
  }
}

@Extend(Text)
function typeStyle(backgroundColor: ResourceColor | string, fontColor?: ResourceColor | string) {
  .margin({
    left: 10,
    right: 10
  })
  .fontColor(fontColor)
  .padding(10)
  .backgroundColor(backgroundColor)
  .borderRadius(10)
  .fontSize(30)
  .fontWeight(800)
}