import React from 'react'
import { useState } from "react"
import { FocusedInputShape, DayPickerRangeController } from "react-dates"

export default function DatePicker({ value, onChange }) {
  const [focus, setFocus] = useState<FocusedInputShape>('startDate')
  const handleFocus = (focus: null | FocusedInputShape) => {
    setFocus(focus || 'startDate')
  }

  return (
      <DayPickerRangeController
          hideKeyboardShortcutsPanel
          startDate={value.startDate}
          endDate={value.endDate}
          onDatesChange={onChange}
          focusedInput={focus}
          onFocusChange={handleFocus}
      />
  )
}
