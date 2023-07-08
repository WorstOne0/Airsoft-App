class Story {
  late int id;

  late int storieIndex;
  late bool hasSeen;

  late String userName;
  late String userPicture;

  late String storyImage;

  // Remove later - Story.fromJson()
  Story(
    this.id,
    this.storieIndex,
    this.hasSeen,
    this.userName,
    this.userPicture,
    this.storyImage,
  );
}
