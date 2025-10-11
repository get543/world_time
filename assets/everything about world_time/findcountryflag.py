import pandas as pd
import pytz
import pycountry

# Load your CSV
file_path = "formated shit.csv"   # change path if needed
df = pd.read_csv(file_path)

# Extract all timezones from the first column
timezones = df.iloc[:, 0].dropna().tolist()

# Map timezone -> country code
tz_to_country = {}
for country_code, tz_list in pytz.country_timezones.items():
    for tz in tz_list:
        tz_to_country[tz] = country_code

# Get country name from timezone
def get_country_name(tz: str) -> str:
    country_code = tz_to_country.get(tz)
    if not country_code:
        return "unknown"
    country = pycountry.countries.get(alpha_2=country_code)
    if country:
        # lowercase, underscores for spaces
        return country.name.lower().replace(" ", "_")
    return "unknown"

# Generate formatted strings
formatted = []
for tz in timezones:
    parts = tz.split("/")
    if len(parts) == 2:
        _, city = parts
    elif len(parts) == 3:
        _, region, city = parts
        city = f"{region}/{city}"
    else:
        continue
    
    location = city.replace("_", " ")
    country_name = get_country_name(tz)
    flag = f"{country_name}.png"

    formatted.append(
        f"WorldTime(url: '{tz}', location: '{location}', flag: '{flag}'),"
    )

# Save results
output_file = "worldtime_with_country_flags.txt"
with open(output_file, "w", encoding="utf-8") as f:
    f.write("\n".join(formatted))

print(f"✅ Done! File saved as {output_file}")
