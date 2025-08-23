const String sampleJson = '''
{
  "user": {
    "name": "Juan Dela Cruz",
    "avatarUrl": "https://i.pravatar.cc/150?img=3"
  },
  "todays_quizzes": [
    {"title": "Math Quiz 2", "time": "Available", "available": true, "locked": false},
    {"title": "English Quiz", "time": "10:30 AM", "available": false, "locked": false},
    {"title": "Science", "time": "Locked", "available": false, "locked": true}
  ],
  "recent_quizzes": [
    {"title": "Math Basics", "score": 10, "total": 10, "date": "2025-06-14"},
    {"title": "Science Week", "score": 1, "total": 10, "date": "2025-06-12"},
    {"title": "History Pop Quiz", "score": 10, "total": 10, "date": "2025-06-11"}
  ],
   "subjects": [
    { "label": "Math" },
    { "label": "Science" },
    { "label": "History" }
  ],
  "leaderboards": {
    "Math": [
      {"name": "Rhea Elizah A. Alfonso", "score": 150, "rank": 1},
      {"name": "Juan Dela Cruz", "score": 120, "rank": 2},
      {"name": "Mark", "score": 100, "rank": 3},
      {"name": "Jane", "score": 90, "rank": 4},
      {"name": "Anna", "score": 85, "rank": 5},
      {"name": "Student6", "score": 84, "rank": 6},
      {"name": "Student7", "score": 80, "rank": 7},
      {"name": "Student8", "score": 78, "rank": 8},
      {"name": "Student9", "score": 75, "rank": 9},
      {"name": "Student10", "score": 72, "rank": 10},
      {"name": "Student11", "score": 69, "rank": 11},
      {"name": "Student12", "score": 68, "rank": 12},
      {"name": "Student13", "score": 65, "rank": 13},
      {"name": "Student14", "score": 62, "rank": 14},
      {"name": "Student15", "score": 60, "rank": 15},
      {"name": "Student16", "score": 59, "rank": 16},
      {"name": "Student17", "score": 56, "rank": 17},
      {"name": "Student18", "score": 55, "rank": 18},
      {"name": "Student19", "score": 53, "rank": 19},
      {"name": "Student20", "score": 51, "rank": 20}
    ],
    "Science": [
      {"name": "Pedro", "score": 135, "rank": 1},
      {"name": "Ana", "score": 112, "rank": 2},
      {"name": "Juan Dela Cruz", "score": 99, "rank": 3}
    ],
    "History": [
      {"name": "Maria", "score": 130, "rank": 1},
      {"name": "Juan Dela Cruz", "score": 120, "rank": 2},
      {"name": "Jose", "score": 90, "rank": 3}
    ],
    "English": [
      {"name": "Ana", "score": 160, "rank": 1},
      {"name": "Jenny", "score": 115, "rank": 2},
      {"name": "Mark", "score": 88, "rank": 3}
    ]
  }
}
''';

