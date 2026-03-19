#  SELA - Sign Language Recognition App

##  Overview

SELA is an AI-powered Flutter mobile application designed to bridge the communication gap between deaf and hearing individuals by translating sign language into text, speech, and visual content — and vice versa.

The app integrates **Computer Vision, AI models, and Firebase services** to deliver a seamless and intelligent communication experience.

---

##  Key Features

###  AI Sign Language Recognition

* Capture gestures using device camera
* Send recorded videos to AI backend
* Receive real-time predictions
* Supports Arabic sign language 🇪🇬

---

###  Bidirectional Translation

* **Sign ➝ Text**
* **Text ➝ Sign (Video playback)**
* Smart fallback:
  If video is unavailable → show **letter-by-letter images**

---

###  Audio Support

* Text-to-Speech using `FlutterTTS`
* Arabic voice output support

---

###  Authentication System

* Login & Registration (Firebase Auth)
* Forgot Password with OTP (Phone verification)
* Change Password (with re-authentication)
* Secure logout

---

###  User Profile Management

* View profile info
* Edit name
* Persistent user data using Firestore

---

###  Camera & Video Processing

* Record video with countdown timer
* Switch between cameras
* Upload video to backend server
* Stream & play response videos

---

##  Smart AI Flow

![Image](https://www.researchgate.net/profile/Sn-Demidenko/publication/282311300/figure/fig2/AS%3A391468079435783%401470344671452/Sign-language-recognition-flow-chart.png)

![Image](https://d2d1s3b58ci0ra.cloudfront.net/2021/01/pipeline-architecture-mobidev.png)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1400/1%2AMEu05n0HIO3iS_RyYiosPA.png)

![Image](https://www.researchgate.net/publication/348979911/figure/fig2/AS%3A11431281211387571%401702395011732/Pipeline-of-hand-gesture-recognition-HGR-based-HCI-design-1-User-performs.tif)

1. User records sign language video
2. Video is sent to backend API
3. AI model processes gestures
4. Response returned as:

   * Text prediction
   * Video (if available)
   * Letter images (fallback)

---

## 🏗 Architecture

This project follows **Clean Architecture** principles:

### 🔹 Presentation Layer

* Flutter UI Screens
* State Management (Provider)

### 🔹 Domain Layer

* Use Cases:

  * `RecordVideoUseCase`
  * `SendVideoUseCase`
  * `FetchAndPlayVideoUseCase`

### 🔹 Data Layer

* Repository Pattern (`VideoRepository`)
* Data Sources:

  * Camera Data Source
  * Remote API Data Source
  * Firebase Firestore

---

## 🛠 Tech Stack

* **Flutter & Dart**
* **Firebase Authentication**
* **Cloud Firestore**
* **Provider**
* **Camera Package**
* **Video Player**
* **Flutter TTS**
* **HTTP (REST APIs)**
* **AI Backend (Flask APIs)**

---

##  Backend APIs

The app communicates with 3 services:

*  Video Prediction API → `/predict`
*  Video Retrieval API → `/video`
*  Letter Image API → `/get_letter_image`

---

## 🔐 Security & Validation

* Email validation
* Password rules (≥ 8 characters)
* Egyptian phone formatting (+20)
* Firebase secure authentication
* Re-authentication before password change

---

## 📂 Project Structure

```bash id="structure1"
lib/
├── data/
│   ├── datasources/
│   ├── repositories/
├── domain/
│   ├── repositories/
│   ├── usecases/
├── presentation/
│   ├── screens/
├── model/
├── utils/
```






## 🎥 App Demo
https://github.com/user-attachments/assets/e6e01baa-8f55-48e7-937a-92429e23f433
