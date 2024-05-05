import { makeTile } from "utils";
import { Astronomy, WttrReport } from "./types";
import { DAY_WEATHER_ICONS, NIGHT_WEATHER_ICONS } from "./icons";

export function Weather() {
  let currentWeather = Variable(null as WttrReport | null);
  let lastUpdate: number | null = null;
  function updateWeather() {
    // only update if it's been longer than 10 minutes
    if (lastUpdate && Date.now() - lastUpdate < 600000) {
      return;
    }

    Utils.fetch("https://v2.wttr.in/?format=j1")
      .then((res) => res.json())
      .then((data: WttrReport) => {
        currentWeather.setValue(data);
        lastUpdate = Date.now();
      })
      .catch((e) => {
        console.error(e);
        currentWeather.setValue(null);
      });
  }

  // every minute, check if weather needs to be updated
  Utils.interval(60000, updateWeather);

  return makeTile(
    currentWeather.bind().as((weather) => {
      if (!weather) {
        return {
          icon: "",
          primary: "Unknown weather",
          secondary: "",
          visible: false,
        };
      }

      const icon = getIcon(
        weather.current_condition[0].weatherCode,
        weather.weather[0].astronomy[0],
      );
      const primary = weather.current_condition[0].temp_F + "°";
      const secondary = weather.current_condition[0].weatherDesc[0].value;

      return {
        icon,
        primary,
        secondary,
        visible: true,
      };
    }),
  );
}

function getIcon(code: string, sunTimes: Astronomy): string {
  if (isDark(sunTimes)) {
    return NIGHT_WEATHER_ICONS[code] || DAY_WEATHER_ICONS[code];
  } else {
    return DAY_WEATHER_ICONS[code];
  }
}

function parseTime(str: string): [number, number] {
  const [time, meridiem] = str.split(" ");
  let [hours, minutes] = time.split(":").map(Number);
  if (meridiem === "PM") {
    hours += 12;
  }
  return [hours, minutes];
}

function isDark(sunTimes: Astronomy): boolean {
  const [sunriseHours, sunriseMinutes] = parseTime(sunTimes.sunrise);
  const [sunsetHours, sunsetMinutes] = parseTime(sunTimes.sunset);
  const now = new Date();
  const currentHours = now.getHours();
  const currentMinutes = now.getMinutes();

  return (
    currentHours < sunriseHours ||
    currentHours > sunsetHours ||
    (currentHours === sunriseHours && currentMinutes < sunriseMinutes) ||
    (currentHours === sunsetHours && currentMinutes > sunsetMinutes)
  );
}
