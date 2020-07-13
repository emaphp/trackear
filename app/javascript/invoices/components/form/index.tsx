import React, { useState, useEffect } from "react";
import * as Rails from "@rails/ujs"
import axios from "axios"
import * as yup from "yup"
import { useForm, Controller } from "react-hook-form"
import Summary from "../summary";
import DatePicker from "../date_picker";

const getSummary = ({ projectId, startDate, endDate }) => {
  const service = `/projects/${projectId}/status_period.json`
  const payload = {
    params: {
      start_date: startDate,
      end_date: endDate
    }
  }

  return axios.get(service, payload)
}

const createInvoice = ({ projectId, startDate, endDate }) => {
  const token = Rails.csrfToken()
  const service = `/projects/${projectId}/invoices.json`
  const payload = {
    from: startDate,
    to: endDate,
  }

  return axios.post(service, { authenticity_token: token, invoice: payload })
}

const schema = yup.object({
  date: yup.object({
    startDate: yup.object(),
    endDate: yup.object()
  })
})

export default function InvoiceForm({ projectId }) {
  const { formState, watch, control, handleSubmit, errors } = useForm({
    mode: 'onChange',
    validationSchema: schema,
    defaultValues: {
      date: { startDate: null, endDate: null }
    }
  });
  const [summary, setSummary] = useState({ loading: false, entries: [] })
  const [isCreatingInvoice, setIsCreatingInvoice] = useState(false)
  const date = watch("date")

  const onSubmit = ({ date }) => {
    setIsCreatingInvoice(true)
    createInvoice({ projectId, ...date }).then(({ data }) => {
      window.location.replace(data);
    })
  }

  const onCancel = () => {
    window.location.replace(`/projects/${projectId}`);
  }

  useEffect(() => {
      if (!date.startDate) return
      if (!date.endDate) return

      const payload = {
        projectId,
        ...date
      }

      setSummary({ ...summary, loading: true })
      getSummary(payload).then(({ data }) => setSummary({ entries: data, loading: false }))
  }, [date])

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <div className="row">
        <div className="col-lg-5 mb-4">
          <Controller
            as={DatePicker}
            control={control}
            name="date"
          />
          {errors && errors.date && <p className="text-danger">Make sure to select both dates (start and ending)</p>}
        </div>
        <div className="col-lg-7">
          <Summary
            loading={summary.loading}
            entries={summary.entries}
          />
        </div>
      </div>
      <div className="text-right mt-4">
        <button
          type="button"
          className="btn btn-link"
          disabled={isCreatingInvoice}
          onClick={onCancel}
        >
          Cancel
        </button>
        <button
          type="submit"
          className="btn btn-primary"
          disabled={!formState.isValid || isCreatingInvoice}
        >
          {isCreatingInvoice && <span className="spinner-border spinner-border-sm align-middle mr-2" role="status" aria-hidden="true"></span>}
          Create invoice
        </button>
      </div>
    </form>
  )
}
