# Project Context: Morocco Travel App

Tài liệu này giúp các session AI sau tiếp tục làm việc ngay với trạng thái hiện tại của app.

## Project Overview
- Objective: Flutter travel/weather app cho Morocco, dựng từ Google Stitch.
- Current phase: UI foundation và screen structure đã được dựng xong bằng dữ liệu static.
- Tech stack: Flutter 3.41.x, Material 3, không dùng `google_fonts` ở trạng thái hiện tại để tránh friction môi trường local.
- Stitch project: https://stitch.withgoogle.com/projects/9741568232095887806
- Local skill to follow: `.agent/skills/skill.md` (`Google Stitch-to-Flutter UI Integrator`).

## Design Source
- Stitch là nguồn thiết kế chính cho project này.
- Rule bắt buộc: khi cần đọc hoặc kiểm tra Stitch project/link Stitch cho project này, luôn ưu tiên MCP workflow (`mcp__stitch__`) thay vì đọc link bằng web request thông thường.
- Rule mở rộng cho các project travel khác dùng Stitch: cũng áp dụng nguyên tắc trên; chỉ dùng HTML export, screenshot local, hoặc web fallback khi MCP không truy cập được.
- Trong session hiện tại đã đọc Stitch project và lấy HTML tham chiếu cho các màn:
  - `tmp/home.html`
  - `tmp/cities.html`
  - `tmp/tips.html`
- `tmp/weather_detail.html`
- `tmp/tip_detail.html`
- `tmp/tip_packing.html`
- `tmp/tip_currency.html`
- `tmp/tip_culture.html`
- `tmp/tip_seasons.html`
- HTML được dùng để suy ra hierarchy, nội dung, và pattern layout; app Flutter hiện không render HTML trực tiếp.

## Current Architecture
- `lib/main.dart`: app root, mở `MainScreen`.
- `lib/screens/main_screen.dart`: owner của bottom navigation và `PageView`.
- `lib/screens/home_screen.dart`: màn home Morocco.
- `lib/screens/tourist_cities_screen.dart`: danh sách city, giữ embedded detail flow.
- `lib/screens/city_detail_screen.dart`: detailed weather/city screen.
- `lib/screens/travel_tips_screen.dart`: tips list và embedded article detail.
- `lib/widgets/common/app_header.dart`: header dùng chung.
- `lib/widgets/common/app_bottom_bar.dart`: bottom bar dùng chung.
- `lib/widgets/home/weather_card.dart`: hero weather card cho home.
- `lib/widgets/home/forecast_card.dart`: daily forecast row item.
- `lib/theme/`: app colors, text styles, theme.
- `lib/data/travel_data.dart`: toàn bộ model và static content hiện tại.

## Navigation Rules
- Giữ bottom bar ở `MainScreen` duy nhất.
- Tab structure hiện tại:
  1. `Weather`
  2. `Cities`
  3. `Tips`
- Muốn chuyển tab từ child widget:
  `context.findAncestorStateOfType<MainScreenState>()?.setSelectedIndex(index)`
- `TouristCitiesScreen` quản lý detail theo kiểu embedded:
  - mặc định là city list,
  - chọn city thì render `CityDetailScreen` bên trong tab.
- `TravelTipsScreen` cũng quản lý embedded detail tương tự:
  - list tips,
  - chọn tip thì mở article detail ngay trong tab.

## Current UI State
- Home screen đã có:
  - header text-only `MOROCCO TRAVEL`,
  - large hero weather card cho Casablanca,
  - 2 insight cards,
  - `5-Day Outlook`,
  - 2 quick actions: `Explore Cities`, `Travel Tips`.
- Tourist Cities screen đã có:
  - intro copy,
  - city cards cho Casablanca, Marrakech, Fes, Chefchaouen, Essaouira,
  - embedded detail flow khi chọn city.
- City detail screen đã có:
  - hero section,
  - horizontal hourly forecast,
  - metric grid,
  - sunrise/sunset panel.
- Travel Tips screen đã có:
  - featured large tip card,
  - smaller tip cards,
  - detailed article view với section blocks, callout boxes, bullets, image block,
  - embedded detail flow ngay trong tab Tips.
  - shared detail template đã được nâng để hỗ trợ `display headline`, `quote block`, `callout`, `image caption`, và `footer CTA`.

## Static Data State
- Travel content vẫn đang static trong `lib/data/travel_data.dart`.
- Weather UI không còn dùng static-only nữa; hiện đã có runtime fetch từ OpenWeather.
- Static models hiện có:
  - `MoroccoCity`
  - `HourlyForecastPoint`
  - `DailyForecastPoint`
  - `WeatherMetric`
  - `TravelTip`
  - `TipSection`
- Home city hiện tại: `Casablanca`.
- Danh sách city hiện có:
  - Casablanca
  - Marrakech
  - Fes
  - Chefchaouen
  - Essaouira
- Tips hiện có:
  - Packing Essentials
  - Currency Tips
  - Cultural Etiquette
  - Best Travel Seasons
- Mỗi tip hiện đã có detailed content riêng lấy từ Stitch HTML tương ứng, không còn dùng một article generic chung.
- Tip detail content hiện đã được remap gần hơn với Stitch:
  - `Packing Essentials`: có `The Ultimate Moroccan Packing List`, quote về giày mới, thêm `Tech & Gear`, `Essential Scarf`
  - `Currency Tips`: có `Navigating the Dirham`, `Riad Tipping`, `Souk Exchange Rates`, `Recommended Exchange Points`, `Cash vs. Card`
  - `Cultural Etiquette`: có `Navigating the Soul of Morocco`, quote hospitality, `Declining Vendors`, footer CTA
  - `Best Travel Seasons`: có `When to Experience the Magic of Morocco`, intro mới, `Insider Tip: The Ramadan Factor`

## OpenWeather Coordinates
- `MoroccoCity` hiện đã chứa sẵn `latitude` và `longitude` để dùng cho
  `https://api.openweathermap.org/data/2.5/forecast`.
- 5 city coordinates đang dùng:
  - Casablanca: `33.5731`, `-7.5898`
  - Marrakech: `31.6295`, `-7.9811`
  - Fes: `34.0331`, `-5.0003`
  - Chefchaouen: `35.1688`, `-5.2636`
  - Essaouira: `31.5085`, `-9.7595`

## Weather Data Integration
- Weather source hiện tại:
  `https://api.openweathermap.org/data/2.5/forecast`
- Weather layer mới nằm ở:
  - `lib/data/weather_data.dart`
  - `lib/data/weather_cache_store.dart`
  - `lib/data/weather_cache_store_io.dart`
  - `lib/data/weather_cache_store_web.dart`
- API key không hardcode trong source; app đọc từ
  `--dart-define=OPENWEATHER_API_KEY=...`.
- `WeatherRepository` hiện:
  - fetch forecast theo `latitude` / `longitude` của `MoroccoCity`
  - cache snapshot theo từng city
  - dùng `city.timezone` từ OpenWeather response để resolve ngày hiện tại và slot forecast gần nhất
  - fallback về snapshot suy ra từ dữ liệu cũ nếu fetch lỗi
- `HomeScreen` hiện là `StatefulWidget` và hydrate weather cho Casablanca trước, đồng thời warm cache cho các city còn lại.
- `CityDetailScreen` hiện cũng là `StatefulWidget` và tự load weather runtime cho city đang mở.
- Travel tips và city article content vẫn giữ static.

## Reusable Weather Rules
- Đây là rule chuẩn nên tái sử dụng cho các project travel/weather sau:
  - chỉ hydrate weather hằng ngày từ `HomeScreen`,
  - mỗi city chỉ gọi API tối đa 1 lần mỗi ngày địa phương của city đó,
  - nếu trong ngày chưa từng fetch, gọi 1 lần khi user mở `HomeScreen`,
  - nếu đã có cache hợp lệ trong ngày, dùng lại cache và không fetch lại,
  - các màn khác phải đọc từ cache/repository thay vì tự gọi API riêng,
  - trong cùng ngày, current slot và forecast window có thể re-resolve từ timeline đã cache mà không cần network,
  - nếu fetch lỗi thì dùng cache cũ, nếu chưa có cache thì mới fallback về static snapshot,
  - timezone phải theo city/API response, không theo timezone máy local.
- Mục tiêu của rule này:
  - giảm số lần gọi API,
  - giữ dữ liệu ổn định trong ngày,
  - vẫn cho phép UI xác định đúng `current`, `hourly`, `5-day` từ cùng một snapshot cache.

## Data / API Guidance For Future Sessions
- Khi bắt đầu nối API, không nhét logic fetch trực tiếp vào screen widgets.
- Hướng nên đi:
  - tạo `repository` hoặc `data source`,
  - giữ model rõ ràng,
  - thay static constants bằng mapped runtime data.
- Nên giữ `travel_data.dart` như mốc reference cho shape dữ liệu trước khi refactor sang repository.

## Design/Implementation Notes
- Project này được dựng theo kinh nghiệm rút ra từ `angola-travel`, nhưng source thiết kế là Stitch chứ không phải Figma.
- Ưu tiên giữ cấu trúc source giống Angola ở mức hợp lý để dễ tái sử dụng workflow:
  - `screens`
  - `widgets`
  - `theme`
  - `data`
- Vì môi trường local Windows trước đó có friction với một số dependency/plugin, state hiện tại tránh dùng package không cần thiết.
- Các image hiện tại đang dùng `Image.network(...)` từ URL thu được qua HTML tham chiếu. Nếu cần ổn định hơn sau này, có thể tải về local assets.

## Verification State
- `flutter analyze` trong `D:\Work\Working\flutter\morocco-travel` đang pass sau khi thêm weather repository và OpenWeather integration.
- Test boilerplate mặc định của Flutter đã bị xóa vì không còn phù hợp với app hiện tại.

## Important Local Paths
- Project root:
  `D:\Work\Working\flutter\morocco-travel`
- Local Codex plugin marketplace:
  `D:\Work\Working\flutter\morocco-travel\.agents\plugins\marketplace.json`
- Local Caveman plugin bundle:
  `D:\Work\Working\flutter\morocco-travel\.codex-plugins\caveman`
- Repo-local Codex hook config:
  `D:\Work\Working\flutter\morocco-travel\.codex\hooks.json`
- Skill file:
  `D:\Work\Working\flutter\morocco-travel\.agent\skills\skill.md`
- Context file:
  `D:\Work\Working\flutter\morocco-travel\AI_CONTEXT.md`
- Temporary Stitch HTML references:
  - `D:\Work\Working\flutter\morocco-travel\tmp\home.html`
  - `D:\Work\Working\flutter\morocco-travel\tmp\cities.html`
  - `D:\Work\Working\flutter\morocco-travel\tmp\tips.html`
  - `D:\Work\Working\flutter\morocco-travel\tmp\weather_detail.html`
  - `D:\Work\Working\flutter\morocco-travel\tmp\tip_detail.html`
  - `D:\Work\Working\flutter\morocco-travel\tmp\tip_packing.html`
  - `D:\Work\Working\flutter\morocco-travel\tmp\tip_currency.html`
  - `D:\Work\Working\flutter\morocco-travel\tmp\tip_culture.html`
  - `D:\Work\Working\flutter\morocco-travel\tmp\tip_seasons.html`
  - `D:\Work\Working\flutter\morocco-travel\tmp\tip_majorelle.html`

## Recommended Next Tasks
- So khớp spacing và tỷ lệ các màn sát Stitch hơn.
- Quyết định bộ ảnh cuối cùng: giữ `Image.network` hay chuyển sang assets local.
- Tạo `repository` cho weather/travel data khi user muốn nối API.
- Nếu cần fidelity cao hơn cho Tips, tách riêng layout detail cho từng bài thay vì dùng shared article template.
- Nếu cần consistency cao hơn với Angola, có thể thêm asset pipeline và design tokens rõ hơn.
