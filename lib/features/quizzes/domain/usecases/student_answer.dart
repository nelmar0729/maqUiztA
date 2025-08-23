import '/features/quizzes/data/repositories/repository.dart';
import '/shared/response.dart';

class StudentAnswer {
  Repository repository;

  StudentAnswer(this.repository);
  Future<ResponseResult> call(
    String userId,
    int quizId,
    int questionId,
    int choiceId,
  ) {
    return repository.studentAnswer(
      userId,
      quizId,
      questionId,
      choiceId
  
    );
  }
}
