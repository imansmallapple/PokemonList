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
  id: number,
  is_default: boolean,
  height: number,
  weight: number,
  name: string,
  types: PokeTypeContent[],
  abilities: AbilityInfo[],
}


class PokeInformation implements PokeInfo {
  is_default: boolean = false
  form_name: string = ''
  height: number = 0
  weight: number = 0
  id = 0
  name: string = ''
  types: PokeTypeContent[] = []
  abilities: AbilityInfo[] = []
}

interface AbilityInfo{
  ability: Ability
  is_hidden: boolean
  slot: number
}

// interface AbilityDetail{
//
// }

class Ability {
  name: string = ''
  url: string = ''
}

export { AbilityInfo, Ability, Pokemon, PokeInfo, PokemonResponse, PokeType, PokeInformation, PokeTypeContent }