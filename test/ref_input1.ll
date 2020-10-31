; ModuleID = '<stdin>'
source_filename = "<stdin>"

declare i32 @print(i8*, ...)

define i32 @main(i32 %x) {
  %x1 = alloca i32
  store i32 %x, i32* %x1
  %1 = load i32, i32* %x1
  %2 = icmp slt i32 %1, 15
  br i1 %2, label %L0, label %L1

L0:                                               ; preds = %0
  ret i32 88

L1:                                               ; preds = %0
  ret i32 21
}
