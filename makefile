# binary, library, object, and source directories
CXX=g++
CC=gcc
OBJ=obj
SRC=src
CSEM=csem
REF=ref_csem

INPUT=input1
SRC=./inputs/$(INPUT).c

CLANG_PP=./test/clang_$(INPUT).pp.c
CLANG_BC=./test/clang_$(INPUT).bc
CLANG_LL=./test/clang_$(INPUT).ll
CLANG_ASM=./test/clang_$(INPUT).s
CLANG_OBJ=./test/clang_$(INPUT).o
CLANG_OUT=./test/csem_$(INPUT).out
CLANG_EXE=clang_exe

CSEM_PP=./test/csem_$(INPUT).pp.c
CSEM_BC=./test/csem_$(INPUT).bc
CSEM_LL=./test/csem_$(INPUT).ll
CSEM_ASM=./test/csem_$(INPUT).s
CSEM_OBJ=./test/csem_$(INPUT).o
CSEM_OUT=./test/csem_$(INPUT).out
CSEM_EXE=csem_exe

REF_PP=./test/ref_$(INPUT).pp.c
REF_BC=./test/ref_$(INPUT).bc
REF_LL=./test/ref_$(INPUT).ll
REF_ASM=./test/ref_$(INPUT).s
REF_OBJ=./test/ref_$(INPUT).o
REF_OUT=./test/ref_$(INPUT).out
REF_EXE=ref_csem_exe

LIBS=`llvm-config --libs core native --ldflags` -lpthread -ldl -lz -ltinfo
CFLAGS=-Wall -g -std=c++11 -DLEFTTORIGHT `llvm-config --cxxflags`

all: yacc objects

HEADERS = $(wildcare include/*.h) $(wildcard include/*.hpp)

CFILES = src/semutil.c src/sym.c src/scan.c
COBJECTS = obj/semutil.o obj/sym.o obj/scan.o

CPPFILES = src/main.cpp src/cgram.cpp src/sem.cpp
CPPOBJECTS = obj/main.o obj/cgram.o obj/sem.o

# Don't delete CSEM or any object file if make is killed or interrupted
.PRECIOUS: $(CSEM) $(CFILES) $(CPPFILES)

yacc:
	bison --yacc -vd -Wno-conflicts-sr src/cgram.y
	mv y.tab.c src/cgram.cpp
	mv y.tab.h include/y.tab.h
	rm y.output

objects: $(HEADERS) $(CPPFILES) $(CFILES)
	$(CC)  -I./include/ -g -c $(CFILES)
	$(CXX) -I./include/ -g -c $(CPPFILES) $(CFLAGS)
	mv *.o obj/
	$(CXX) $(CPPOBJECTS) $(COBJECTS) $(CFLAGS) $(LIBS) -o $(CSEM)
	rm -f *.dwo

print:
	clang -fPIE print.c -c -o test/print.o

clang_ll:
	clang -fPIE -DDEFAULT_CLANG -O0 $(SRC) -emit-llvm -c -o $(CLANG_BC)
	llvm-dis $(CLANG_BC) -o $(CLANG_LL)

ref_ll:
	clang -fPIE -E $(SRC) -o $(REF_PP)
	sed -i '/#/d' $(REF_PP)
	./$(REF) < $(REF_PP) > $(REF_LL)

csem_ll:
	clang -fPIE -E $(SRC) -o $(CSEM_PP)
	sed -i '/#/d' $(CSEM_PP)
	./$(CSEM) < $(CSEM_PP) > $(CSEM_LL)

clang_build: print clang_ll
	llc -relocation-model=pic $(CLANG_LL) -o $(CLANG_ASM)
	clang -fPIE $(CLANG_ASM) -c -o $(CLANG_OBJ)
	clang test/print.o $(CLANG_OBJ) -o $(CLANG_EXE)

ref_build: print ref_ll
	llc -relocation-model=pic $(REF_LL) -o $(REF_ASM)
	clang -fPIE $(REF_ASM) -c -o $(REF_OBJ)
	clang test/print.o $(REF_OBJ) -o $(REF_EXE)

csem_build: print csem_ll
	llc -relocation-model=pic $(CSEM_LL) -o $(CSEM_ASM)
	clang -fPIE $(CSEM_ASM) -c -o $(CSEM_OBJ)
	clang test/print.o $(CSEM_OBJ) -o $(CSEM_EXE)

diff: ref_build csem_build
	./ref_csem_exe > $(REF_OUT)
	./csem_exe > $(CSEM_OUT)
	diff $(REF_OUT) $(CSEM_OUT)

full_diff:
	make diff INPUT=input2
	make diff INPUT=input3
	make diff INPUT=input4
	make diff INPUT=input5
	make diff INPUT=input6
	make diff INPUT=input7
	make diff INPUT=input8

test_clean:
	rm -f clang_exe ref_csem_exe csem_exe test/*

clean: test_clean
	rm -f $(CSEM) tmp.c src/cgram.cpp include/y.tab.h obj/*

