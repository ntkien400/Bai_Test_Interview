using API_TEST.Controllers;

namespace API_Test.Models
{
    public class CityData
    {
        public int id { get; set; }
        public string name { get; set; }
        public List<WeatherData> weather { get; set; }
        public MainData main { get; set; }
    }
}
