# Expense Tracker Lite

A lightweight expense tracking mobile application built with Flutter, featuring currency conversion, pagination, and custom UI following the BLoC pattern.

## 🎯 Features

### Core Features
- ✅ **Dashboard Screen**
  - User welcome message and profile display
  - Total balance, income, and expenses summary
  - Filter options (This Month, Last 7 Days, All Time)
  - Paginated list of recent expenses
  - Floating action button to add new expenses

- ✅ **Add Expense Screen**
  - Category selection with visual icons
  - Amount input with currency selection
  - Date picker
  - Receipt upload (image)
  - Save functionality with validation

- ✅ **Currency Conversion**
  - Real-time exchange rate fetching from API
  - Automatic conversion to USD for all expenses
  - Display both original and converted amounts
  - Support for multiple currencies (USD, EUR, GBP, JPY, EGP)

- ✅ **Pagination**
  - Infinite scroll with 10 items per page
  - Loading states and empty state handling
  - Filter-aware pagination
  - Performance optimized for large datasets

- ✅ **Local Storage**
  - Hive database for efficient offline storage
  - Persistent data across app restarts
  - Fast read/write operations

## 🏗️ Architecture

### Clean Architecture + BLoC Pattern

```
lib/
├── core/
│   ├── di/                     # Dependency Injection
│   │   └── injection_container.dart
│   ├── error/                  # Error handling
│   │   └── failures.dart
│   └── theme/                  # App theming
│       └── app_theme.dart
│
├── features/
│   ├── expenses/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── expense_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── expense_model.dart
│   │   │   │   └── expense_model.g.dart
│   │   │   └── repositories/
│   │   │       └── expense_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── expense.dart
│   │   │   ├── repositories/
│   │   │   │   └── expense_repository.dart
│   │   │   └── usecases/
│   │   │       ├── add_expense.dart
│   │   │       ├── delete_expense.dart
│   │   │       ├── get_expenses.dart
│   │   │       └── update_expense.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── expenses_bloc.dart
│   │       │   ├── expenses_event.dart
│   │       │   └── expenses_state.dart
│   │       ├── pages/
│   │       │   ├── dashboard_page.dart
│   │       │   └── add_expense_page.dart
│   │       └── widgets/
│   │           ├── balance_card.dart
│   │           ├── category_selector.dart
│   │           ├── expense_list_item.dart
│   │           └── filter_chip.dart
│   │
│   └── currency/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── currency_remote_data_source.dart
│       │   └── repositories/
│       │       └── currency_repository_impl.dart
│       └── domain/
│           ├── repositories/
│           │   └── currency_repository.dart
│           └── usecases/
│               └── get_exchange_rate.dart
│
└── main.dart
```

### Design Patterns Used

1. **BLoC (Business Logic Component)**
   - Separates business logic from UI
   - Manages state transitions
   - Reactive programming with streams
   - Each feature has its own Bloc

2. **Repository Pattern**
   - Abstracts data sources
   - Single source of truth
   - Easy to mock for testing

3. **Dependency Injection**
   - Using GetIt service locator
   - Loose coupling between layers
   - Easier testing and maintenance

## 🔧 State Management Approach

### BLoC Pattern Implementation

The app uses **flutter_bloc** package with proper separation of concerns:

#### Events
```dart
- LoadExpensesEvent      // Load expenses with optional filters
- AddExpenseEvent        // Add new expense
- UpdateExpenseEvent     // Update existing expense
- DeleteExpenseEvent     // Delete expense
- FilterExpensesEvent    // Apply date filters
```

#### States
```dart
- ExpensesInitial        // Initial state
- ExpensesLoading        // Loading data
- ExpensesLoaded         // Data loaded successfully
- ExpensesError          // Error occurred
- ExpenseAdding          // Adding new expense
- ExpenseAdded           // Expense added successfully
- ExpenseAddError        // Error adding expense
```

#### BLoC Flow
1. UI dispatches an event
2. BLoC processes the event
3. BLoC calls appropriate use case
4. Use case executes business logic
5. Repository fetches/stores data
6. BLoC emits new state
7. UI rebuilds based on new state

## 🌐 API Integration

### Currency Conversion API

**Endpoint**: https://open.er-api.com/v6/latest/USD

**Features**:
- No API key required
- Real-time exchange rates
- Support for 160+ currencies
- Reliable and fast

**Implementation**:
```dart
// When saving an expense
1. User enters amount in their currency (e.g., 100 EUR)
2. App fetches exchange rate from API
3. Amount is converted to USD (e.g., 100 * 1.09 = 109 USD)
4. Both amounts are stored:
   - Original: 100 EUR
   - Converted: 109 USD
5. Dashboard shows USD totals
6. Expense list shows both amounts
```

## 📄 Pagination Strategy

### Local Pagination

- **Page Size**: 10 items
- **Implementation**: Offset-based pagination
- **Scroll Detection**: Infinite scroll at 90% of list
- **Filter Integration**: Pagination respects active filters

```dart
// Pagination Flow
1. Load initial 10 expenses
2. User scrolls to bottom (90% threshold)
3. Check if more items exist
4. Load next 10 items
5. Append to existing list
6. Update hasMore flag
```

### Benefits
- Smooth scrolling experience
- Reduced memory usage
- Fast initial load time
- Works offline

## 🎨 UI Implementation

The UI closely follows the provided Dribbble design with:

- **Typography**: Google Fonts (Inter)
- **Color Scheme**: 
  - Primary: #4C6FFF (Blue)
  - Background: #F5F7FA (Light Gray)
  - Success: #4CAF50 (Green)
  - Error: #FF5252 (Red)

- **Components**:
  - Gradient balance card with stats
  - Category icons with color coding
  - Smooth animations
  - Material Design 3
  - Custom shadows and elevations

## 🚀 How to Run

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation Steps

1. **Clone the repository**
```bash
git clone <repository-url>
cd expense_tracker
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate Hive adapters** (if needed)
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

### Running on specific platform
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome
```

## 🧪 Testing

### Unit Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/expenses_bloc_test.dart

# Run with coverage
flutter test --coverage
```

### Test Coverage

The project includes tests for:
- ✅ Expense validation logic
- ✅ Currency calculation
- ✅ BLoC state transitions
- ✅ Repository operations

Example test file: `test/features/expenses/presentation/bloc/expenses_bloc_test.dart`

## 📦 Dependencies

### Main Dependencies
```yaml
flutter_bloc: ^8.1.3          # State management
hive: ^2.2.3                   # Local database
http: ^1.1.0                   # HTTP client
equatable: ^2.0.5              # Value comparison
dartz: ^0.10.1                 # Functional programming
get_it: ^7.6.4                 # Dependency injection
intl: ^0.18.1                  # Internationalization
image_picker: ^1.0.4           # Image selection
google_fonts: ^6.1.0           # Custom fonts
uuid: ^4.2.1                   # UUID generation
```

### Dev Dependencies
```yaml
flutter_test: sdk             # Testing framework
bloc_test: ^9.1.5             # BLoC testing
mocktail: ^1.0.1              # Mocking
build_runner: ^2.4.6          # Code generation
hive_generator: ^2.0.1        # Hive adapter generation
```

## 🔄 Trade-offs & Design Decisions

### 1. Local-First Approach
**Decision**: Use Hive for local storage instead of a remote backend  
**Trade-off**: No cloud sync, but faster performance and offline-first

**Reasoning**: 
- Better user experience (instant response)
- No network dependency for core features
- Simpler architecture for MVP
- Easy to add backend later

### 2. Pagination Implementation
**Decision**: Client-side pagination with Hive  
**Trade-off**: All data in memory, but simpler implementation

**Reasoning**:
- Hive is extremely fast
- Expected dataset size is manageable
- No network latency
- Easier to implement filters

### 3. Currency Conversion
**Decision**: Fetch rate on-demand when adding expense  
**Trade-off**: Network dependency, but always accurate

**Reasoning**:
- Most accurate conversion
- No need to cache rates
- Simple implementation
- Acceptable UX (one-time fetch)

### 4. BLoC over Cubit
**Decision**: Use Bloc instead of Cubit  
**Trade-off**: More boilerplate, but explicit event tracking

**Reasoning**:
- Requirement from project spec
- Better event history tracking
- More suitable for complex flows
- Easier debugging

## 🐛 Known Issues / Future Enhancements

### Known Issues
- Receipt images are stored as file paths (not uploaded to cloud)
- No edit expense functionality yet
- Category icons are limited to predefined set

### Future Enhancements
1. **Analytics Dashboard**
   - Spending trends
   - Category-wise breakdown
   - Monthly comparisons

2. **Export Features**
   - CSV export
   - PDF reports
   - Email sharing

3. **Advanced Filters**
   - Category filter
   - Amount range filter
   - Custom date ranges

4. **Cloud Sync**
   - Firebase integration
   - Multi-device support
   - Backup & restore

5. **Receipt OCR**
   - Auto-extract amount from receipt
   - Category detection
   - Date parsing

## 📊 Performance Optimizations

- ✅ Lazy loading with pagination
- ✅ Hive for fast local storage
- ✅ Cached network images
- ✅ Efficient state management with BLoC
- ✅ ListView builder for large lists
- ✅ Const constructors where possible

## 📝 Code Quality

- ✅ Clean Architecture principles
- ✅ SOLID principles
- ✅ Comprehensive documentation
- ✅ Type-safe code
- ✅ Error handling
- ✅ Null safety
