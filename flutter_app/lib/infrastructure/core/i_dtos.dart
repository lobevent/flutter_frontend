abstract class IDto{
  IDto();
  IDto fromDomain();
  factory IDto.fromJson(Map<String, dynamic> val);
}