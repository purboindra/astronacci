# Project Overview

This project is a backend API built with Express.js (TypeScript) that supports user authentication, CRUD operations, pagination, search, and file uploads.

## Features

- User Authentication: Register, Login, Edit, Delete, and Logout
- Forgot Password (via Postman)
- User Management: Fetch all users, search users, and pagination
- Upload Avatar/Image using Cloudinary
- Fetch User by ID (Get user details)

## Tech Stack

### Frontend

- Flutter
- State Management: BLoC

### Backend

- Express.js (Fully built with TypeScript)

### Database

- MongoDB

### File Storage

- Cloudinary (Image/Avatar storage)

### Simulate forgot password

- Pass email as body
- `/api/auth/forgot-password` will send reset password token and reset password expires
- Next step, u will get email that send to email that u're pass as body, via local `http://localhost:3000/api/auth/reset-password/${resetToken}`
- You need pass token that you get earlier from forgot-password api, then pass as params
- Dont forget to put your new password as body {newPassword: mynewpassword}
- After you're send request to `/api/auth/reset-password/:token`, if success, you can logged in to your account with your new password.

### Local Limitations

`Since this API not deployed yet, this project only run within local environment`

- Go to `constants.dart` file `frontend/lib/utils/constants.dart`
- Change `baseUrl` and `ipAddress` with yours.

### .env

`` PORT=3000
MONGO_URI=mongodb+srv://purboindra:fI1PtsYnjRRDtfP6@astronacci.izoci.mongodb.net/astronacci?retryWrites=true&w=majority&appName=Astronacci
EMAIL_USER=YOUR_EMAIL
EMAIL_PASS=cnnoqvmxbnpodvda

# CLOUDINARY

CLOUDINARY_CLOUD_NAME=dwnetprtz
CLOUDINARY_API_KEY=736354167627792
CLOUDINARY_API_SECRET=UnJNjF_eJBq0ONUPsOpRXorCHD8

JWT_SECRET_KEY=4str0n4ci! ``
