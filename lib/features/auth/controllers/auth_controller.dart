abstract class AuthController {
  Future<String?> registerUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  });
  Future<String?> loginUser({required String email, required String password});
}
