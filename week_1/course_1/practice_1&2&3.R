### practice_1_question

# Craete variable called my.height.cm with your actual height in cm
my.height.cm <-176

# Craete variable called my.weight.cm with your actual weight in kg
my.weight.kg <-60

# Create my.height.m transfered by my.height.cm
my.height.m <- (my.height.cm)/100

# Create my.bmi with BMI(Body Mass Index) formula
my.bmi <- my.weight.kg/(my.height.m)^2

# Use if-else to print matched information
# Reference: http://www.tpech.gov.taipei/ct.asp?xItem=1794336&CtNode=30678&mp=109171
    if (my.bmi >= 35) {
        print(paste("Your bmi: ", my.bmi))
        print("重度肥胖!")
    } else if (my.bmi >= 30) {
        print(paste("Your bmi: ", my.bmi))
        print("中度肥胖!")
    } else if (my.bmi >= 27) {
        print(paste("Your bmi: ", my.bmi))
        print("輕度肥胖!")
    } else if (my.bmi >= 24) {
        print(paste("Your bmi: ", my.bmi))
        print("過重!")
    } else if (my.bmi >= 18.5) {
        print(paste("Your bmi: ", my.bmi))
        print("正常範圍")
    } else {
        print(paste("Your bmi: ", my.bmi))
        print("過輕!")
    }


------------------------------------------------------------------------------------------------------


### practice_2
### course_grade


# Create a vector called course.students.number, with data: c(1, 30)
course.student.number <- c(1,30)

# Create a variable csn, with data: length of course.student.number
csn <- length(course.student.number)

# Create a vector course.student.grade, with sample() function: x = c(55:100), size = csn
course.student.grade <- sample(x = c(55:100), size = csn)

# Assign course.student.number as names of the course.student.grade
names(course.student.grade) <- course.student.number

# Create csg.mean, with the mean value of course.student.grade
csg.mean <- mean(course.student.number)

# Create csg.max with the max value of course.student.grade
csg.max <- max(course.student.grade)

# Create csg.min with the min value of course.student.grade
csg.min <- min(course.student.grade)

# Create a vector csg.over.80, with the logical result of course.student.grade over 80
csg.over.80 <- course.student.grade >= 80

# Check csg.over.mean
csg.over.80

# Filter the course.student.grade with csg.over.mean
course.student.grade[csg.over.80]

# Print course information
print(paste("全班人數:", csn))
print(paste("全班平均：", csg.mean))
print(paste("全班最高：", csg.max))
print(paste("全班最低：", csg.min))

# Print over 80 details
# print(paste("高於80分總人數：", length(course.student.grade[csg.over.80])))
# print(paste("高於80分座號：", names(course.student.grade[csg.over.80])))



------------------------------------------------------------------------------------------------------


### practice_3_answer
### ptt_info_book

# 基本變數資訊
person.name <- c("Jiyuian", "Shawnroom", "Bigmoumou")
person.sex <- c("F", "M", "M")
person.id <- c("jiyuian520", "shawnn520", "moumou123")
person.days <- c(201, 37, 99)

# 使用data.frame()，並以上述4個向量建立person.df
person.df <- data.frame(person.name, person.sex, person.id, person.days)

# 查看person.df結構
str(person.df)

# 查看person.df summary
summary(person.df)

# 印出person.df
person.df

# 印出person.df第一列
person.df[1, ]

# 印出person.df第二列第三欄
person.df[2, 3]

# 使用$ 指定出person.df中person.id欄位
person.df$person.id

# 使用order(), 將person.df$person.days排序後, 建立days.position
days.postion <- order(person.df$person.days)

# 使用days.postion, 排序person.df
person.df[days.postion, ]

# 使用grepl()，找出person.df$person.id中有520精神的
spirit.520 <- grepl("520", person.df$person.id)

# 篩選出520家族的成員
person.df[spirit.520, ]
