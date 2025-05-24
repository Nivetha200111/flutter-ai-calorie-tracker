# AI Calorie Tracker

A personal assistant app that uses Grok AI to track calories automatically by analyzing food descriptions.

## Features

- 🤖 **AI-Powered Food Analysis**: Uses Grok AI to automatically calculate calories from food descriptions
- 📊 **Real-time Tracking**: Track daily calorie intake with visual progress indicators
- 💾 **Data Persistence**: Automatically saves your food log locally
- 📱 **Responsive Design**: Works on desktop and mobile devices
- 🎯 **Daily Goals**: Set and track progress toward daily calorie goals

## Setup

1. **Get a Grok API Key**:
   - Visit [console.x.ai](https://console.x.ai/)
   - Sign up and get your API key

2. **Run the App**:
   ```bash
   npm start
   # or
   python -m http.server 8000
   ```

3. **Open in Browser**:
   - Go to `http://localhost:8000`
   - Enter your Grok API key when prompted

## How to Use

1. **Log Food**: Describe what you ate (e.g., "grilled chicken breast with rice and vegetables")
2. **AI Analysis**: The app uses Grok AI to estimate calories and portion sizes
3. **Track Progress**: View your daily intake and remaining calories
4. **Review History**: See all your food entries with timestamps

## Features

- **Smart Estimation**: If no API key is provided, the app falls back to intelligent calorie estimation
- **Daily Reset**: Food log automatically resets each day
- **Remove Entries**: Delete incorrect entries with the × button
- **Progress Visualization**: Color-coded progress bar shows intake status

## Technology

- Pure HTML, CSS, and JavaScript
- Grok AI API integration
- Local storage for data persistence
- Responsive design for all devices