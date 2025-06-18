class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String baseUrlV1 = '$baseUrl/api/v1';

  // Request timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Products Endpoints
  static const String products = '/products';
  static const String categories = '/products/categories';
  static String productsByCategory(String category) => '/products/category/$category';
  static String productById(int id) => '/products/$id';
  static String productsWithLimit(int limit) => '/products?limit=$limit';
  static String productsWithPagination(int limit, int skip) => '/products?limit=$limit&skip=$skip';
  static String productsSorted(String sort) => '/products?sort=$sort'; // asc or desc

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/users'; // Fake Store API uses this for user creation

  // Users Endpoints
  static const String users = '/users';
  static String userById(int id) => '/users/$id';
  static String usersWithLimit(int limit) => '/users?limit=$limit';

  // Cart Endpoints
  static const String carts = '/carts';
  static String cartById(int id) => '/carts/$id';
  static String userCarts(int userId) => '/carts/user/$userId';
  static String cartsWithDateRange(String startDate, String endDate) =>
      '/carts?startdate=$startDate&enddate=$endDate';
  static String cartsWithLimit(int limit) => '/carts?limit=$limit';
  static String cartsSorted(String sort) => '/carts?sort=$sort';

  // Search and Filter Parameters
  static const String searchParam = 'search';
  static const String categoryParam = 'category';
  static const String sortParam = 'sort';
  static const String limitParam = 'limit';
  static const String skipParam = 'skip';
  static const String startDateParam = 'startdate';
  static const String endDateParam = 'enddate';

  // Sort Options
  static const String sortAscending = 'asc';
  static const String sortDescending = 'desc';

  // Default Values
  static const int defaultLimit = 20;
  static const int defaultPage = 1;
  static const int maxLimit = 100;

  // Cache Keys
  static const String cacheProducts = 'cache_products';
  static const String cacheCategories = 'cache_categories';
  static const String cacheUser = 'cache_user';
  static const String cacheCart = 'cache_cart';

  // Error Messages
  static const String networkErrorMessage = 'Network error occurred';
  static const String serverErrorMessage = 'Server error occurred';
  static const String timeoutErrorMessage = 'Request timeout';
  static const String unauthorizedErrorMessage = 'Unauthorized access';
  static const String notFoundErrorMessage = 'Resource not found';
  static const String badRequestErrorMessage = 'Bad request';

  // Status Codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusInternalServerError = 500;
  static const int statusBadGateway = 502;
  static const int statusServiceUnavailable = 503;
}