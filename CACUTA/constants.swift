//
//  constants.swift
//  UTA//
//  Created by Ehab Saifan on 6/9/16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

//enum Area: String {
//    case One = "1"
//    case Two =  "2"
//    case Three = "4"
//    case Four = "4"
//    case Five = "5"
//    case Six = "6"
//}

enum Entities: String {
    case University = "University"
    case Course = "Course"
    case Student = "Student"
    case FavoriteCourse = "FavoriteCourse"
    case Area = "Area"
}

enum IsCourseCompleted : String {
    case Completed = "Completed"
    case NotCompleted = "Not Completed"
}

let SectionsList = ["A","B","C","D","E","F","G","H","I","J","K","L"]
let AreasList = ["Area 1", "Area 2", "Area 3", "Area 4", "Area 5", "Area 6"]
let CollegesList = ["Allan Hancock College", "Antelope Valley College", "Barstow Butte–Glenn College", "Cabrillo College", "Cerritos College", "Chabot–Las Positas College", "Chaffey College", "Citrus College", "Coast College", "Compton College", "Contra Costa College", "Copper Mountain College", "Desert College", "El Camino College", "Feather River College", "Foothill–De Anza College", "Gavilan College", "Glendale College", "Grossmont–Cuyamaca College", "Yosemite College", "Yuba College", "West Hills College", "West Kern College", "West Valley–Mission"]


let Publisher = "Publisher"
let Date  = "Date"
let HeadLine = "HeadLine"
let Details = "Details"

let LocalAnnouncments = ["Announcments" : [
    [Publisher: "Deanza College", Date: "2016-07-27T11:24:00Z", HeadLine: "Last Day To Drop Classes", Details: "Last day to drop for a full refund or credit for all students (quarter-length classes only). Refund deadlines for all non quarter-length classes are in MyPortal, \"View Your Class Schedule\" link. Drop date is enforced."],
    [Publisher: "Deanza College", Date: "2016-07-29T11:24:00Z", HeadLine: "Financial Aid Refund Date", Details: "For information on Refund Dates, please see our Disbursement and Refund Information page.  Check your MyPortal for your financial aid information."]]
]

let PublicAnnouncments = ["Announcments" : [
    [Publisher: "UC Berkley", Date: "2016-08-07T11:24:00Z", HeadLine: "Transfer Admission Agreement / Guarantee (TAA/TAG)", Details: "UC will notify TAG applicants about the status of their TAG application no later than November 15, 2016.  Students can log on to the UC Transfer Admission Planner (TAP) system to check for messages and to track the status of their TAG application."],
    
    [Publisher: "UC Daves", Date: "2016-07-20T11:24:00Z", HeadLine: "Financial Aid Refund Date", Details: "For prospective transfer applicants, we offer Transfer Information Sessions on selected dates listed below. Led by an Admissions Adviser, these sessions will discuss:\n-junior-level transfer admissions requirements\n-selection criteria for UC Santa Cruz\n-selective majors requiring specific academic preparation prior to admission\n-policies such as credit limitations and repeated courses\nNOTE:  If you are seeking general information about UCSC, the academic programs, and support services available, please consider signing up for a campus tour first. The Transfer Information Session focuses solely on the admissions process.\nWe are unable to review transcripts.  However, if you have an updated UC Transfer Admission Planner (UC TAP), we will assess your academic progress and offer you guidance provided you:\n1. Update your UC TAP account with all coursework through the present term\n2. Check the UC Santa Cruz Transfer Preparation Program box\n3. E-mail transfer@ucsc.edu at least seven (7) days prior to your Transfer Information Session date\nWe highly encourage all California community college students to begin and maintain a UC TAP account."]]
]


let ClassArea = "class_area"
let ClassCode = "class_code"
let ClassCollege = "class_college"
let ClassDepart = "class_depart"
let ClassDescript = "class_descript"
let ClassGPA = "class_gpa"
let ClassName = "class_name"
let ClassSubArea = "class_subArea"
let ClassUnits = "class_units"
let ClassIsTaken = "class_isTaken"

let CourseArea = "areaName"
let CourseCode = "code"
let CourseCollege = "college"
let CourseDepart = "department"
let CourseDescript = "about"
let CourseName = "name"
let CourseSubArea = "subArea"
let CourseUnits = "numOfUnits"

let UnivEstab = "establishmentYear"
let UnivURL = "url"
let UnivRank = "rank"
let UnivName = "name"
let UnivDescript = "about"
let UnivAssist = "assistLink"
let UnivAGPA = "averageGPA"
let UnivAcron = "acronym"
let UnivAdmRate = "admissionRate"

let AreaNote = "notes"
let AreaMinUnits = "minRequierdUnits"
let AreaTitle = "title"
let AreaName = "name"
let AreaDescript = "about"
let AreaSecCount = "numOfSections"

let StdProfileImage = "image"
let StdName = "name"
let StdGPA = "gpa"
let StdUnivChoive = "targetUniversity"
let StdCollege = "college"
let StdID = "studentID"
let StdPassword = "password"

//CSV Headers:
//college,area,sub_area,dept,course_num,units,description,name,acronym,year_founded,transfer_admission_rate,us_rank,average_gpa,logo_emblem,assist,web_address,title,notes,min_units
let Name = "name"
let College = "college"
let Area = "area"
let SubArea = "sub_area"
let Depart = "dept"
let CourseNum = "course_num"
let Units = "units"
let IsTaken = "class_isTaken"
let Grade = "course_grade"
let Descript = "description"
let SectionsCount = "sections_count"

let Acron = "acronym"
let YearFounded = "year_founded"
let TransAdmRate = "transfer_admission_rate"
let USRank = "us_rank"
let AGPA = "average_gpa"
let Logo = "logo_emblem"
let Assist = "assist"
let WebURL = "web_address"

let Title = "title"
let Note = "notes"
let MinUnits = "min_units"

// Links
let STDPORTAL = URL(string: "https://myportal.fhda.edu/cp/home/displaylogin")
let IGETC = URL(string: "http://www.deanza.edu/faculty/nickeldon/igetc.html")
let ASSIST = URL(string: "http://www.assist.org/web-assist/welcome.html")

