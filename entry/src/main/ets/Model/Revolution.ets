// interface EvolutionTrigger {
//   name: string;
//   url: string;
// }
//
// interface EvolutionDetail {
//   gender: number | null;
//   held_item: string | null;
//   item: string | null;
//   known_move: string | null;
//   known_move_type: string | null;
//   location: string | null;
//   min_affection: number | null;
//   min_beauty: number | null;
//   min_happiness: number | null;
//   min_level: number | null;
//   needs_overworld_rain: boolean;
//   party_species: string | null;
//   party_type: string | null;
//   relative_physical_stats: number | null;
//   time_of_day: string;
//   trade_species: string | null;
//   trigger: EvolutionTrigger | null;
//   turn_upside_down: boolean;
// }
//
// interface Species {
//   name: string;
//   url: string;
// }
//
// interface EvolutionChain {
//   evolution_details: EvolutionDetail[];
//   evolves_to: EvolutionChain[];
//   is_baby: boolean;
//   species: Species;
// }
//
// interface EvolutionData {
//   baby_trigger_item: string | null;
//   chain: EvolutionChain;
//   id: number;
// }

interface PokemonSpecies {
  evolution_chain: EvolutionChainUrl;
}

interface EvolutionChainUrl {
  url: string;
}

class Species {
  name: string;
  url: string;

  constructor(name: string, url: string) {
    this.name = name;
    this.url = url;
  }
}

class EvolutionChain {
  evolution_details: EvolutionDetail[];
  evolves_to: EvolutionChain[];
  is_baby: boolean;
  species: Species;

  constructor(
    evolution_details: EvolutionDetail[],
    evolves_to: EvolutionChain[],
    is_baby: boolean,
    species: Species
  ) {
    this.evolution_details = evolution_details;
    this.evolves_to = evolves_to;
    this.is_baby = is_baby;
    this.species = species;
  }

  // 提取当前链的所有物种名称
  getSpeciesNames(): string[] {
    const names: string[] = [this.species.name];
    this.evolves_to.forEach((chain) => {
      names.push(...chain.getSpeciesNames());
    });
    return names;
  }
}

class EvolutionData {
  baby_trigger_item: string | null = ''
  chain?: EvolutionChain;
  id: number = 0
}

class EvolutionTrigger {
  name: string;
  url: string;

  constructor(name: string, url: string) {
    this.name = name;
    this.url = url;
  }
}


class EvolutionDetail {
  gender: number | null;
  held_item: string | null;
  item: string | null;
  known_move: string | null;
  known_move_type: string | null;
  location: string | null;
  min_affection: number | null;
  min_beauty: number | null;
  min_happiness: number | null;
  min_level: number | null;
  needs_overworld_rain: boolean;
  party_species: string | null;
  party_type: string | null;
  relative_physical_stats: number | null;
  time_of_day: string;
  trade_species: string | null;
  trigger: EvolutionTrigger | null;
  turn_upside_down: boolean;

  constructor(
    gender: number | null,
    held_item: string | null,
    item: string | null,
    known_move: string | null,
    known_move_type: string | null,
    location: string | null,
    min_affection: number | null,
    min_beauty: number | null,
    min_happiness: number | null,
    min_level: number | null,
    needs_overworld_rain: boolean,
    party_species: string | null,
    party_type: string | null,
    relative_physical_stats: number | null,
    time_of_day: string,
    trade_species: string | null,
    trigger: EvolutionTrigger | null,
    turn_upside_down: boolean
  ) {
    this.gender = gender;
    this.held_item = held_item;
    this.item = item;
    this.known_move = known_move;
    this.known_move_type = known_move_type;
    this.location = location;
    this.min_affection = min_affection;
    this.min_beauty = min_beauty;
    this.min_happiness = min_happiness;
    this.min_level = min_level;
    this.needs_overworld_rain = needs_overworld_rain;
    this.party_species = party_species;
    this.party_type = party_type;
    this.relative_physical_stats = relative_physical_stats;
    this.time_of_day = time_of_day;
    this.trade_species = trade_species;
    this.trigger = trigger;
    this.turn_upside_down = turn_upside_down;
  }
}

export { PokemonSpecies, EvolutionChainUrl, EvolutionTrigger, EvolutionDetail, EvolutionChain, EvolutionData, Species }