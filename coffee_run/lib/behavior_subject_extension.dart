import 'package:rxdart/rxdart.dart';

extension BehaviorSubjectExtension<T> on Stream<T> {
  BehaviorSubject<T> asBehaviorSubject() {
    final subject = BehaviorSubject<T>();
    listen(subject.add, onError: subject.addError, onDone: subject.close);
    return subject;
  }
}
