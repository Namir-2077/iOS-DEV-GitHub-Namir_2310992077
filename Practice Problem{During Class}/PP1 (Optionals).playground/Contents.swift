import UIKit

//Design a Student and Mentor class for an online course platform. Each Student *may or may not have a mentor assigned*. Every Mentor can *optionally* have a specialization. A student can attempt to fetch the mentor's specialization.
//> Only Students with *non-empty names and valid ages (>= 10)* should be allowed.
//> The method getMentorSpecialization() should return the specialization {if available}.
//> Use Optional Binding to safely unwrap optional values when accessing properties.
//> Use optional chaining to access the specialization from the mentor.

class Student {
    var name: String = ""
    var age: Int = 0
    var mentor: Mentor? = nil
    init?(name: String, age: Int, mentor: Mentor?) {
        if name != "" && age >= 10 {
            self.name = name
            self.age = age
            self.mentor = mentor
        }
//        if name == "" || age < 10 {
//            return nil
//        }
//        self.name = name
//        self.age = age
//        self.mentor = mentor
    }
    func gerMentorSpecialization() -> String? {
        return mentor?.specialization
    }
}

class Mentor {
    var specialization: String? = nil
    init(specialization: String?) {
        self.specialization = specialization
    }
}

let student1 = Student(name: "", age: 12, mentor: Mentor(specialization: "iOS"))
print(student1?.mentor?.specialization)
print(student1?.gerMentorSpecialization())

//Re-Check the code!!!
