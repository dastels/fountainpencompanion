import * as React from "react";

import Row from "./row";

const InkTable = ({entries, stats}) => <div className="table-responsive">
  <table className="table table-striped ink-collection">
    <Header entries={entries} />
    <Body entries={entries} />
    <Footer {...stats} />
  </table>
</div>;

const Header = ({entries}) => <thead>
  <tr>
    <th></th>
    <th>Brand</th>
    <th>Line</th>
    <th>Name</th>
    <th>Type</th>
    <th>Color</th>
    <th>Swabbed</th>
    <th>Used</th>
    <th>Comment</th>
    <th>Actions</th>
  </tr>
</thead>;

const Body = ({entries}) => <tbody>
  { entries.map(entry => <Row {...entry.attributes} id={entry.id} key={entry.id}/>) }
</tbody>;

const Footer = ({brands, inks, bottles, samples, cartridges}) => <tfoot>
  <tr>
    <th></th>
    <th>{brands} brands</th>
    <th></th>
    <th>{inks} inks</th>
    <th>
      {bottles}x bottle
      <br />
      {samples}x sample
      <br />
      {cartridges}x cartridge
    </th>
    <th></th>
    <th></th>
    <th></th>
    <th></th>
    <th></th>
  </tr>
</tfoot>;

export default InkTable;
