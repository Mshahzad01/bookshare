# Book Share App - File Structure Summary

## 📁 Complete File Structure

```
bookshare/
├── lib/
│   ├── main.dart                          # App entry point with BLoC providers
│   │
│   ├── models/                            # Data models
│   │   ├── book.dart                      # Book model with all properties
│   │   ├── user.dart                      # User model with profile info
│   │   ├── chat_message.dart              # Chat & conversation models
│   │   └── banner_item.dart               # Banner carousel model
│   │
│   ├── cubits/                            # State management (Cubit)
│   │   ├── auth/
│   │   │   ├── auth_cubit.dart            # Authentication logic
│   │   │   └── auth_state.dart            # Auth states
│   │   ├── home/
│   │   │   ├── home_cubit.dart            # Home screen logic
│   │   │   └── home_state.dart            # Home states
│   │   ├── books/
│   │   │   ├── books_cubit.dart           # Books filtering/search logic
│   │   │   └── books_state.dart           # Books states
│   │   ├── chat/
│   │   │   ├── chat_cubit.dart            # Chat logic
│   │   │   └── chat_state.dart            # Chat states
│   │   └── profile/
│   │       ├── profile_cubit.dart         # Profile & listings logic
│   │       └── profile_state.dart         # Profile states
│   │
│   ├── screens/                           # UI screens
│   │   ├── splash_screen.dart             # Animated splash screen
│   │   ├── main_navigation_screen.dart    # Bottom nav + FAB
│   │   ├── auth/
│   │   │   ├── login_screen.dart          # Login with email/Google
│   │   │   └── signup_screen.dart         # Multi-step signup
│   │   ├── home/
│   │   │   └── home_screen.dart           # Dashboard with Slivers
│   │   ├── categories/
│   │   │   └── categories_screen.dart     # Search & filter books
│   │   ├── add_book/
│   │   │   └── add_book_screen.dart       # Add/list book form
│   │   ├── chat/
│   │   │   └── chat_screen.dart           # Conversations list
│   │   └── profile/
│   │       └── profile_screen.dart        # Profile & my listings
│   │
│   └── data/
│       └── dummy_data.dart                # All dummy data
│
├── pubspec.yaml                           # Dependencies
├── README.md                              # Documentation
└── test/
    └── widget_test.dart                   # Basic tests
```

## 🎯 Key Components

### 1. Main App (`lib/main.dart`)
- MultiBlocProvider setup
- MaterialApp configuration
- Route definitions
- Theme setup (Light + Dark)

### 2. Models (`lib/models/`)
- **Book**: id, title, author, price, isDonation, distance, isSold, etc.
- **User**: id, name, email, location, trustScore, listings count
- **ChatMessage & ChatConversation**: messaging data structures
- **BannerItem**: carousel banner data

### 3. State Management (`lib/cubits/`)
Each feature has its own Cubit:
- **AuthCubit**: login, signup, logout
- **HomeCubit**: load home data, update location
- **BooksCubit**: search, filter by category
- **ChatCubit**: load conversations
- **ProfileCubit**: manage listings, mark sold, delete, dark mode

### 4. Screens (`lib/screens/`)

#### Splash Screen
- Animated logo reveal
- FadeIn + Scale animations
- 3-second delay → navigate to login

#### Auth Screens
- **Login**: Email/password + Google button
- **Signup**: Two-step process (account + location)

#### Main Navigation
- Bottom nav with 4 tabs
- Centered FAB for "Add Book"
- IndexedStack for tab switching

#### Home Screen (⭐ Slivers!)
- SliverAppBar (floating, with location)
- Carousel banner (auto-scroll)
- Horizontal categories chips
- "Donate Books" horizontal list
- "Books Nearby" grid
- CustomScrollView throughout

#### Categories Screen
- Search bar with real-time filtering
- Horizontal category filters (All + specific)
- MasonryGridView for books
- Empty state handling

#### Add Book Screen
- Form with validation
- Image upload placeholder
- Sell/Donate toggle
- Category & condition dropdowns

#### Chat Screen
- Conversation cards
- Unread count badges
- Book context in conversations
- Empty state

#### Profile Screen
- Gradient header with avatar
- User stats (trust score, listings, transactions)
- My Listings with edit/delete/mark sold
- Settings (account, location, dark mode, logout)

## 📊 Dummy Data Structure

### Books
- 4 Donation books (FREE)
- 6 Books for sale (with prices)
- 3 My listings (some sold)
- Various categories and distances

### User
- Name: Ahmed Ali
- Location: Islamabad, Pakistan
- Trust Score: 4.5/5
- 12 Total listings
- 8 Completed transactions

### Categories
Fiction, Engineering, Islamic, Medical, Science, History, Children, Poetry, Business, Self-Help

### Banners
- Book of the Week
- Donate & Make a Difference
- Engineering Books Sale

### Conversations
- 3 sample conversations
- With unread counts
- Book context included

## 🎨 Design Tokens

### Colors
- Primary: #6750A4 (Purple)
- Success: Green (donations)
- Error: Red (delete actions)

### Typography
- Font Family: Poppins (Google Fonts)
- Sizes: 11px - 36px

### Spacing
- Small: 4px, 8px
- Medium: 12px, 16px
- Large: 24px, 32px

### Border Radius
- Small: 8px
- Medium: 12px
- Large: 16px

## 🔄 Navigation Flow

```
Splash (3s)
    ↓
Login ←→ Signup
    ↓
Main Navigation
├── Tab 0: Home
├── Tab 1: Categories
├── FAB: Add Book
├── Tab 3: Chat
└── Tab 4: Profile
```

## ⚡ State Flow Examples

### Login Flow
```
User enters credentials
    ↓
AuthCubit.login(email, password)
    ↓
emit(AuthLoading)
    ↓
Simulate API call (2s)
    ↓
emit(AuthAuthenticated)
    ↓
Navigate to /main
```

### Home Data Flow
```
HomeScreen initState
    ↓
HomeCubit.loadHomeData()
    ↓
emit(HomeLoading)
    ↓
Load dummy data (1s)
    ↓
emit(HomeLoaded(banners, categories, books, ...))
    ↓
UI rebuilds with data
```

### Mark as Sold Flow
```
User taps "Mark as Sold"
    ↓
ProfileCubit.markAsSold(bookId)
    ↓
Update book.isSold = true
    ↓
emit(ProfileLoaded with updated listings)
    ↓
UI shows "SOLD" badge
```

## 📱 Responsive Features

- Adapts to different screen sizes
- Grid columns adjust automatically
- Scrollable content everywhere
- Safe area padding
- Keyboard-aware forms

## 🎯 Best Practices Used

✅ Clean Architecture (separation of concerns)
✅ BLoC pattern (Cubit) for state management
✅ Equatable for value comparison
✅ Immutable data models
✅ Null-safety
✅ Code reusability
✅ Proper naming conventions
✅ Comments where needed
✅ Material 3 design guidelines
✅ Accessibility considerations

## 🚀 Quick Start

1. `flutter pub get`
2. `flutter run`
3. Login with any email/password (dummy auth)
4. Explore all features!

## 📝 Notes

- All data is dummy/mock data
- No backend integration yet
- Images are from Unsplash (via URLs)
- State persists only during session
- Perfect base for adding real API integration

---

**Total Files Created**: 25+
**Lines of Code**: ~3000+
**Time to Build**: Professional Flutter UI prototype ready for production integration!
