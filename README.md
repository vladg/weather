Initial thoughts:
- app will have a main view to display weather and a settings modal to enter location
- start with a hardcoded location to get main view working, improve from there
- write in Swift, no need for pods or third party libraries, just use Apple frameworks

Limitations:
- target phone only, iPad will likely require a different UI layout
- this is a sample project, we will not do localization support (i.e. UI strings will be hardcoded)
- error handling will be really basic, many edge cases will not be handled
- we will not do any data validation on what Api returns to us
- weather icons are downloaded from openweathermap every time and they look terrible due to scaling
