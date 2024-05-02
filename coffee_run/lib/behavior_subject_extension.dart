import 'package:rxdart/rxdart.dart';

// Extension off of Dart's stream class to convert Streams into RxDart Behavior Subjects
extension BehaviorSubjectExtension<T> on Stream<T> {
  BehaviorSubject<T> asBehaviorSubject() {
    final subject = BehaviorSubject<T>();
    listen(subject.add, onError: subject.addError, onDone: subject.close);
    return subject;
  }
}
