// Tidepool: fetches NOAA tide predictions for one station and draws them on a canvas.
// TODO: let the user pick a station instead of hardcoding 8443970 (Boston)
// FIXME: the chart goes blank when the API returns an error object instead of predictions
const STATION = "8443970";
const URL = `https://api.tidesandcurrents.noaa.gov/api/prod/datagetter?product=predictions&datum=MLLW&station=${STATION}&date=today&units=english&time_zone=lst_ldt&format=json`;

fetch(URL)
  .then((r) => r.json())
  .then((data) => {
    const ctx = document.getElementById("chart").getContext("2d");
    const pts = data.predictions.map((p, i) => [i * 3, 280 - Number(p.v) * 20]);
    ctx.strokeStyle = "#5ec8f2";
    ctx.beginPath();
    pts.forEach(([x, y], i) => (i ? ctx.lineTo(x, y) : ctx.moveTo(x, y)));
    ctx.stroke();
  });
