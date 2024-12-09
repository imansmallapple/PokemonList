import router from '@ohos.router';

interface RouterParams {
  url: string
}

@Entry
@Component
struct AbilityDetail {
  @State url: string = ''

  onPageShow() {
    const params = router.getParams() as RouterParams
    this.url = params.url
  }

  aboutToAppear(): void {

  }

  build() {
    Row() {
      Column() {
          Text(`Url: ${this.url}`)
      }
      .width('100%')
    }
    .height('100%')
  }
}