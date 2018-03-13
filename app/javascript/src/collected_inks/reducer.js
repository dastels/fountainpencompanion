import {
  DATA_RECEIVED,
  FILTER_DATA,
  LOADING_DATA,
  UPDATE_FILTER,
} from "./actions";

const defaultState = {
  active: [],
  archived: [],
  entries: [],
  filters: {},
  loading: true,
};

export default function reducer(state = defaultState, action) {
  switch(action.type) {
    case DATA_RECEIVED:
      return filterData({
        ...state,
        entries: action.data,
        loading: false,
      });
    case FILTER_DATA:
      return filterData(state);
    case LOADING_DATA:
      return { ...state, loading: true};
    case UPDATE_FILTER:
      const newFilter = { ...state.filters[action.filterName]};
      newFilter[action.filterField] = action.filterValue;
      const newFilters = { ...state.filters };
      newFilters[action.filterName] = newFilter;
      return { ...state, filters: newFilters };
    default:
      return state;
  }
}

const filterData = (state) => ({
  ...state,
  active: activeEntries(state.entries, state.filters.active),
  archived: archivedEntries(state.entries, state.filters.archived)
});

const activeEntries = (data, filters) => {
  const entries = data.data.filter(entry => !entry.attributes.archived)
  const filteredEntries = filterEntries(entries, filters);
  sortInks(filteredEntries);
  return {
    entries: filteredEntries,
    stats: calculateStats(filteredEntries),
    brands: calculateListOfBrands(entries),
  };
}

const archivedEntries = (data, filters) => {
  const entries = data.data.filter(entry => entry.attributes.archived)
  const filteredEntries = filterEntries(entries, filters);
  sortInks(filteredEntries);
  return {
    entries: filteredEntries,
    stats: calculateStats(filteredEntries),
    brands: calculateListOfBrands(entries),
  };
}

const filterEntries = (entries, filter = {}) => {
  let filteredEntries = [...entries];
  Object.entries(filter).forEach(([key, value]) => {
    filteredEntries = filteredEntries.filter(entry => {
      if (value) {
        return entry.attributes[key] == value;
      } else {
        return true;
      }
    })
  })
  return filteredEntries;
}

function sortInks(inks) {
  inks.sort((a, b) => {
    const keya = ["brand_name", "line_name", "ink_name"].map(n => a.attributes[n]).join();
    const keyb = ["brand_name", "line_name", "ink_name"].map(n => b.attributes[n]).join();
    return keya.localeCompare(keyb);
  })
}

function calculateStats(inks) {
  const stats = {};
  stats.inks = inks.length;
  stats.bottles = inks.filter(ink => ink.attributes.kind == "bottle").length;
  stats.samples = inks.filter(ink => ink.attributes.kind == "sample").length;
  stats.cartridges = inks.filter(ink => ink.attributes.kind == "cartridge").length;
  stats.brands = (new Set(inks.map(ink => ink.attributes.brand_name))).size;
  return stats;
}

function calculateListOfBrands(inks) {
  const brands = [...(new Set(inks.map(ink => ink.attributes.brand_name)))];
  brands.sort()
  return ["", ...brands];
}
