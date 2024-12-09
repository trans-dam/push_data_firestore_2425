import 'package:dto/models.dart';
import 'package:push_data_firestore/data/users.dart';

List<Team> teams = [
  Team(
    title: "💻 Code Magicians",
    picturePath: "assets/img/team-1.png",
    startDate: DateTime(2023, 8, 31),
    users: [users[0].email, users[1].email, users[2].email],
    tags: const ["Coding", "Magic", "Geeks"],
  ),
  Team(
    title: "🌐 Web Weavers",
    picturePath: "assets/img/team-2.png",
    startDate: DateTime(2023, 9, 15),
    users: [users[3].email, users[4].email, users[5].email],
    tags: const ["Web Development", "Design", "Networking"],
  ),
  Team(
    title: "🎮 Game Gurus",
    picturePath: "assets/img/team-3.png",
    startDate: DateTime(2023, 9, 30),
    users: [users[0].email, users[2].email, users[4].email],
  ),
  Team(
    title: "✨ nouveau groupe",
    picturePath: "assets/img/team-4.png",
    startDate: DateTime(2023, 9, 30),
    users: [users[0].email, users[2].email, users[4].email],
  ),
];
