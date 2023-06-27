using API_Test.Models;
using Microsoft.AspNetCore.Mvc;

namespace API_TEST.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherController : ControllerBase
    {
        private const string API_URL = "http://api.openweathermap.org/data/2.5/group?id=1580578,1581129,1581297,1581188,1587923&units=metric&appid=91b7466cc755db1a94caf6d86a9c788a";
        
        [HttpGet]
        public async Task<ActionResult> GetWeatherData()
        {
            var weatherData = await FetchWeatherData();
            var formattedWeatherData = FormatWeatherData(weatherData);

            return Ok(new
            {
                data = formattedWeatherData,
                message = "Current weather information of cities",
                statusCode = 200
            });
        }

        private async Task<ListCity> FetchWeatherData()
        {
            var httpClient = new HttpClient();
                var response = await httpClient.GetAsync(API_URL);
                response.EnsureSuccessStatusCode();
                return await response.Content.ReadFromJsonAsync<ListCity>();
        }

        private List<FormatWeatherData> FormatWeatherData(ListCity weatherData)
        {
            var formattedData = new List<FormatWeatherData>();

            foreach (var cityData in weatherData.list)
            {
                formattedData.Add(new FormatWeatherData
                {
                    cityId = cityData.id,
                    cityName = cityData.name,
                    weatherMain = cityData.weather[0].main,
                    weatherDescription = cityData.weather[0].description,
                    weatherIcon = $"http://openweathermap.org/img/wn/{cityData.weather[0].icon}@2x.png",
                    mainTemp = cityData.main.temp,
                    mainHumidity = cityData.main.humidity
                });
            }

            return formattedData;
        }
    }
}
