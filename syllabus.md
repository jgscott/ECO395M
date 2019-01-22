# ECO 395M: Data Mining and Statistical Learning  

## Course details

- Instructor: James Scott (james.scott@mccombs.utexas.edu)
- Office: GDC 7.516  
- Course website: http://www.github.com/jgscott/ECO395M/
- Office hours: Mondays and Wednesdays, 2-3 PM, in GDC 7.516.  
- Teaching assistant: Andrew Lee (ajlee@utexas.edu), office hours TBA.  

## Overview

This is a master's level course on data mining and statistical learning for students in the master's program in Economics at UT-Austin.  The course is intended as an overview, rather than an in-depth treatment of any particular topic.  We will move fast and cover a lot, but we will focus on practical applications rather than theory.  

[The course homepage](README.md) will have a detailed week by week description of what we're doing in class, together with topic-by-topic reading lists.  I'll post these notices as we move along in the semester.  But if you want to read ahead, you can pace yourself using the topics list below (see "Outline of topics").  

The prerequisites are the Statistics and Probability course and the Econometrics course in the Econ master's program.  

## Software

- Statistical computing: [R](http://www.r-project.org), which we will use via [RStudio](http://www.rstudio.com), a free, platform-independent graphical front-end for R.  Make sure you have both installed, along with the [RMarkdown package](http://rmarkdown.rstudio.com).  
- Other software: please [install Git and create a GitHub account](https://help.github.com/articles/set-up-git/).  You will use GitHub for version control and to submit your assignments.  


## Readings

The course readings involve a compilation of free, high-quality sources available online.    

* _ISL_: Selections from _An Introduction to Statistical Learning_ by James, Witten, Hastie, and Tibshirani.  The book is [freely available here](http://www-bcf.usc.edu/~gareth/ISL/).  I'll refer to it as "ISL" in the course outline.  We will pretty much move beginning to end through this book, in order.  
* _Elements_: selections from [_Elements of Statistical Learning_](http://statweb.stanford.edu/~tibs/ElemStatLearn/), by Hastie, Tibshirani, and Friedman.  A standard reference on data mining from a more statistical perspective.  Referrered to as "Elements" in the course outline.  This is a more advanced treatment of much of the material in ISL, and I will highlight selections from this book as optional, supplemental reading.  
* _Shalizi_: selections from [Advanced Data Analysis from an Elementary Point of View](http://www.stat.cmu.edu/~cshalizi/ADAfaEPoV/ADAfaEPoV.pdf), by Cosma Shalizi.  Another textbook whose author has kindly posted a free version on the web.  Referred to as "Shalizi" in the course outline.  As with "Elements," I will highlight selections from this book as optional, supplemental reading.  


## Outline of topics  

The core topics we will cover in this course are as follows.  The corresponding readings are in parentheses.  See the [course homepage](README.md) for more details on each topic.    
- The data scientist's toolbox: R; Markdown and RMarkdown; version control with Git and Github (lecture notes).  
- Basic data visualization (lecture notes).  
- Statistical learning: some introductory concepts (ISL Ch 1-2)
- Linear regression (ISL Ch 3).  
- Classification (ISL Ch 4).  
- Resampling methods (ISL Ch 5).   
- Regularization and feature selection in linear models (ISL Ch 6).  
- Nonlinear models (ISL Ch 7).  
- Trees and ensembles (ISL Ch 8).  
- Support vector machines (ISL Ch 9).  
- Latent feature models and principal component analysis (ISL Ch 10).  
- Clustering: k-means and hierarchical clustering (ISL Ch 10).  

If there's time, we will try to cover some or all of the following supplemental topics (readings TBA).  
- Networks: basic concepts and visualization.  
- Association rule mining.  
- Working with text data.  
- Monte Carlo simulation.  
- Data mining and causal inference.  
- Neural networks.  




## Assignments and grading  

There are no in-class exams and no final exam.  

Your grade for this course will come from:  
- 60% homework.  I will assign four homework assignments throughout the semester, which count for 15% of your final grade each.  I will post assignments on the [course homepage](README.md), along with their due dates.  
- 40% final project, which will be like a bigger, more complex version of your homework problems.  

### Homework  

The homework assignments consist mainly of analyzing some data and writing a report on what you've found.  Here's the submission protocol:  
- Prepare your report as a single RMarkdown file.  
- Knit the RMarkdown file to a Markdown output.  (Do not knit to HTML.)  
- E-mail the links for both the output (.md file) and the raw RMarkdown file (.Rmd) to our TA.  

Do not send an attachment.  Do not knit to an HTML file.  

### Late assignment grace policy

Sometimes we have bad days, bad weeks, and bad semesters. In an effort to accommodate any unexpected, unfortunate personal crisis, I have built a grace policy into the course: that is, a one-time, two-day grace period for one homework assignment.  You do not have to utilize this policy, but if you find yourself struggling with unexpected personal events, I encourage you to e-mail me and our TA as soon as possible to notify us that you are using our grace policy.   



### Final project  

The assignment for the final project is simple: pose an interesting question; collect a relevant data set; and use the data, in conjuction with the tools we have learned in class, to answer the question you have posed. Make sure to address any shortcomings in the answer provided by your data and analysis. You will be evaluated both on the technical correctness (50%) and the overall intellectual quality (50%) of your approach and write-up.  

This assignment is purposely open-ended, allowing you considerable freedom to follow a path dictacted by your own intellectual curiosity. Strive to write something that a statistically literate person of wide- ranging interests (for example, a future employer) would find engaging and impressive.  

The deliverable dates are as follows:  
- 5 PM on Friday, April 19, 2019: 2-page (max) project prospectus outlining the question, proposed methods, and data sources you will pursue.  The prospectus is ungraded, but it is an opportunity for you to get feedback on your idea and approach.  If you don't turn in a project prospectus on time, then you will not receive feedback on your idea.  
- 5 PM on Friday, May 10, 2019 (the last class day of the spring semester): the final project is due.   Because of the quick turn-around required to grade final projects, I unfortunately cannot extend the grace policy to encompass the project.  But remember, you have all semester to get this sorted.  

In case getting a data set proves too difficult, I will provide a "default" data set and project.  If you use this data set, I will impose a 93% ceiling (i.e. an A-) on your grade.  The last 7% is an incentive to be more creative and go with your own project.  If you are taking the "default" option, then just tell me so by April 19, in lieu of turning in a project prospectus.  


### Groups are allowed

You are welcome to work on the assignments and the final project in groups of up to 3 people.  (Groups aren't required; you can work on your own if you wish.)  If you are working in a group, put all of your names in alphabetical order at the top of each assignment, and submit a single set of files for all of you.  

If you'd like to work in a group but are having trouble coordinating with other class members, please let our TA or me know and we'll do our best to place you in a group.  

### Grade cutoffs

Plus/minus grades will be used for the final class grade for C grades and above.  I use the following minimum thresholds for letter grades:   
- A: 94.0  
- A-: 90.0  
- B+: 87.0  
- B: 84.0  
- B-: 80.0  
- C+: 77.0  
- C: 70.0  
- D: 60.0  

I do not round grades.  Attendance is not an explicit component of your class grade.  


## Miscellaneous policies and notices

### If you need help, please just ask :-)  

Your success in this class is important to me. We will all need accommodations becausewe all learn differently. If there are aspects of this course that prevent you from learning or exclude you, please let me know as soon as possible. Together we’ll develop strategies to meet both your needs and the requirements of the course. I also encourage you to reach out to the student resources available through UT. Many are listed on this syllabus, but I am happy to connect you with a person or Center if you would like.   This includes any of the following:  

- Services for Students with Disabilities.  This class respects and welcomes students of all backgrounds, identities, and abilities. If there are circumstances that make our learning environment and activities difficult, if you have medical information that you need to share with me, or if you need specific arrangements in case the building needs to be evacuated, please let me know. I am committed to creating an effective learning environment for all students, but I can only do so if you discuss your needs with me as early as possible. I promise to maintain the confidentiality of these discussions. If appropriate, also contact Services for Students with Disabilities, 512-471-6259 (voice) or 1-866-329- 3986 (video phone).  (http://ddce.utexas.edu/disability/about/)  
- Counseling and Mental Health Center.  Do your best to maintain a healthy lifestyle this semester by eating well, exercising, avoiding drugs and alcohol, getting enough sleep and taking some time to relax. This will help you achieve your goals and cope with stress.  Yet all of us benefit from support during times of struggle. You are not alone. There are many helpful resources available on campus and an important part of the college experience is learning how to ask for help. Asking for support sooner rather than later is often helpful.  If you or anyone you know experiences any academic stress, difficult life events, or feelings like anxiety or depression, we strongly encourage you to seek support.  (http://www.cmhc.utexas.edu/individualcounseling.html)  
- The Sanger Learning Center.  All students are welcome to take advantage of Sanger Center’s classes and workshops, private learning specialist appointments, peer academic coaching, and tutoring for more than 70 courses in 15 different subject areas. For more information, please visit (http://www.utexas.edu/ugs/slc) or call 512-471-3614 (JES A332).  


### Names and pronouns

Professional courtesy and sensitivity are especially important with respect to individuals and topics dealing with differences of race, culture, religion, politics, sexual orientation, gender, gender variance, and nationalities. Class rosters are provided to me with each student’s legal name. I will gladly honor your request to address you by an alternate name or gender pronoun. Please advise me of this preference early in the semester so that I may make appropriate changes to my records.  

### Academic Integrity  

Each student in the course is expected to abide by the University of Texas Honor Code: “As a student of The University of Texas at Austin, I shall abide by the core values of the University and uphold academic integrity.” Plagiarism is taken very seriously at UT. Therefore, if you use words or ideas that are not your own (or that you have used in previous class), you must cite your sources. Otherwise you will be guilty of plagiarism and subject to academic disciplinary action, including failure of the course. You are responsible for understanding UT’s Academic Honesty and the	University Honor Code which can be found at the following web address: [http://deanofstudents.utexas.edu/sjs/acint_student.php](http://deanofstudents.utexas.edu/sjs/acint_student.php)  


### Q-drops

If you want to drop a class after the 12th class day, you’ll need to execute a Q drop before the Q-drop deadline, which typically occurs near the middle of the semester. Under Texas law, you are only allowed six Q drops while you are in college at any public Texas institution. For more information, see: http://www.utexas.edu/ugs/csacc/academic/adddrop/qdrop
 


### Important Safety Information:  

If you have concerns about the safety or behavior of fellow students, TAs or Professors, call BCAL (the Behavior Concerns Advice Line):  512-232-5050. Your call can be anonymous.  Trust your instincts and share your concerns.

The following recommendations regarding emergency evacuation from the Office of Campus Safety and Security, 512-471-5767, http://www.utexas.edu/safety/.  
- Occupants of buildings on The University of Texas at Austin campus are required to evacuate buildings when a fire alarm is activated. Alarm activation or announcement requires exiting and assembling outside.  
- Familiarize yourself with all exit doors of each classroom and building you may occupy. Remember that the nearest exit door may not be the one you used when entering the building.  
- Students requiring assistance in evacuation shall inform their instructor in writing during the first week of class.
- In the event of an evacuation, follow the instruction of faculty or class instructors. Do not re-enter a building unless given instructions by the following: Austin Fire Department, The University of Texas at Austin Police Department, or Fire Prevention Services office.  
- Link to information regarding emergency evacuation routes and emergency procedures can be found at: www.utexas.edu/emergency

Further recommendations regarding emergency evacuation from the Office of Campus Safety and Security, 512-471-5767, http://www.utexas.edu/safety/



### Title IX Reporting

Title IX is a federal law that protects against sex and gender based discrimination, sexual harassment, sexual assault, sexual misconduct, dating/domestic violence and stalking at federally funded educational institutions. UT Austin is committed to fostering a learning and working environment free from discrimination in all its forms. When sexual misconduct occurs in our community, the university can:  
1.	Intervene to prevent harmful behavior from continuing or escalating.  
2.	Provide support and remedies to students and employees who have experienced harm or have become involved in a Title IX investigation.   
3.	Investigate and discipline violations of the university’s relevant policies.  

Faculty members and certain staff members are considered “Responsible Employees” or “Mandatory Reporters,” which means that they are required to report violations of Title IX to the Title IX Coordinator. I am a Responsible Employee and must report any Title IX related incidents that are disclosed in writing, discussion, or one-on-one. Before talking with me, or with any faculty or staff member about a Title IX related incident, be sure to ask whether they are a responsible employee.  If you want to speak with someone for support or remedies without making an official report to the university, email advocate@austin.utexas.edu.   For more information about reporting options and resources, visit titleix.utexas.edu or contact the Title IX Office at titleix@austin.utexas.edu. 

The following recommendations regarding emergency evacuation from the Office of Campus Safety and Security, 512-471-5767, http://www.utexas.edu/safety/


