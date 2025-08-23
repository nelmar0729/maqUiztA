import '/features/quizzes/data/repositories/repository.dart';
import '/features/quizzes/data/models/quiz_model.dart';

class FetchQuizzes {
  Repository repository;

  FetchQuizzes(this.repository);

  Future<List<QuizModel>> call(String userId) {
    return repository.fetchQuizzes(userId);
  }
}
