# MediStock

## Summary

* [Description](#description)
* [Installation](#installation)
* [Features](#features)
* [Testing](#testing)

## Description
MediStock is a mobile application developed as part of the OpenClassrooms iOS Development program.
It aims to simplify medicine management to keep track of their quantities, stock alert and location.

The app is designed with a focus on:
 - User-friendly interfaces: Users can quickly navigate between medicines, aisles, details view...
 - Personalization: Profiles allow users to manage their information.
 - Efficient data management: All Firebase operations (Auth, Firestore, Storage, etc.) are encapsulated in dedicated repositories, which interact with ViewModels to keep the UI decoupled from backend logic.
 - Robust testing: MediStock uses unit tests, integration tests, and UI/E2E tests with Docker and the Firebase Emulator Suite to ensure reliability and maintainability.

## Installation

### Clone the repository
```shell
git clone https://github.com/ThibaultGiraudon/Rebonnte.git
```

---

### Create files

 - #### GoogleService.plist:
Go on [Firebase](https://console.firebase.google.com/) and create a new app with your Bundle Identifier.
You can get yours following those steps :

![alt text](https://github.com/ThibaultGiraudon/CarVision/blob/main/assets/Bundle-Id.png)

Then add Storage and Database and Authentification. Don't forget to change the rules:

- ##### Storage:
```
rules_version = '2';


service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

- ##### Database:
```
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

## Features

### Firebase Integration 
All Firebase-related operations are encapsulated within dedicated repository classes, such as `AuthRepository`, `StorageRepository` and `FirebaseRepository` with its extensions.
Each repository is responsible for interacting with a specific Firebase service, isolating implementation details from the rest of the application.
This architecture prevents direct dependencies on Firebase APIs within ViewModels or other components, making the codebase cleaner, more maintainable, and easier to refactor.
By centralizing these operations, switching to another backend provider or modifying the data layer can be done with minimal changes to the business logic.

---

### Authentication
Users can create an account, sign in, and sign out using Firebase Authentication.
The authentication logic is fully handled by the AuthRepository, accessed through the corresponding `AuthenticationViewModel`.

---

### Aisle Creation
Users can create new aisles by providing a name, icon and color.
The [AddAisleViewModel](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/ViewModels/AddAisleViewModel.swift) validates inputs and then delegates persistence to the [FirestoreRepository+aisle](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/Repositories/FirestoreRepository/FirestoreRepository%2BAisle.swift).

---

### Medicine Creation
Users can create new aisles by providing a name, icon, color and stock levels.
The [AddMedicineViewModel](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/ViewModels/AddMedicineViewModel.swift) validates inputs and then delegates persistence to the [FirestoreRepository+aisle](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/Repositories/FirestoreRepository/FirestoreRepository%2BMedicine.swift).


---

### Aisle Details
Users can see aisle's detail with all medicines stored in them.
The [AislesViewModel](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/ViewModels/AislesViewModel.swift) handles fetching all aisle and the [MedicineStockViewModel](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/ViewModels/MedicineStockViewModel.swift) handles medicines stored inside.

---

### Medicine Details
Users can see medicine's detail such as name, icon, stock levels and history with a chart and the list of entry.
The [MedicineStockViewModel](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/ViewModels/MedicineStockViewModel.swift) fetches history for the given medicine.

---

### Medicines list views

There are several ways to see medicines.

Either the list off all medicines with search filter and sort option [AllMedicinesListView](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/Views/Medicines/AllMedicinesView.swift)
Or in the [AisleDetailsView](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/Views/Aisle/AisleDetailView.swift) where user can retrieve medicine stocked inside.
User can also find low stock or alert stock in the [HomeView](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/Views/HomeView.swift)

In all cases the [MedicineStockViewModel](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/ViewModels/MedicineStockViewModel.swift) handles retrieving medicine and filter depending on user request.
The medicines are diplayed in [MedicineListView](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/Views/Medicines/MedicineListView.swift) which request new fetch after each operation.

## Testing

### **Step 1: Configure Docker**

To safely test `MediStock` without touching the production database the application uses Firebase emulator.
In order to simplify the testing process the emulator runs in a Docker's image so you need Docker Desktop running one your machine.

> [!Warning]
> *Don't forget to update [DockerFile](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/docker/Dockerfile) and [docker-compose.yml](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/docker/docker-compose.yml) with your own port before running test.*

---

#### **Step 2: Configure Ports**

* Each emulator service runs on a port. Example defaults:

  * Auth: `9099`
  * Firestore: `8080`
  * Storage: `9199`

> [!Warning]
> *Don't forget to update [AppDelegate.swift](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStock/AppDelegate.swift) and [MediStockUITests.swift](https://github.com/ThibaultGiraudon/Rebonnte/blob/main/MediStockUITests/MediStockUITests.swift) with your own port before running test.*

---

#### **Step 3: Run the tests**

You can now safely run tests the docker image will start and stop automaticly with scripts  

* The console will show which services are running and on which ports.
* Keep the emulator running while executing integration or UI tests.

> [!Warning]
> *Between each test don't forget to clear the emulator database, storage and authentification.*

### Unit Tests with Mocks/Fakes
All ViewModels and repositories are covered by unit tests.
ViewModels interact with fake repositories or mocks to isolate logic from Firebase and ensure predictable behavior.
This allows testing business logic, input validation, and state changes without relying on network calls or actual database operations.

### Integration Tests
Integration tests are performed to validate the interaction between repositories and Firebase services.
The Firebase Emulator Suite is used for Firestore, Auth, and Storage to simulate real backend behavior.
This ensures that repository methods correctly read/write data and handle errors in a controlled environment.

### UI Tests
UI tests verify end-to-end user flows, from authentication to aisle and medicine creation.
Tests run against the app using mocked data or the Firebase Emulator for a realistic environment.
This guarantees that the UI responds correctly to user actions, displays the right data, and handles errors gracefully.

### Overall Architecture
The combination of unit, integration, and UI tests ensures that:

 - Logic in ViewModels is correct and maintainable.
 - Firebase interactions behave as expected.
 - The app’s user interface is robust and reliable.
