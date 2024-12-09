interface Pokemon {
  name: string,
  url: string,
  detail?: PokeInfo,
  type?: string[],
  image: string,
}

interface PokemonResponse {
  count: number;
  next: string | null;
  previous: string | null;
  results: Pokemon[];
}

interface PokeType {
  name: string,
  url: string,
}

interface PokeTypeContent {
  slot?: number,
  type?: PokeType,
}

interface Sprites {
  back_default?: string,
  back_female?: string,
  back_shiny?: string,
  back_shiny_female?: string,
  front_default?: string,
  front_female?: string,
  front_shiny?: string,
  front_shiny_female?: string,
}

interface VersionGroup {
  name?: string,
  url?: string,
}

interface PokeInfo {
  form_name?: string,
  form_names?: string[],
  form_order?: number,
  id: number,
  is_battle_only: boolean,
  is_default: boolean,
  is_mega: boolean,
  name: string,
  names?: string[],
  order?: number,
  pokemon?: Pokemon,
  sprites?: Sprites,
  types?: PokeTypeContent[],
  version_group?: VersionGroup,
}


class PokeInformation implements PokeInfo {
  form_name: string = ''
  form_names: string[] = []
  form_order = 0
  id = 0
  is_battle_only = false
  is_default = false
  is_mega = false
  name: string = ''
  names: string[] = []
  order = 0
  types?: PokeTypeContent[] = []
}

export { Pokemon, PokeInfo, PokemonResponse, PokeType, PokeInformation, PokeTypeContent }