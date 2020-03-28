import {
  NEXT,
  PREVIOUS,
  SET_MICRO_CLUSTERS,
  UPDATE_SELECTED_BRANDS,
  REMOVE_MICRO_CLUSTER
} from "./actions";

export const initalState = {
  selectedBrands: [],
  microClusters: [],
  selectedMicroClusters: [],
  index: 0
};

export const reducer = (state, { type, payload }) => {
  let max, selectedBrands;
  switch (type) {
    case NEXT:
      max = state.selectedMicroClusters.length;
      return {
        ...state,
        index: state.index < max - 1 ? state.index + 1 : 0
      };
    case PREVIOUS:
      max = state.selectedMicroClusters.length;
      return {
        ...state,
        index: state.index > 0 ? state.index - 1 : max - 1
      };
    case REMOVE_MICRO_CLUSTER:
      const microClusters = withoutElement(payload, state.microClusters);
      let selectedMicroClusters = withoutElement(
        payload,
        state.selectedMicroClusters
      );
      if (selectedMicroClusters.length > 0) {
        selectedBrands = selectedBrands;
      } else {
        selectedBrands = [];
        selectedMicroClusters = microClusters;
      }
      return {
        ...state,
        microClusters,
        selectedMicroClusters,
        selectedBrands
      };
    case SET_MICRO_CLUSTERS:
      return {
        ...state,
        microClusters: payload,
        selectedMicroClusters: selectMicroClusters(
          state.selectedBrands,
          payload
        )
      };
    case UPDATE_SELECTED_BRANDS:
      selectedBrands = payload || [];
      return {
        ...state,
        selectedBrands,
        selectedMicroClusters: selectMicroClusters(
          selectedBrands,
          state.microClusters
        )
      };
    default:
      return state;
  }
};

const withoutElement = (element, clusters) => {
  return clusters.filter(c => !(c.id == element.id && c.type == element.type));
};

const selectMicroClusters = (selectedBrands, microClusters) => {
  if (selectedBrands.length) {
    const filtered = microClusters.filter(c =>
      selectedBrands.map(s => s.value).includes(c.simplified_brand_name)
    );
    return filtered.length ? filtered : microClusters;
  } else {
    return microClusters;
  }
};
