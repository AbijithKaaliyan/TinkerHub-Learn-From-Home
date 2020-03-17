import 'dart:io';

// Dart class to store the details of learners/mentors
class ApplicantData {
  final String name;              // name of applicant
  final String organization;      // name of the college/organization

  String role;                    // learner/mentor
  List<String> interests;         // list of interests for learners
  List<DateTime> availableTimes;  // list of times when the mentor is available 
  List<String> expertise;         // list of expertise of mentors

  // Constructor
  ApplicantData({this.name, this.organization}) {
    this.interests = [];
    this.expertise = [];
  }

   // To set whether the person is learner or mentor
  void setMentorOrLearner(int r) {
    r == 1 ? role = 'learner' : role = 'mentor';
  }

  // To include new interests to the interests list
  void addStacks(List<String> newInterests) {
    interests = [...interests, ...newInterests];
  }

  void setAvailableTime(List<DateTime> times) {
    availableTimes = times;
  }

  // find available mentors based on expertise and time slots.
  void getMentor(DateTime time, List<String> interests, List<Map<String, List<Object>>> mentorData) {
    print('\nAVAILABLE MENTORS');
    bool flag = false;

    mentorData.forEach((mData) {
      interests.forEach((interest) {
        if(mData['expertise'].contains(interest) && mData['timeslots'].contains(time)) {
          stdout.write('\nNAME: ' + mData['name'][0]+ '\nEXPERTISE: ' + interest + '\nTIME SLOT: ');

          for(var i=11; i<=15; i++) {
            stdout.write(time.toString()[i]);
          }
          flag = true;
        }
      });
    });

    if(flag == false) {
      print('No mentors available for the given interests and timeslots');
    }
  }
}

void main() {
  List<ApplicantData> applicantList = [];

  int role = 0, choice = 0;
  String name, organization;
  List<DateTime> availableTimes; 
  List<Map<String, List<Object>>> mentorData = [];

  while(choice != 2) {
    // Application menu is used to enter new learners/mentors. It runs as long as the user does not choose exit.
    print('\n\n   (＾▽ ＾)  WELCOME  (＾▽ ＾)');
    print('\n--- APPLICATION MENU ---');
    print('1. New Applicant');
    print('2. Exit');
    stdout.write('Enter choice: ');
    choice = int.parse(stdin.readLineSync());

    if(choice == 2) {
      print('\n\nExiting...');
      exit(0);
    }

    stdout.write('\nEnter name: ');
    name = stdin.readLineSync();
    
    stdout.write('Enter organization: ');
    organization = stdin.readLineSync();

    role = 0;
    print('\nCHOOSE ROLE');
    while (![1, 2].contains(role)) {
      print('1. Learner');
      print('2. Mentor');
      stdout.write('Enter choice: ');
      role = int.parse(stdin.readLineSync());
      
      switch(role) {
        // When learner is chosen
        case 1:   
          String newInterests;
          List<String> interests = [];
          ApplicantData learner = ApplicantData(name: name, organization: organization);

          learner.setMentorOrLearner(1);
          stdout.write('Enter interests (eg: Flutter,Java Script): ');
          newInterests = stdin.readLineSync();
          interests = newInterests.split(',');
          learner.addStacks(interests);

          stdout.write('Enter time slot to select mentor (eg 04:00): ');
          String time = stdin.readLineSync();
          learner.getMentor(DateTime.parse('2020-03-17 ' + time.replaceAll(' ', '') + ':00Z'), learner.interests, mentorData);
  
          applicantList.add(learner);
          break;

        // When mentor is chosen
        case 2:
          String expertise;
          ApplicantData mentor = ApplicantData(name: name, organization: organization);

          mentor.setMentorOrLearner(2);

          stdout.write('\nEnter expertise (eg: Flutter,React): ');
          expertise = stdin.readLineSync();
          mentor.expertise = expertise.split(',');

          availableTimes = [];
          stdout.write('Enter available times (eg. 08:30, 16:00): ');
          List<String> availableTime = stdin.readLineSync().split(',');
          availableTime.forEach((element) => availableTimes.add(DateTime.parse('2020-03-17 ' + element.replaceAll(' ', '') + ':00Z')));
          mentor.setAvailableTime(availableTimes);

          mentorData.add({
            "name" : [mentor.name],
            "expertise": mentor.expertise,
            "timeslots": mentor.availableTimes
          });

          applicantList.add(mentor);
          break;

        default:  print('Invalid Input!');
      }
    }
  }
}
