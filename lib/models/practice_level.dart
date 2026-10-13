enum PracticeLevel {
  beginner,
  intermediate,
  advanced,
  expert;

  String get label {
    switch (this) {
      case PracticeLevel.beginner:
        return 'Beginner';
      case PracticeLevel.intermediate:
        return 'Intermediate';
      case PracticeLevel.advanced:
        return 'Advanced';
      case PracticeLevel.expert:
        return 'Expert';
    }
  }

  PracticeLevel get next =>
      index < PracticeLevel.values.length - 1 ? PracticeLevel.values[index + 1] : this;

  PracticeLevel get previous =>
      index > 0 ? PracticeLevel.values[index - 1] : this;
}
