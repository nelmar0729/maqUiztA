// --- JSON string for quizzes ---
const String quizzesJson = '''

 [
  {
    "quiz_id": 1,
    "subject_id": 1,
    "title": "Math Basics",
    "description": "Test your skills on basic arithmetic and algebra.",
    "difficulty": "Easy",
    "color": 38075196,
    "created_by": 5,
    "scheduled_at": "2025-07-07T15:22:00Z",
    "timer_per_question": 15,
    "status": "active",
    "created_at": "2025-07-01 12:00:00",
    "updated_at": "2025-07-02 09:30:00",
    "is_deleted": 0,
    "deleted_at": null,
    "restored_at": null
  },
  {
    "quiz_id": 2,
    "subject_id": 2,
    "title": "Science Facts",
    "description": "Challenge yourself with science trivia.",
    "difficulty": "Medium",
    "color": 26602377,
    "created_by": 6,
    "scheduled_at": "2025-07-07T15:00:00Z",
    "timer_per_question": 20,
    "status": "active",
    "created_at": "2025-07-01 13:00:00",
    "updated_at": "2025-07-02 10:15:00",
    "is_deleted": 0,
    "deleted_at": null,
    "restored_at": null
  },
  {
    "quiz_id": 3,
    "subject_id": 3,
    "title": "World History",
    "description": "How well do you know global history?",
    "difficulty": "Hard",
    "color": 16248241,
    "created_by": 7,
    "scheduled_at": "2025-07-08T16:40:00Z",
    "timer_per_question": 25,
    "status": "pending",
    "created_at": "2025-07-01 14:00:00",
    "updated_at": "2025-07-02 11:05:00",
    "is_deleted": 0,
    "deleted_at": null,
    "restored_at": null
  },
  {
    "quiz_id": 4,
    "subject_id": 4,
    "title": "English Vocabulary",
    "description": "Test your knowledge of English words.",
    "difficulty": "Medium",
    "color": 15174770,
    "created_by": 8,
    "scheduled_at": "2025-07-08T16:40:00Z",
    "timer_per_question": 18,
    "status": "completed",
    "created_at": "2025-07-01 15:00:00",
    "updated_at": "2025-07-02 12:20:00",
    "is_deleted": 0,
    "deleted_at": null,
    "restored_at": null
  }
]

''';

// Your quiz questions in JSON string format
const String questionsJson = '''
[
  {
    "question": "What is the capital of France?",
    "choices": ["Berlin", "Madrid", "Paris", "London"],
    "answer": "Paris"
  },
  {
    "question": "Which planet is known as the Red Planet?",
    "choices": ["Earth", "Mars", "Jupiter", "Venus"],
    "answer": "Mars"
  },
  {
    "question": "Who wrote \\"Romeo and Juliet\\"?",
    "choices": [
      "Charles Dickens",
      "William Shakespeare",
      "Jane Austen",
      "Leo Tolstoy"
    ],
    "answer": "William Shakespeare"
  }
]
''';

const String leaderboardJson = '''
[
  {
    "name": "Juan Dela Cruz",
    "score": 15,
    "avatarUrl": "https://i.pravatar.cc/150?img=1"
  },
  {
    "name": "Maria Santos",
    "score": 13,
    "avatarUrl": "https://i.pravatar.cc/150?img=2"
  },
  {
    "name": "Pedro Reyes",
    "score": 11,
    "avatarUrl": "https://i.pravatar.cc/150?img=3"
  },
  {
    "name": "Ana Lopez",
    "score": 9,
    "avatarUrl": "https://i.pravatar.cc/150?img=4"
  },
  {
    "name": "Jose Lim",
    "score": 7,
    "avatarUrl": "https://i.pravatar.cc/150?img=5"
  }
]
''';
