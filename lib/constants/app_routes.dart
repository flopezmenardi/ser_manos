class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const initial = '/initial';
  static const login = '/login';
  static const register = '/register';
  static const volunteerings = '/volunteerings';
  static const news = '/news';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const volunteeringBase = '/volunteering';

  static String newsDetail(String id) => '/news/$id';
  static String volunteeringDetail(String id) => '/volunteering/$id';
}