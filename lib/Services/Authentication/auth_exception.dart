//login exceptions
class UserNotFoundAuthException implements Exception {}
class WrongPasswordAuthException implements Exception {}
//register exceptions
class WeakPasswordAuthException implements Exception {}
class EmailAlreadyInUseAuthException implements Exception {}
class EmailNotFoundAuthException implements Exception{}
class InvalidEmailAuthException implements Exception {}
class EmailNotSentAuthException implements Exception{}
class UserDisabledAuthException implements Exception{}

class TooManyRequestsAuthException implements Exception{}

class NetworkRequestFailedException implements Exception{}



//generic exceptions
class GenericAuthException implements Exception{}

class UserNotLoggedInAuthException implements Exception {}