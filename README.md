# Book Share - Flutter UI Prototype

A complete Flutter application for buying, selling, and donating books. This is a marketplace and community platform built with **Flutter**, **Material 3 Design**, and **Cubit** state management.

## 🚀 Features

### Authentication
- **Login Screen** with email/password and Google Sign-in option
- **Signup Screen** with multi-step form including location setup
- Professional and animated **Splash Screen**

### Home Dashboard (Slivers Implementation)
- **Floating SliverAppBar** with current location and notifications
- **Auto-scrolling banner carousel** showcasing featured books and events
- **Horizontal categories** list for easy filtering
- **"Donate Books" section** - horizontal scrollable list of free books
- **"Books Nearby" section** - grid view of books for sale
- Distance-based book recommendations

### Navigation
- **Bottom Navigation Bar** with 4 main tabs:
  - Home
  - Categories/Search
  - Chat/Messages
  - Profile
- **Centered Floating Action Button** for quick "Add Book" access

### Categories & Search
- Advanced search functionality
- Filter by categories (Fiction, Engineering, Islamic, Medical, etc.)
- Staggered grid view for browsing books
- Real-time search results

### Add Book
- Multi-step book listing form
- Image upload placeholder
- Toggle between "Sell" and "Donate"
- Fields: Title, Author, Category, Condition, Description, Price
- Clean form validation

### Chat & Messages
- Conversation list with unread counts
- Book-specific conversations
- User avatars and timestamps
- Clean, WhatsApp-style interface

### Profile & Settings
- User statistics (Trust Score, Listings, Completed Transactions)
- **My Listings** dashboard for sellers
  - Mark books as "Sold"
  - Edit/Delete listings
  - Visual sold indicator
- Settings:
  - Account details
  - Change location
  - Dark mode toggle
  - Logout

## 🎨 Design Highlights

- **Material 3 Design System** with modern, clean aesthetics
- **Google Fonts (Poppins)** for typography
- **Custom Slivers** for advanced scrolling effects
- Professional color scheme with purple primary color
- Responsive layouts
- Smooth animations and transitions

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6          # State management
  equatable: ^2.0.7             # Value equality
  google_fonts: ^6.2.1          # Typography
  carousel_slider: ^4.2.1       # Banner carousel
  flutter_staggered_grid_view: ^0.7.0  # Grid layouts
  font_awesome_flutter: ^10.7.0 # Icons
```

## 🏗️ Architecture

### State Management (Cubit)
```
lib/
├── cubits/
│   ├── auth/
│   │   ├── auth_cubit.dart
│   │   └── auth_state.dart
│   ├── home/
│   │   ├── home_cubit.dart
│   │   └── home_state.dart
│   ├── books/
│   │   ├── books_cubit.dart
│   │   └── books_state.dart
│   ├── chat/
│   │   ├── chat_cubit.dart
│   │   └── chat_state.dart
│   └── profile/
│       ├── profile_cubit.dart
│       └── profile_state.dart
```

### Models
```
lib/
├── models/
│   ├── book.dart
│   ├── user.dart
│   ├── chat_message.dart
│   └── banner_item.dart
```

### Screens
```
lib/
├── screens/
│   ├── splash_screen.dart
│   ├── main_navigation_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── categories/
│   │   └── categories_screen.dart
│   ├── add_book/
│   │   └── add_book_screen.dart
│   ├── chat/
│   │   └── chat_screen.dart
│   └── profile/
│       └── profile_screen.dart
```

### Data
```
lib/
├── data/
│   └── dummy_data.dart  # Contains all dummy data
```

## 🎯 Dummy Data

The app uses comprehensive dummy data including:
- **Current User** with profile information
- **10+ Books** across different categories
- **Donation Books** (free books)
- **Books for Sale** with prices and distances
- **3 Banner Items** for carousel
- **10 Categories** (Fiction, Engineering, Islamic, Medical, etc.)
- **Chat Conversations** with unread counts
- **User Listings** (active and sold)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Install dependencies**
```bash
flutter pub get
```

2. **Run the app**
```bash
flutter run
```

## 📱 Screens Overview

1. **Splash Screen** → Professional animated logo with tagline
2. **Login/Signup** → Complete authentication flow with location setup
3. **Home Dashboard** → Slivers-based scrolling with banners, categories, donate books, and nearby books
4. **Categories** → Advanced search and filtering
5. **Add Book** → Complete book listing form
6. **Chat** → Message list interface
7. **Profile** → User dashboard with listings management and settings

## 🎨 Key UI Features

### Slivers Implementation (Home Screen)
- `SliverAppBar` - Floating app bar with location
- `SliverToBoxAdapter` - Banner carousel and section headers
- `SliverGrid` - Grid layout for nearby books
- `CustomScrollView` - Smooth scrolling experience

### Book Card Design
- High-quality image placeholder
- Title and author
- Distance indicator
- Price or "FREE/DONATE" badge
- Category tag
- Condition indicator

### Bottom Navigation
- Clean, modern design
- Active state indicators
- Centered FAB for primary action
- Icon + label for clarity

## 🔄 State Management Flow

```dart
// Example: Loading home data
HomeCubit → loadHomeData()
  ↓
emit(HomeLoading())
  ↓
Fetch dummy data
  ↓
emit(HomeLoaded(
  banners: [...],
  categories: [...],
  donateBooks: [...],
  nearbyBooks: [...],
))
  ↓
UI updates automatically
```

## 🎨 Color Scheme

- **Primary**: `#6750A4` (Purple)
- **On Primary**: White
- **Primary Container**: Light purple
- **Surface**: White / Dark based on theme
- **Success**: Green (for donation badges)
- **Error**: Red (for delete actions)

## 📝 Next Steps (Future Implementation)

- [ ] Backend API integration
- [ ] Real image upload functionality
- [ ] Google Maps integration for location
- [ ] Firebase Authentication
- [ ] Real-time chat functionality
- [ ] Payment gateway integration
- [ ] Book recommendations algorithm
- [ ] User reviews and ratings
- [ ] Push notifications
- [ ] Advanced filtering options

## 👨‍💻 Code Quality

- ✅ Clean, readable code
- ✅ Proper folder structure
- ✅ Cubit-based state management
- ✅ Reusable widgets
- ✅ Consistent naming conventions
- ✅ Material 3 design principles
- ✅ Responsive layouts
- ✅ Null-safe Dart code

## 📄 License

This is a prototype application for educational and demonstration purposes.

---

**Built with ❤️ using Flutter & Material 3**

*Tagline: "Share Knowledge, Spread Joy"*
