

class Home {
  final String id;
  final String name;
  final String? location;
  final List<Room> rooms;
  final List<HomeMember> members;

  Home({
    required this.id,
    required this.name,
    this.location,
    this.rooms = const [],
    this.members = const [],
  });

  Home copyWith({
    String? id,
    String? name,
    String? location,
    List<Room>? rooms,
    List<HomeMember>? members,
  }) {
    return Home(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      rooms: rooms ?? this.rooms,
      members: members ?? this.members,
    );
  }

  int get deviceCount => rooms.fold<int>(0, (sum, room) => sum + room.devices);
  int get roomCount => rooms.length;
  int get memberCount => members.length;
}

class Room {
  final String id;
  final String name;
  final int devices;

  const Room({
    required this.id,
    required this.name,
    this.devices = 0,
  });

  Room copyWith({
    String? id,
    String? name,
    int? devices,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      devices: devices ?? this.devices,
    );
  }
}

class HomeMember {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final HomeMemberRole role;
  final bool isCurrentUser;

  const HomeMember({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
    this.isCurrentUser = false,
  });

  String get roleDisplay {
    switch (role) {
      case HomeMemberRole.owner:
        return 'Owner';
      case HomeMemberRole.admin:
        return 'Admin';
      case HomeMemberRole.member:
        return 'Member';
    }
  }

  HomeMember copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    HomeMemberRole? role,
    bool? isCurrentUser,
  }) {
    return HomeMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}

enum HomeMemberRole { owner, admin, member }
