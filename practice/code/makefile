# 定义源代码目录和编译生成的字节码目录
SRC_DIRS = $(wildcard src/*)
BIN_DIRS = $(patsubst src/%,bin/%,$(SRC_DIRS))

# 定义编译器和编译选项
JC = javac
JFLAGS = -d

# 默认目标为帮助信息
default:
	@echo "Usage: make <filename>"

# 清理目标，删除编译生成的字节码文件
clean:
	$(RM) -r $(BIN_DIRS)

# 编译单个 Java 文件
$(BIN_DIRS)/%.class: $(SRC_DIRS)/%.java
	$(JC) $(JFLAGS) $(@D) $<

# 运行目标，用于运行特定字节码文件
run:
	java -cp $(BIN_DIRS) $(CLASS)

# 声明伪目标
.PHONY: default clean run
