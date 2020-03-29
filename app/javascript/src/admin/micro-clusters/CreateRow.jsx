import React, { useContext, useEffect } from "react";
import _ from "lodash";
import { postRequest } from "src/fetch";
import { StateContext, DispatchContext } from "./App";
import { UPDATING, ADD_MACRO_CLUSTER } from "./actions";
import { assignCluster } from "./assignCluster";
import { keyDownListener } from "./keyDownListener";

export const CreateRow = ({ afterCreate }) => {
  const { updating, activeCluster } = useContext(StateContext);
  const dispatch = useContext(DispatchContext);
  const values = computeValues(activeCluster);
  const create = () => {
    createMacroClusterAndAssign(
      values,
      activeCluster.id,
      dispatch,
      afterCreate
    );
  };
  useEffect(() => {
    return keyDownListener(({ keyCode }) => {
      if (keyCode == 67) create();
      if (keyCode == 79) {
        const fullName = ["brand_name", "line_name", "ink_name"]
          .map(a => values[a])
          .join(" ");
        const url = `https://google.com/search?q=${encodeURIComponent(
          fullName
        )}`;
        window.open(url, "_blank");
      }
    });
  }, [activeCluster.id]);
  return (
    <tr>
      <th></th>
      <th>{values.brand_name}</th>
      <th>{values.line_name}</th>
      <th>{values.ink_name}</th>
      <th></th>
      <th></th>
      <th></th>
      <th>
        <input
          className="btn btn-default"
          type="submit"
          disabled={updating}
          value="Create"
          onClick={create}
        />
      </th>
    </tr>
  );
};

const computeValues = activeCluster => {
  const grouped = _.groupBy(activeCluster.collected_inks, ci =>
    ["brand_name", "line_name", "ink_name"].map(n => ci[n]).join(",")
  );
  const ci = _.maxBy(_.values(grouped), array => array.length)[0];
  return {
    brand_name: ci.brand_name,
    line_name: ci.line_name,
    ink_name: ci.ink_name
  };
};

const createMacroClusterAndAssign = (
  values,
  microClusterId,
  dispatch,
  afterCreate
) => {
  dispatch({ type: UPDATING });
  postRequest("/admins/macro_clusters.json", {
    data: {
      type: "macro_cluster",
      attributes: {
        ...values
      }
    }
  })
    .then(response => response.json())
    .then(json =>
      assignCluster(microClusterId, json.data.id).then(microCluster => {
        dispatch({
          type: ADD_MACRO_CLUSTER,
          payload: microCluster.macro_cluster
        });
        afterCreate(microCluster);
      })
    );
};
