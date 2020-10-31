; ModuleID = '<stdin>'
source_filename = "<stdin>"

declare i32 @print(i8*, ...)

define i32 @main() {
  %a = alloca i32
  %c = alloca i32
  %b = alloca double
  %d = alloca double
  %1 = load double, double* %b
  %2 = load i32, i32* %a
  br <null operand!>, label <badref>, label <badref>

L0:                                               ; No predecessors!
  %3 = load double, double* %d
  %4 = load i32, i32* %c
  br <null operand!>, label <badref>, label <badref>

L1:                                               ; No predecessors!
  br label %L2

L2:                                               ; preds = %L1
  br label %L3

L3:                                               ; preds = %L2
  ret i32 0
}
