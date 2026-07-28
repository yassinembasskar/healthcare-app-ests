# HealthCare App (PFE Project)

An AI-assisted healthcare platform consisting of a **Flutter mobile app** and a **NestJS REST API**. Patients can book appointments with doctors, upload lab test images for automated OCR extraction, and run AI predictions for **heart failure**, **brain stroke**, and **Alzheimer's** risk based on clinical data and lab results.

Built as a *Projet de Fin d'Études* (PFE) by Moutaoikkil Basskar Yassine, Tanani Mouhssin, and Boussaoudi Ahmed Amine.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Clone the Repository](#1-clone-the-repository)
  - [Backend Setup](#2-backend-setup)
  - [Frontend Setup](#3-frontend-setup)
  - [Python / ML & OCR Setup](#4-python--ml--ocr-setup)
  - [Running Everything](#5-running-everything)
- [Environment Variables](#environment-variables)
- [API Overview](#api-overview)
- [Database Schema (Entities)](#database-schema-entities)
- [Testing](#testing)
- [Known Limitations / TODO](#known-limitations--todo)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Patient & Doctor accounts** — signup/login for patients, doctors, and admins (JWT + session-based auth).
- **Appointment booking** — doctors publish availability via schedules; patients book, view, update, and cancel appointments.
- **Doctor directory** — browse and filter doctors by speciality.
- **Lab test OCR extraction** — upload a photo of a lab report; the backend runs an OpenCV/Tesseract OCR pipeline and uses OpenAI's API to interpret the extracted values.
- **AI risk prediction models**:
  - ❤️ **Heart Failure** prediction (scikit-learn model)
  - 🧠 **Brain Stroke** prediction (scikit-learn model)
  - 🧠 **Alzheimer's** prediction
- **Test history** — patients can view past predictions and lab results.
- **Admin panel logic** — user management endpoints for admins.

## Architecture

```
┌─────────────────────┐        HTTP (REST/JSON)        ┌───────────────────────────┐
│   Flutter Mobile App │ ─────────────────────────────▶ │      NestJS Backend       │
│    (app_frontend)    │ ◀───────────────────────────── │       (app_backend)       │
└─────────────────────┘                                 └─────────────┬─────────────┘
                                                                        │
                                                          ┌─────────────┼─────────────┐
                                                          │             │             │
                                                   ┌──────▼─────┐ ┌─────▼──────┐ ┌────▼─────┐
                                                   │ PostgreSQL │ │  Python    │ │ OpenAI    │
                                                   │ (TypeORM)  │ │  ML scripts│ │ API (OCR  │
                                                   │            │ │ (.pkl      │ │ result    │
                                                   │            │ │  models)   │ │ interpret)│
                                                   └────────────┘ └────────────┘ └───────────┘
```

The NestJS backend spawns Python child processes (via colocated `.py` scripts) to run the scikit-learn `.pkl` prediction models and the OpenCV/Tesseract OCR pipeline, then persists results through TypeORM into PostgreSQL.

## Tech Stack

**Frontend (`app_frontend/`)**
- [Flutter](https://flutter.dev/) / Dart (SDK `>=3.2.6 <4.0.0`)
- Plain `StatefulWidget` + `setState` (no external state management library)
- `http` — REST client
- `shared_preferences` — local session/user storage
- `image_picker`, `url_launcher`, `font_awesome_flutter`, `vtable`

**Backend (`app_backend/`)**
- [NestJS 10](https://nestjs.com/) (TypeScript) on Express
- [TypeORM](https://typeorm.io/) + PostgreSQL (`pg`)
- Auth: `@nestjs/jwt`, `passport-jwt`, `express-session`, `bcrypt`/`bcryptjs`
- File uploads: `multer`
- Email: `@nestjs-modules/mailer` + `nodemailer`
- Config: `@nestjs/config` (`.env` based)

**ML / OCR (Python, invoked as subprocesses from the backend)**
- `scikit-learn` (pickled `.pkl` models for heart failure & brain stroke)
- `opencv-python`, `pytesseract` — OCR pipeline for lab test images
- `openai`, `python-dotenv` — GPT-based interpretation of extracted lab values

## Project Structure

```
healthcare-app-ests/
├── app_backend/                 # NestJS API
│   ├── src/
│   │   ├── main.ts               # bootstrap, session middleware, CORS, port 3000
│   │   ├── app.module.ts         # TypeORM config, MulterModule, root module
│   │   ├── user/
│   │   │   ├── patient/          # patient (User entity) signup/login/profile
│   │   │   ├── doctor/           # doctor CRUD, signup/login
│   │   │   ├── admin/            # admin CRUD
│   │   │   └── auth/             # shared auth controller/service
│   │   ├── appointment/          # appointment booking CRUD
│   │   ├── Schedule/              # doctor availability schedules
│   │   ├── ocr/                  # lab report image upload + OCR extraction
│   │   ├── brainstroke/          # brain stroke prediction (+ brainstroke.py, .pkl models)
│   │   ├── heartfailure/         # heart failure prediction (+ HeartFailure.py, .pkl models)
│   │   ├── alzheimer/            # Alzheimer's prediction (+ alzheimer.py)
│   │   └── exceptions/           # custom domain exceptions
│   ├── decryption.py             # OpenAI-based lab value interpretation
│   ├── extraction.py             # OpenCV/pytesseract OCR pipeline
│   └── package.json
├── app_frontend/                 # Flutter mobile app
│   └── lib/
│       ├── main.dart              # app entry point
│       ├── var.dart                # backend base URL config
│       ├── login.dart / signup.dart
│       ├── doctorpage.dart         # doctor list/detail (initial screen)
│       ├── apointement.dart        # appointment booking
│       ├── BrainStroke.dart, HeartFailure.dart, alzheimer.dart  # prediction forms
│       ├── testresults.dart, History.dart
│       ├── profile.dart, usermanagment.dart, aboutus.dart
│       └── user_storage.dart       # shared_preferences wrapper
├── requirements.txt              # Python deps for ML/OCR scripts
├── package.json                  # npm workspaces root (wraps app_backend)
└── README.md
```

## Getting Started

### Prerequisites

Make sure you have the following installed:

- [Git](https://git-scm.com/)
- [Node.js & npm](https://nodejs.org/) (Node 18+ recommended for NestJS 10)
- [Python 3.10+](https://www.python.org/)
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [PostgreSQL](https://www.postgresql.org/) (local instance or remote)
- [Tesseract OCR](https://github.com/tesseract-ocr/tesseract) binary installed and on your `PATH` (required by `pytesseract`)

### 1. Clone the Repository

```bash
git clone <repository-url>
cd healthcare-app-ests
```

### 2. Backend Setup

Install dependencies via the npm workspace at the repo root (this installs `app_backend`'s dependencies too):

```bash
npm install
```

Create a `.env` file inside `app_backend/` (see [Environment Variables](#environment-variables) below), then create the PostgreSQL database referenced by `DATABASE_NAME`. TypeORM is configured with `synchronize: true`, so tables are created/updated automatically from the entities on startup — no manual migrations needed for local development.

### 3. Frontend Setup

```bash
cd app_frontend
flutter pub get
```

Update the backend base URL in [`app_frontend/lib/var.dart`](app_frontend/lib/var.dart) if your API isn't running on `http://localhost:3000` (e.g. when testing on a physical device, point it at your machine's LAN IP).

### 4. Python / ML & OCR Setup

From the repo root:

```bash
pip install -r requirements.txt
```

This installs `openai`, `python-dotenv`, `opencv-python`, `numpy`, `pytesseract`, `pandas`, and `scikit-learn`. Also ensure the Tesseract binary itself is installed separately (it's a system dependency, not a pip package).

### 5. Running Everything

From the repo root, using the convenience scripts in the root `package.json`:

```bash
npm run start:backend:dev   # NestJS API with hot-reload, http://localhost:3000
npm run start:frontend      # Flutter app (flutter run)
```

Or individually:

```bash
# Backend
cd app_backend
npm run start:dev

# Frontend
cd app_frontend
flutter run
```

## Environment Variables

Create `app_backend/.env` with the following (no `.env.example` is committed, so use this as your template):

```env
# PostgreSQL connection (read via @nestjs/config in src/app.module.ts)
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=your_db_username
DATABASE_PASSWORD=your_db_password
DATABASE_NAME=your_db_name

# OpenAI API key, used by decryption.py to interpret OCR-extracted lab values
OPENAI_API_KEY=your_openai_api_key
```

## API Overview

Base URL: `http://localhost:3000`

| Domain | Prefix | Key Endpoints |
|---|---|---|
| Auth | `/auth` | `POST /login`, `POST /logged` |
| Patients | `/users` | `POST /signup`, `POST /update_infos`, `POST /update_password`, `GET /getusers`, `POST /delete` |
| Admins | `/users` | `POST /create` |
| Doctors | `/doctors` | `GET /`, `GET /filter-by-speciality`, `GET /:id`, `POST /`, `PUT /:id`, `DELETE /:id`, `POST /signup`, `POST /login`, `POST /logout` |
| Appointments | `/appointments` | `POST /`, `POST /schedule`, `GET /`, `GET /:id`, `PUT /:id`, `DELETE /:id`, `GET /doctor/my-appointments` |
| Schedules | `/schedules` | `POST /`, `POST /bulk`, `GET /:id_sche`, `PUT /:id_sche`, `DELETE /:id_sche` |
| OCR | `/ocr` | `POST /process`, `POST /save`, `POST /get`, `POST /getextractions` |
| Brain Stroke | `/brainstroke` | `POST /GetComponent`, `POST /SaveComponents`, `POST /Prediction` |
| Heart Failure | `/HeartFailure` | `POST /GetComponent`, `POST /SaveComponents`, `POST /prediction` |
| Alzheimer's | `/alzheimer` | `POST /predict`, `POST /test-model`, `POST /Prediction` |

> **Note:** the patient and admin controllers both use the `/users` prefix — check `src/user/patient` and `src/user/admin` route handlers carefully to avoid path collisions when extending the API.

## Database Schema (Entities)

- **User** (table `patient`) — `idPatient`, `email`, `password`, `fullName`, `birthday`, `gender`, `height`, `weight`; relations to lab tests, heart failure & brain stroke predictions.
- **Admin** (table `admin`) — `id`, `username`, `email`, `password`.
- **Doctor** (table `doctor`) — `id_doc`, `username_doc`, `password_doc`, `fullname_doc`, `gender_doc`, `profilpic_doc`, `speciality`, `cabinet_add`, `email`, `phone_number`.
- **Appointment** — `id_app`, `appointmentdate`, `starttime`, `endtime`, FK → Doctor.
- **Schedule** — `id_sche`, `day`, `time`, FK → Doctor.
- **BrainStroke** (table `BrainStroke_prediction`) — clinical fields (`hypertension`, `heart_disease`, `ever_married`, `work_type`, `residence_type`, `avg_glucose_level`, `bmi`, `smoking_status`), FK → patient.
- **HeartFailure** (table `HeartFailure_prediction`) — clinical fields (`anaemia`, `diabetes`, `creatinine_phosphokinase`, `high_blood_pressure`, `platelets`, `serum_creatinine`, `serum_sodium`, `smoking`, `time`), FK → patient.
- **LabTestEntity** / **ExtractionEntity** — OCR-extracted lab test results linked to a patient.

## Testing

```bash
# Backend unit tests
npm run test

# Backend test coverage
npm run test:cov

# Backend e2e tests
npm run test:e2e
```

```bash
# Frontend tests
cd app_frontend
flutter test
```

> Test coverage is currently minimal: only the default NestJS `app.controller.spec.ts` and Flutter's default counter-app smoke test exist. Contributions adding real unit/e2e/widget tests are welcome.

## Known Limitations / TODO

- No Docker/`docker-compose` setup — PostgreSQL and Tesseract must be installed locally.
- No CI/CD pipeline configured.
- `TypeOrmModule` runs with `synchronize: true`, which is convenient for development but unsafe for production (use migrations instead).
- The Express session secret in `src/main.ts` is currently hard-coded and should be moved to an environment variable.
- The Flutter app's backend URL (`app_frontend/lib/var.dart`) is a hardcoded constant rather than a build-time config/environment value.
- The app currently launches directly into the doctor list screen rather than gating on login.
- Patient and admin controllers share the `/users` route prefix.
- No `.env.example` file is committed — use the [Environment Variables](#environment-variables) section above as a reference.

## Contributing

1. Create a personal branch off `master`:
   ```bash
   git checkout -b your-name
   ```
2. Make your changes, following the existing NestJS module structure (backend) or flat `lib/` screen structure (frontend).
3. Run `npm run lint` and `npm run test` before opening a pull request.

## License

This project is `UNLICENSED` (private, not for external distribution) — see `package.json`.
