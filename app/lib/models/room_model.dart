class Room {
  late final String building;
  late final int capacity;
  late final String roomNumber;
  late final String type;

  Room({
    required this.building,
    required this.capacity,
    required this.roomNumber,
    required this.type,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      building: json['building'],
      capacity: json['capacity'],
      roomNumber: json['room_number'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'building': building,
      'capacity': capacity,
      'room_number': roomNumber,
      'type': type,
    };
  }
}
