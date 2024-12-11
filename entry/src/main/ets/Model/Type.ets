export interface PokemonTypeData {
  damage_relations: DamageRelations;
  game_indices: GameIndex[];
  generation: TypeInfo;
  id: number;
  move_damage_class: TypeInfo;
  moves: Move[];
  name: string;
  names: TypeName[];
  past_damage_relations: [];
  pokemon: PokemonEntry[];
  sprites: TypeSprites;
}

export class DamageRelations {
  double_damage_from: TypeInfo[] = [];
  double_damage_to: TypeInfo[] = [];
  half_damage_from: TypeInfo[] = [];
  half_damage_to: TypeInfo[] = [];
  no_damage_from: TypeInfo[] = [];
  no_damage_to: TypeInfo[] = [];
}


export interface TypeInfo {
  name: string;
  url: string;
}

export interface GameIndex {
  game_index: number;
  generation: TypeInfo;
}

export interface Move {
  name: string;
  url: string;
}

export interface TypeName {
  language: TypeInfo;
  name: string;
}

export interface PokemonEntry {
  pokemon: TypeInfo;
  slot: number;
}

export interface Sprite {
  name_icon: string;
}

export interface GenerationSprites {
  colosseum?: Sprite;
  emerald?: Sprite;
  firered_leafgreen?: Sprite;
  ruby_sapphire?: Sprite;
  xd?: Sprite;
  diamond_pearl?: Sprite;
  heartgold_soulsilver?: Sprite;
  platinum?: Sprite;
  black_white?: Sprite;
  black_2_white_2?: Sprite;
  omega_ruby_alpha_sapphire?: Sprite;
  x_y?: Sprite;
  sun_moon?: Sprite;
  ultra_sun_ultra_moon?: Sprite;
  sword_shield?: Sprite;
  brilliant_diamond_and_shining_pearl?: Sprite;
  legends_arceus?: Sprite;
  scarlet_violet?: Sprite;
}

export interface TypeSprites {
  generation_iii?: GenerationSprites;
  generation_iv?: GenerationSprites;
  generation_v?: GenerationSprites;
  generation_vi?: GenerationSprites;
  generation_vii?: GenerationSprites;
  generation_viii?: GenerationSprites;
  generation_ix?: GenerationSprites;
}
