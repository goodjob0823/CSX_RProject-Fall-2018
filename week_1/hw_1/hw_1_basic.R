
### hw_1_question


########################################################### Task 1

# 查看內建資料集: 鳶尾花(iris)資料集
iris

# 使用dim(), 回傳iris的列數與欄數
dim(iris)

# 使用head() 回傳iris的前六列
head(iris)

# 使用tail() 回傳iris的後六列
tail(iris)

# 使用str()
str(iris)

# 使用summary() 查看iris敘述性統計、類別型資料概述。
summary(iris)

########################################################### Task 2

# 使用for loop 印出九九乘法表
# Ex: (1x1=1 1x2=2...1x9=9 ~ 9x1=9 9x2=18... 9x9=81)
for (i in 1:9){
    for (j in 1:9){
        print(sprintf("%d X %d = %d",i,j,i*j))
    }
}


########################################################### Task 3

# 使用sample(), 產出10個介於10~100的整數，並存在變數 nums

nums <- sample(10:100, size=10, replace = TRUE)


# 查看nums
nums

# 1.使用for loop 以及 if-else，印出大於50的偶數，並提示("偶數且大於50": 數字value)
# 2.特別規則：若數字為66，則提示("太66666666666了")並中止迴圈。

for (i in nums){
    if (i > 50 && i%%2 == 0){
        print(paste("\"偶數且大於50\":", i))
    }
    if(i == 66){
        print("太66666666666了")
        break
    }
}


########################################################### Task 4

# 請寫一段程式碼，能判斷輸入之西元年分 year 是否為閏年


n <- 0
readInput <- function(){
    return(n)
}

    while(1)
    {
        if( n %% 400==0 || ( n %% 4==0 & n %% 100!=0)){
    print("閏年")
    break
    }
else{
    print("平年")
    }
    return
}


########################################################### Task 5

# 猜數字遊戲
# 基本功能
# 1. 請寫一個由"電腦隨機產生"不同數字的四位數(1A2B遊戲)
# 2. 玩家可"重覆"猜電腦所產生的數字，並提示猜測的結果(EX:1A2B)
# 3. 一旦猜對，系統可自動計算玩家猜測的次數

# 額外功能：每次玩家輸入完四個數字後，檢查玩家的輸入是否正確(錯誤檢查)


answer <- sample(0:9,4)
answer
a <- 0
b <- 0

while (TRUE){
    print("請輸入4個不重複的數")
    guess = scan()
    count <- count+1
    a <- 0
    b <- 0
    for(i in 1:4){
        if(guess[i]==answer[i]){
            a<-a+1
        }
        for(j in 1:4){
            if (guess[i]==answer[j] & i!=j){
                b<-b+1
            }
        }
    }
    print(paste0(a,"A",b,"B"))
    if(a == 4 & b == 0){
        print("恭喜你猜中了!")
        print(paste("您總共輸入",count,"次"))
        break
    }
}




