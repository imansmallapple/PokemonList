import router from '@ohos.router'
import { PokemonDataSource } from '../data/DataSource'
import { DamageRelations, TypeInfo } from '../Model/Type'
import { HttpErrorComponent, LoadComponent } from './Index'

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
  scroller: Scroller = new Scroller()

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

  @Builder
  ColorfulItem(item: TypeInfo) {
    Row() {
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
    .onClick(() => {
      // console.info(`Clicked:${item.url}`)
      router.replaceUrl({ url: 'pages/TypeDetail',
        params: {
          url: item.url,
          typeName: item.name
        } })
    })
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
      Row() {
        Text(this.typeName)
          .fontWeight(800)
          .fontSize(30)
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

          Row({ space: 2 }) {
            List({ scroller: this.scroller }) {
              ForEach(this.damageRelation.double_damage_to, (item: TypeInfo) => {
                ListItem() {
                  this.ColorfulItem(item)
                }
              })
            }
            .listDirection(Axis.Horizontal)
            .height('15%')
          }
        }

        Column() {
          Row() {
            Text(`${this.typeName} moves are not very effective against:`)
              .fontSize(18)
          }
          .width('100%')


          Row({ space: 2 }) {
            List({ scroller: this.scroller }) {
              ForEach(this.damageRelation.half_damage_to, (item: TypeInfo) => {
                ListItem() {
                  this.ColorfulItem(item)
                }
              })
            }
            .listDirection(Axis.Horizontal)
            .height('15%')
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

        Column({ space: 25 }) {
          Column() {
            Row() {
              Text(`These types are not very effective against ${this.typeName} Pokémon:`)
                .fontSize(18)
            }
            .width('100%')

            Row({ space: 2 }) {
              List({ scroller: this.scroller }) {
                ForEach(this.damageRelation.half_damage_from, (item: TypeInfo) => {
                  ListItem() {
                    this.ColorfulItem(item)
                  }
                })
              }
              .listDirection(Axis.Horizontal)
              .height('15%')
            }
          }

          Column() {
            Row() {
              Text(`These types are super-effective against ${this.typeName} Pokémon:`)
                .fontSize(18)

            }
            .width('100%')

            Row({ space: 2 }) {
              List({ scroller: this.scroller }) {
                ForEach(this.damageRelation.double_damage_from, (item: TypeInfo) => {
                  ListItem() {
                    this.ColorfulItem(item)
                  }
                })
              }
              .listDirection(Axis.Horizontal)
              .height('15%')
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
  .fontSize(15)
  .fontWeight(800)
}