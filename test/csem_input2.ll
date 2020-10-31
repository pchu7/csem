; ModuleID = '<stdin>'
source_filename = "<stdin>"

declare i32 @print(i8*, ...)

define i32 @main() {
  %a = alloca i32
  %c = alloca i32
  %b = alloca double
  %d = alloca double
  %1 = load i32, i32* %a
  %2 = load double, double* %b
  %3 = load i32, i32* %c
  %4 = load double, double* %d
  ret i32 0
}
