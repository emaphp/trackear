import React from "react"
import moment from "moment"

const trackHours = (track) => moment(track.to).diff(moment(track.from), 'hours', true)

const calcHours = (entry) => entry.tracks.reduce(
  (hours, track) => hours + trackHours(track),
  0
)

const calcAmount = (entry) => entry.tracks.reduce(
  (amount, track) => {
    const safeProjectRate = track.project_rate ? track.project_rate : entry.contract.project_rate;
    return amount + (trackHours(track) * safeProjectRate)
  },
  0
)

const calcTotalHours = (entries) => entries.reduce(
  (totalHours, entry) => totalHours + calcHours(entry),
  0
)

const calcTotalAmount = (entries) => entries.reduce(
  (totalAmount, entry) => totalAmount + calcAmount(entry),
  0
)

const Table = ({ rows }) => (
  <table className="table table-striped border">
    <thead>
      <tr>
        <th scope="col">Team member</th>
        <th scope="col" className="text-right">Hours</th>
        <th scope="col" className="text-right">Amount</th>
      </tr>
    </thead>
    <tbody>
      {rows}
    </tbody>
  </table>
)

const Row = ({ entry }) => (
  <tr>
    <td>
      <img
        className="avatar mr-3"
        style={{ width: '28px' }}
        src={entry.user.picture}
      />
      {entry.user.first_name}
    </td>
    <td className="text-right">{calcHours(entry).toFixed(2)}hs</td>
    <td className="text-right">${calcAmount(entry).toFixed(2)}</td>
  </tr>
)

const TotalSummary = ({ entries }) => (
  <div className="text-right lead text-dark mt-3">
    Total
    {' '}
    <span className="font-weight-bold">
      {calcTotalHours(entries).toFixed(2)} hs,
      {' '}
      ${calcTotalAmount(entries).toFixed(2)}
    </span>
  </div>
)

const SelectDatesMessage = () => (
  <p className="text-center lead">
    Select a date range to display a summary of hours and amounts
  </p>
)

const Loading = () => (
  <div className="d-flex justify-content-center">
    <div className="spinner-border text-primary" role="status">
      <span className="sr-only">Loading...</span>
    </div>
  </div>
)

export default function Summary({ loading, entries }) {
  const emptyEntries = entries.length === 0
  const tableRows = entries.map((entry) => <Row key={entry.user.id} entry={entry} />)
  const table = <Table rows={tableRows} />
  const total = <TotalSummary entries={entries} />
  return (
      <div className="form-group">
          <h4 className="mb-2 font-weight-normal">Client summary</h4>
          <p>This is an approximation since team members can perform edits before confirming their invoices</p>
          {loading && <Loading />}
          {!loading && emptyEntries && <SelectDatesMessage />}
          {!loading && !emptyEntries && table}
          {!loading && !emptyEntries && total}
      </div>
  )
}
