import router from '@ohos.router';
import { PokemonDataSource } from '../data/DataSource';
import { PokeInformation, Pokemon } from '../Model/Pokemon';
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
        //
        // //todo: get pokeInfo
        // this.pokeInfo = await source.getPokemonInfo(this.pokeId + 1)
        //
        // this.isLoading = false; // 加载完成
      } else {
        this.isLoading = false; // 如果 HTTP 请求失败
        console.error('Failed to fetch data: HTTP Code', code);
      }
    });
  }

  @Builder
  NavigationTitle() {
    Column() {
      Text(`${this.pokeName}`)
        .fontColor('#182431')
        .fontSize(26)
        .fontWeight(500)
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .height('100%')
    .width('100%')
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

      Text(`${this.pokeName}`)
      Text(`${this.pokeId}`)
      Image(this.image)
        .width(100)
      Text(`${this.pokeInfo.is_default}`)
      Text(`detail info: ${this.types}`)
    }
    .height('100%')
    .width('100%')
  }
}