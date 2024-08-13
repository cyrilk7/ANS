# AshPilot: A New Era of Campus Navigation

## Overview

This project tackles navigation challenges in both indoor and outdoor environments by developing a digital navigation system for Ashesi University's campus. Current navigation methods on campus are inefficient, often relying on word-of-mouth directions and leaving newcomers disoriented. The proposed system aims to bridge this gap by offering a comprehensive solution that integrates real-time navigation for both indoor and outdoor environments. The system also provides historical and contextual information about campus buildings and events. By leveraging OpenStreetMap for outdoor mapping and MappedIn for indoor navigation, this system provides seamless transitions between different environments, enhancing the user experience. 

**Github repo:** (https://github.com/cyrilk7/ANS
)
## Prerequisites

- **Flutter:** For the Flutter app (Primary navigation features)
- **Node.js and npm:** For the React app (Management features)
- **Python and pip:** For the Flask backend (Backend API)

## Directory Structure

- `app/` - Contains the Flutter application code
- `admin/` - Contains the React application code
- `backend/` - Contains the Flask backend API code


## Setting Up the Flutter App

1. **Install Flutter:**
   - Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install) for your operating system.

2. **Clone the repository:**
   ```sh
   git clone https://github.com/cyrilk7/ANS
   cd app
   ```

3. **Run app on emulator:**
   ```sh
   flutter run
   ```


## Setting Up the React App

1. **Install Node.js and npm:**
   - Follow the [Node installation guide](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) for your operating system.

2. **Clone the repository:**
   ```sh
   git clone https://github.com/cyrilk7/ANS
   cd admin
   ```

3. **Install all dependencies:**
   ```sh
   npm install
   ``` 

4. **Run the app:**
   ```sh
   npm start
   ``` 



## Setting Up the Flask App

1. **Install Python and pip:**
   - Follow the [Python installation guide](https://www.python.org/downloads/) for your operating system.

2. **Clone the repository:**
   ```sh
   git clone https://github.com/cyrilk7/ANS
   cd backend
   ```

3. **Install all dependencies:**
   ```sh
   pip install -r requirements.txt
   ``` 

4. **Run the Flask app. Make sure to replace firebase and server credentials with yours in api_config file. For the database, you can import the SQL script provided in the resources folder for the db structure:**
   ```sh
   python app.py
   ``` 