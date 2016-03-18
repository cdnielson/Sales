library exercice_item;

import "package:polymer/polymer.dart";

@CustomTag('exercise-list')
class ExerciseList extends PolymerElement {
  @observable ObservableList data;
  ExerciseList.created() : super.created();
  // lifecycle method
  void ready() {
    data = toObservable([new Person('Bob'), new Person('Tim')]);
  }

  showModal(event, detail, target) {
    var index = target.attributes['index'];
    shadowRoot.querySelector('div[index="$index"] paper-action-dialog').toggle();
  }
  updateExercise(event, detail, target){
    String id = target.dataset['ex-id'];
    print(id);
  }
}

class Person extends Observable {
  // mandatory field
  @observable int index;
  // mandatory field
  @observable bool selected;
  //model
  @observable String name;
  Person(this.name);
}
