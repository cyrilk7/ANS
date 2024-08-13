class Room {
  late final String building;
  late final int capacity;
  late final String roomNumber;
  late final String roomName;
  late final String type;

  Room({
    required this.building,
    required this.capacity,
    required this.roomNumber,
    required this.type,
    required this.roomName
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      building: json['building'],
      capacity: json['capacity'],
      roomNumber: json['room_number'],
      type: json['type'],
      roomName: json['room_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'building': building,
      'capacity': capacity,
      'room_number': roomNumber,
      'type': type,
      'room_name': roomName,
    };
  }
}
