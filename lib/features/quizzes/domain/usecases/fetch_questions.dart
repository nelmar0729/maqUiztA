import '/features/quizzes/data/repositories/repository.dart';
import '/features/quizzes/data/models/question_model.dart';

class FetchQuestions {
  Repository repository;

  FetchQuestions(this.repository);

  Future<List<QuestionModel>> call(int quizId) {
    return repository.fetchQuestions(quizId);
  }
}
