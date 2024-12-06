interface Pokemon {
  name: string,
  url: string,
}

interface PokemonResponse {
  count: number;
  next: string | null;
  previous: string | null;
  results: Pokemon[];
}

export { Pokemon, PokemonResponse }