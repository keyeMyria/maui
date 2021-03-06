import 'dart:async';

import 'package:maui/db/entity/quiz_progress.dart';
import 'package:maui/db/dao/quiz_progress_dao.dart';

class QuizProgressRepo {
  static final QuizProgressDao quizProgressDao = QuizProgressDao();

  const QuizProgressRepo();

  Future<QuizProgress> getQuizProgressByQuizProgressId(String id) async {
    return await quizProgressDao.getQuizProgressByQuizProgressId(id);
  }

  Future<QuizProgress> getQuizProgressByTopicId(String topicId) async {
    return await quizProgressDao.getQuizProgressByTopicId(topicId);
  }
}