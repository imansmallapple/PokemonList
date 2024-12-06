import { BASE_URL, PokemonDataSource, MyDataSource } from '../data/DataSource';
import { Pokemon } from '../Model/Pokemon';

@Entry
@Component
struct Index {
  @State isLoading: boolean = false
  @State httpCode: number = 0
  @State pokeList: Pokemon[] = []
  @State pokeImage: string[] = []
  private scroller: Scroller = new Scroller()
  @State dataSet: MyDataSource = new MyDataSource()

  aboutToAppear() {
    this.isLoading = true;
    const source = new PokemonDataSource()
    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code; // 更新状态变量以触发 UI 的重新渲染
      if (code == 200) {
        PokemonDataSource.getPokemonList((data: Pokemon[]) => {
          this.pokeList = data
          // console.log(data.length.toString())
          for (let index = 0; index < data.length; index++) {
            this.dataSet.pushData(data[index])
          }
          this.pokeList.forEach((item, index: number) => {
            this.pokeImage[index] = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon' + `/${index + 1}.png`
            // console.log(this.pokeImage[index])
          });
        })


      }
      else {
        this.isLoading = false;
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
                  Image(this.pokeImage[index])
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