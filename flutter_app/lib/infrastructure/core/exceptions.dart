class CommunicationException implements Exception {}

class NotAuthenticatedException implements CommunicationException {}
class NotAuthorizedException implements CommunicationException {}
class NotFoundException implements CommunicationException {}
class InternalServerException implements CommunicationException {}
class UnexpectedTypeException implements Exception {}