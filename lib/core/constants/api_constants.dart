class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://fakestoreapi.com';

  // Request timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Products Endpoints (following API doc exactly)
  static const String products = '/products';
  static String productById(int id) => '/products/$id';

  // Products with query parameters (API supports these)
  static String productsWithLimit(int limit) => '/products?limit=$limit';
  static String productsWithSort(String sort) => '/products?sort=$sort'; // 'asc' or 'desc'
  static String productsWithLimitAndSort(int limit, String sort) =>
      '/products?limit=$limit&sort=$sort';

  // Categories (API supports these)
  static const String categories = '/products/categories';
  static String productsByCategory(String category) => '/products/category/$category';
  static String productsByCategoryWithLimit(String category, int limit) =>
      '/products/category/$category?limit=$limit';
  static String productsByCategoryWithSort(String category, String sort) =>
      '/products/category/$category?sort=$sort';

  // Users Endpoints (following API doc exactly)
  static const String users = '/users';
  static String userById(int id) => '/users/$id';
  static String usersWithLimit(int limit) => '/users?limit=$limit';
  static String usersWithSort(String sort) => '/users?sort=$sort';

  // Carts Endpoints (following API doc exactly)
  static const String carts = '/carts';
  static String cartById(int id) => '/carts/$id';
  static String cartsWithLimit(int limit) => '/carts?limit=$limit';
  static String cartsWithSort(String sort) => '/carts?sort=$sort';
  static String cartsWithDateRange(String startDate, String endDate) =>
      '/carts?startdate=$startDate&enddate=$endDate';
  static String userCarts(int userId) => '/carts/user/$userId';

  // Auth Endpoints (following API doc exactly)
  static const String login = '/auth/login';

  // Sort Options
  static const String sortAscending = 'asc';
  static const String sortDescending = 'desc';

  // Default Values
  static const int defaultLimit = 20;
  static const int maxLimit = 100;

  // Status Codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusNotFound = 404;
  static const int statusInternalServerError = 500;
}