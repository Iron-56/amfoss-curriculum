# Software Requirements Specification (SRS) for Letterboxd Similar Project

## 1. Introduction

### 1.1 Purpose

The project is to develop a social networking site for movie lovers, modeled after Letterboxd. The users will be able to find, rate, and review movies and connect with like-minded people. The site will have watchlists, handpicked suggestions, and some social interactions.

### 1.2 Scope

The website will allow users to add movies, review, and interact with others using comments and follows. The features will be user login, movie search, review and rating, watchlists, and other handpicked movie suggestions.

### 1.3 Overview

The product will be a web application that enables users to control their movie watching experience. Users will be able to have their watchlists, rate and review movies, and follow other users to view their activity. The site will have a recommendation system to assist users in finding new movies based on their interests. A simple, minimal user interface will ensure engagement and a seamless experience on devices. The system should scale in handling, giving real-time interactions between users.

### 1.3 Document Conventions

**UI**: User Interface

**UX:** User Experience

**API**: Application Programming Interface

**DB**: Database

**App**: Application

**Auth**: Authentication

### 1.4 References

[Letterboxd](https://letterboxd.com/)

[UI/UX design](https://dribbble.com/AriefBagusRachmadi/collections/1450187-UI-UX-Reference)

## 2. Overall Description

### 2.1 Product Perspective

This platform will be a web application that allows users to rate and comment on movies, follow other users, and share watchlists.The software will have simplistic UI and a choosen backend for database and other data handling.

### 2.2 Product Functions

**User Authentication:** Sign-up, sign-in using email.

**Search Functionality:** Search for movies by title, genre, or release year.

**Task/Item Addition:** Add new movies with attributes such as description, images, and categories.

**Review and Rating System:** Users will be able to review, rate tasks, movies and modify/delete reviews.

**Watchlist:** Manage lists of movies to watch.

**Social Features:** Follow users, view activity, and comment on reviews.

**Recommendations:** Recommend similar movies based on user preference.

**Curated Lists:** User-created featured lists.

### 2.3 User Characteristics

**Casual Users:** Desire to browse films, read reviews, and find recommendations.

**Active Reviewers:** Users who regularly log films, post reviews, and engage with the community.

**Curators:** Users who built curated lists of films and participate more in discussions.

### 2.4 Constraints

- The site needs to be accessible through botth the desktop and mobile browsers.

- Database needs to efficiently manage large amounts of user data.

- Smooth browsing at low loads.

### 2.5 Assumptions and Dependencies

The application relies on Letterboxd's API for fetching movie ratings. API changes will impact the functionality

## 3. Specific Requirements

### 3.1 User Authentication

- Users should be able to register using email id.
- Users should be able to securely log in and out.
- Users should be able to reset passwords.

### 3.2 Search Functionality

- Users will be able to search for films by name, genre, or year.

- The search functionality will give autocomplete suggestions.

### 3.3 Review and Rating System

- Users will be able to post reviews and ratings.
- Users will be able to modify or remove their reviews.
- Users will be able to see others reviews and ratings.

### 3.4 Watchlist

- Users will be able to add and delete movies from watchlist.
- Users will be able to sort and filter watchlist.

### 3.5 Social Features

- Users will be able to follow or unfollow others.
- Users will be able to see a feed of activity from followed users.
- Users will be able to comment on reviews.

### 3.6 Recommendations

- The system will recommend movies based on user preferences and watch history.

### 3.7 Curated Lists

- Users will be able to make and share curated lists of movies.
- Most liked curated lists will be shown on the site.

## 4. Non-Functional Requirements

### 4.1 Performance

- Pages will load in 2 seconds at low loads.
- Should be able to handle large number of users simultaneously.

### 4.2 Security

- Passwords will be encrypted on the site.
- The system will block unauthorized access through authentication.

### 4.3 Usability

- The UI will be simple and easy to use.

- The layout shall be responsive.

### 4.4 Scalability

- The database should be able to handle a large number of users and reviews.

## 5. External Interface Requirements

### 5.1 User Interface

- The UI will be simple, drawing inspiration from best UX practices.

## 6. Appendices

**Fair Use Policy:** Movie reviews and ratings should agree with Letterboxd's terms of service.
