function heightConverter(height: number): string {
  return (height/10).toString()
}

function weightConverter(weight: number): string {
  return (weight/10).toString()
}

function extractLastNumber(url: string): number {
  const parts = url.split('/').filter((part) => part !== ''); // 按斜杠分割，并过滤掉空字符串
  const lastPart = parts[parts.length - 1]; // 获取最后一部分
  return parseInt(lastPart, 10); // 转换为数字并返回
}

export { heightConverter, weightConverter, extractLastNumber }


