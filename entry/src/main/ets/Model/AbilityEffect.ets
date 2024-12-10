// Interface for language information
import { Pokemon } from './Pokemon';

interface Language {
  name: string;
  url: string;
}

interface Version {
  name: string;
  url: string;
}

class EffectEntry{
  language?: Language;
  effect: string = ''
  short_effect: string = ''
}
// Interface for flavor text entries
interface FlavorTextEntry {
  flavor_text: string;
  language: Language;
  version_group: Version;
}

// Interface for generation information
interface Generation {
  name: string;
  url: string;
}

// Interface for name translations
interface TranslatedName {
  language: Language;
  name: string;
}

// Interface for Pokémon data in the "pokemon" field
interface PokemonData {
  is_hidden: boolean;
  pokemon: Pokemon; // Only have 'name' and 'url'
  slot: number;
}

interface EffectChangeData {
  effect: string;
  language?: Language;
  short_effect: string;
}

// Root interface for the ability data
interface AbilityData {
  effect_changes: EffectChangeData[]; // Assuming effect_changes is not defined in this JSON
  effect_entries: EffectEntry[];
  flavor_text_entries: FlavorTextEntry[];
  generation: Generation;
  id: number;
  is_main_series: boolean;
  name: string;
  names: TranslatedName[];
  pokemon: PokemonData[];
}

export { AbilityData,
  EffectEntry,
  EffectChangeData,
  Pokemon,
  Language,
  Version,
  FlavorTextEntry,
  Generation,
  TranslatedName,
  PokemonData }