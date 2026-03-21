# Waseela — BNPL Flutter Assessment

A mini **Buy Now, Pay Later (BNPL)** feature built with Flutter as part of the
Waseela – Aur Finance Senior Flutter Developer assessment.

---

## 📱 Features

### Core (Mandatory)
- **Screen 1 – Product Checkout:** Product card with BNPL installment plan previews
- **Screen 2 – Installment Plan Selection:** Dynamic plan selection with repayment schedule
- **Screen 3 – Order Confirmation:** Simulated payment status (Pending / Approved)
- Clean Architecture (data / domain / presentation layers)
- BLoC state management
- Mock REST API via MockAPI.io
- Error handling — network errors, empty states, loading states (Shimmer)
- Unit tests — CalculateInstallmentUseCase + ProductBloc + InstallmentBloc
- Secure config — API base URL via `.env`, never hardcoded

### Bonus
- Biometric authentication before order confirmation
- ✅ Offline support — products & plans cached with Hive (AES-256 encrypted)
- ✅ Linting — `flutter_lints` with extended custom rules
- ✅ CI pipeline — GitHub Actions (runs tests on push to main)
- ✅ Accessibility labels — Semantics added to order confirmation flow
- ⬜ Widget tests

---

## Architecture

This project follows **Clean Architecture** with 3 layers:

```
lib/
├── app.dart
├── main.dart
│
├── core/
│   ├── config/              # AppConfig + dotenv
│   ├── di/                  # GetIt + injectable (datasources, repos, services)
│   ├── errors/              # Failure, ErrorHandler
│   ├── network/             # NetworkInfo (connectivity check)
│   ├── routes/              # RouteGenerator, Routes, Guards
│   ├── services/
│   │   ├── api/             # DioConsumer, interceptors, RequestQueue
│   │   ├── biometric/       # LocalAuth wrapper (contract + impl + factory)
│   │   ├── crashlytics/     # CrashlyticsLogger
│   │   ├── local_storage/   # HiveConsumer (AES-256 encrypted)
│   │   ├── navigation/      # NavigationService, extensions, RouteGenerator
│   │   └── performance/     # PerformanceService
│   ├── theme/               # AppTheme, AppColors, AppTypography
│   ├── usecases/            # Base UseCase<Type, Params>
│   ├── utils/               # AppStrings, AppImages, Constants, Extensions
│   └── widgets/             # CustomAppBar, CustomButton, CustomToast, CustomNetworkImage
│
└── features/
    └── bnpl/
        ├── data/
        │   ├── datasources/
        │   │   ├── local/   # BnplLocalDatasource (contract + Hive impl)
        │   │   └── remote/  # BnplRemoteDatasource (contract + MockAPI impl)
        │   ├── models/      # ProductModel, InstallmentPlanModel, OrderModel
        │   └── repositories/# BnplRepositoryImpl (remote-first + local fallback)
        ├── domain/
        │   ├── entities/    # ProductEntity, InstallmentPlanEntity, OrderEntity,
        │   │                # RepaymentScheduleEntry, CalculateParams,
        │   │                # InstallmentCalcResult, OrderParam
        │   ├── repositories/# BnplRepository (abstract contract)
        │   └── usecases/    # CalculateInstallmentUseCase
        └── presentation/
            ├── bloc/
            │   ├── installment/ # InstallmentBloc — calculation
            │   ├── order/       # OrderBloc — biometric + order simulation
            │   └── product/     # ProductBloc — fetch, select, empty
            ├── pages/           # ProductCheckoutScreen, InstallmentPlanScreen,
            │                    # OrderConfirmationScreen
            └── widgets/
                ├── installment/ # PlanCard, RepaymentSchedule, Summary, Shimmer
                ├── order/       # OrderConfirmationWidget, OrderStatusIcon, OrderSummaryCard
                └── product/     # ProductCard, CheckoutBody, PreviewSection,
                                 # Shimmer, Empty, Error, FloatingButton
```

### Use Case Decision

To avoid over-engineering, use cases were only created where real business logic exists:

| Scenario | Decision |
|----------|----------|
| `CalculateInstallmentUseCase` — interest + fees + repayment schedule | ✅ Use Case |
| `getProducts()` — simple API fetch, no transformation | ❌ Direct repo call from BLoC |
| `getInstallmentPlans()` — simple API fetch, no transformation | ❌ Direct repo call from BLoC |
| `createOrder()` — mock simulation, no domain logic | ❌ Direct repo call from BLoC |

### Why BLoC?

BLoC was chosen for the following reasons:

- **Explicit state transitions** — in a FinTech flow, every state (loading → success → error)
  must be clearly traceable and auditable
- **Event/State separation** — makes the payment flow easy to reason about and debug
- **Testability** — `bloc_test` provides a clean DSL with `blocTest()`, `seed()`, and `verify()`
- **Industry adoption** — widely used in Flutter FinTech projects and well-supported
  by the Flutter team

---

## API

### Remote — MockAPI.io
Base URL is loaded from `.env` — see setup instructions below.

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/products` | Fetch all products |
| GET | `/installment-plans` | Fetch all BNPL plans |

### Simulated — Local Mock
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | ` | Simulated order creation with 2s delay |

> Order creation is intentionally simulated locally to demonstrate
> business logic handling of payment states (Pending/Approved) without
> requiring a real payment gateway.

---

## Installment Calculation

```
totalInterest      = price × interestRate
totalAmount        = price + totalInterest + processingFee
monthlyInstallment = totalAmount ÷ months
```

**Example:** EGP 15,000 on 6-month plan (5% interest + EGP 150 fee):
```
totalInterest      = 15,000 × 0.05         =   750
totalAmount        = 15,000 + 750 + 150    = 15,900
monthlyInstallment = 15,900 ÷ 6           = EGP 2,650/month
```
---

## Security

- API base URL loaded from `.env` via `flutter_dotenv` — never hardcoded
- `.env` is listed in `.gitignore` — `.env.example` is provided as a template
- Hive local storage is **AES-256 encrypted**
- Encryption key generated via `Hive.generateSecureKey()` and stored in
  `FlutterSecureStorage` (Android: `EncryptedSharedPreferences`)
- Sensitive fields are redacted in network interceptor logs

---

## Setup

### Prerequisites
- Flutter `3.38.5` (channel stable) / SDK `^3.10.4`
- Android Studio or VS Code
- Android emulator or physical device (Android only)

### 1. Clone the repository
```bash
git clone https://github.com/sayedmoataz/waseela-hiring-task.git
cd waseela
```

### 2. Create the `.env` file
```bash
cp .env.example .env
```
Open `.env` and fill in:
```env
BASE_URL=https://your-mockapi-id.mockapi.io/api/v1
APP_ENV=development
ENABLE_LOGGING=true
```

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Generate DI & Mocks
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the app
```bash
flutter run
```

---

## Testing

Tests follow the **AAA pattern** (Arrange → Act → Assert) consistently across
all test files, with `blocTest()` mapping naturally to this structure via
`build` (Arrange), `act` (Act), and `expect`/`verify` (Assert).

| Type | Suite | Coverage |
|------|-------|----------|
| Unit | `CalculateInstallmentUseCase` | Happy path, repayment schedule, due dates, edge cases |
| BLoC | `ProductBloc` | Fetch, empty state, error, selection, Equatable dedup |

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific suite
flutter test test/features/bnpl/domain/usecases/
flutter test test/features/bnpl/presentation/bloc/
```

### CI Pipeline

GitHub Actions runs the full test suite on every push or pull request to `main`.
The workflow was validated locally using [act](https://github.com/nektos/act)
(Docker-based GitHub Actions runner) before pushing:

```bash
act push
```

---

## Known Limitations

- **Order API is simulated** — production would integrate a real payment gateway (e.g., Paymob, Stripe)
- **Android only** — iOS not configured in this submission
- **Biometric fallback** — if the device has no enrolled biometric, the user can proceed without authentication
- **No widget tests** — unit and BLoC tests are covered; widget tests are outside the scope of this submission
- **No dark mode** — light theme only
- **Single product flow** — checkout is designed around one selected product at a time

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `get_it` + `injectable` | Dependency injection |
| `dartz` | Functional error handling (`Either`) |
| `dio` | HTTP client |
| `hive_flutter` | Encrypted local storage (offline cache) |
| `local_auth` | Biometric authentication |
| `flutter_dotenv` | Environment variable management |
| `flutter_secure_storage` | Hive encryption key storage |
| `equatable` | Value equality for entities/states |
| `shimmer` | Loading skeleton UI |
| `cached_network_image` | Efficient image loading & caching |
| `bloc_test` + `mockito` | Unit & BLoC testing |

---

## Author

**Sayed Moataz**
Senior Flutter Developer