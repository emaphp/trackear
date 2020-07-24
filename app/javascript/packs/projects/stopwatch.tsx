import React, { useEffect, useState } from "react";
import ReactDOM from "react-dom";
import moment from "moment"

function ActivityStopWatchTimer({ start }) {
  const [timer, setTimer] = useState(moment(start).fromNow())
  const [dots, setDots] = useState('')

  useEffect(() => {
    document.title = '⏰ ' + document.title
  }, [])

  useEffect(() => {
    const timer = setInterval(() => {
      setTimer(moment(start).fromNow())
    }, 1000)

    return () => {
      clearInterval(timer)
    }
  }, [])

  useEffect(() => {
    const timer = setInterval(() => {
      setDots((dots) => {
        if (dots.length === 3) {
          return ''
        } else {
          return dots + '.'
        }
      })
    }, 1000)

    return () => {
      clearInterval(timer)
    }
  }, [])

  return <span className="text-white">{timer}{dots}</span>
}

const element = document.getElementById('stopwatchTimer')
const start = moment(element.innerText)
ReactDOM.render(<ActivityStopWatchTimer start={start} />, element)
